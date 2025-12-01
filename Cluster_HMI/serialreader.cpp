#include "serialreader.h"
#include <QDebug>

SerialReader::SerialReader(QObject *parent)
    : QObject(parent),
    m_serialPort(new QSerialPort(this)),
    m_connected(false),
    m_speed(0),
    m_battery(0)
{
    connect(m_serialPort, &QSerialPort::readyRead, this, &SerialReader::readData);
    connect(m_serialPort, &QSerialPort::errorOccurred, this, &SerialReader::handleError);
}

SerialReader::~SerialReader()
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
    }
}

void SerialReader::setPortName(const QString &name)
{
    if (m_portName != name) {
        m_portName = name;
        emit portNameChanged();
    }
}

bool SerialReader::connectToPort()
{
    if (m_portName.isEmpty()) {
        emit errorOccurred("Port name is empty!");
        return false;
    }

    if (m_serialPort->isOpen()) {
        m_serialPort->close();
    }

    m_serialPort->setPortName(m_portName);
    m_serialPort->setBaudRate(QSerialPort::Baud115200);
    m_serialPort->setDataBits(QSerialPort::Data8);
    m_serialPort->setParity(QSerialPort::NoParity);
    m_serialPort->setStopBits(QSerialPort::OneStop);
    m_serialPort->setFlowControl(QSerialPort::NoFlowControl);

    if (m_serialPort->open(QIODevice::ReadOnly)) {
        m_connected = true;
        emit connectedChanged();
        qDebug() << "Connected to" << m_portName;
        return true;
    } else {
        m_connected = false;
        emit connectedChanged();
        emit errorOccurred("Failed to open port: " + m_serialPort->errorString());
        qDebug() << "Failed to open" << m_portName << ":" << m_serialPort->errorString();
        return false;
    }
}

void SerialReader::disconnectPort()
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
        m_connected = false;
        emit connectedChanged();
        qDebug() << "Disconnected from" << m_portName;
    }
}

QStringList SerialReader::availablePorts()
{
    QStringList ports;
    const auto infos = QSerialPortInfo::availablePorts();

    for (const QSerialPortInfo &info : infos) {
        QString portInfo = info.portName();

        // Thêm thông tin chi tiết
        if (!info.description().isEmpty()) {
            portInfo += " - " + info.description();
        }
        if (!info.manufacturer().isEmpty()) {
            portInfo += " (" + info.manufacturer() + ")";
        }

        ports << portInfo;
        qDebug() << "Found port:" << portInfo;
    }

    return ports;
}

bool SerialReader::autoConnect()
{
    const auto infos = QSerialPortInfo::availablePorts();

    for (const QSerialPortInfo &info : infos) {
        // Tìm ESP32 dựa trên description hoặc manufacturer
        QString desc = info.description().toLower();
        QString manu = info.manufacturer().toLower();

        // ESP32 thường hiển thị là CP210x hoặc CH340
        if (desc.contains("cp210") || desc.contains("ch340") ||
            desc.contains("usb") || desc.contains("serial") ||
            manu.contains("silicon labs") || manu.contains("qinheng")) {

            setPortName(info.portName());
            qDebug() << "Auto-detected ESP32 at:" << info.portName();

            if (connectToPort()) {
                return true;
            }
        }
    }

    emit errorOccurred("ESP32 not found! Please check connection.");
    return false;
}

void SerialReader::readData()
{
    m_buffer.append(m_serialPort->readAll());

    // Xử lý từng dòng
    while (m_buffer.contains('\n')) {
        int index = m_buffer.indexOf('\n');
        QByteArray line = m_buffer.left(index);
        m_buffer.remove(0, index + 1);

        QString data = QString::fromUtf8(line).trimmed();
        if (!data.isEmpty()) {
            parseData(data);
        }
    }
}

void SerialReader::parseData(const QString &data)
{
    // Định dạng: S<speed>B<battery>
    // Ví dụ: S120B75

    int speedIndex = data.indexOf('S');
    int batteryIndex = data.indexOf('B');

    if (speedIndex != -1 && batteryIndex != -1 && speedIndex < batteryIndex) {
        // Lấy giá trị speed
        QString speedStr = data.mid(speedIndex + 1, batteryIndex - speedIndex - 1);
        bool ok;
        qreal newSpeed = speedStr.toDouble(&ok);

        if (ok && newSpeed != m_speed) {
            m_speed = newSpeed;
            emit speedChanged();
        }

        // Lấy giá trị battery
        QString batteryStr = data.mid(batteryIndex + 1);
        qreal newBattery = batteryStr.toDouble(&ok);

        if (ok && newBattery != m_battery) {
            m_battery = newBattery;
            emit batteryChanged();
        }

        // Debug
        // qDebug() << "Speed:" << m_speed << "Battery:" << m_battery;
    }
}

void SerialReader::handleError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::ResourceError) {
        emit errorOccurred("Device disconnected!");
        disconnectPort();
    }
}
