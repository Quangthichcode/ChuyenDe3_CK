#include "serialreader.h"
#include <QDebug>
#include <QRegularExpression>

SerialReader::SerialReader(QObject *parent)
    : QObject(parent),
    m_serialPort(new QSerialPort(this)),
    m_connected(false),
    m_speed(0),
    m_battery(0),
    m_headlight(false),
    m_parking(false),
    m_light(false),
    m_fog(false),
    m_turnLeft(false),
    m_turnRight(false),
    m_seatbelt(true),
    m_warning1(false),
    m_warning2(false)
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
        QString desc = info.description().toLower();
        QString manu = info.manufacturer().toLower();

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
    // Format: S<speed>B<battery>H<0/1>P<0/1>L<0/1>F<0/1>TL<0/1>TR<0/1>SB<0/1>W1<0/1>W2<0/1>
    // Ví dụ: S120B75H1P0L1F0TL0TR1SB1W10W20

    // Dùng Regular Expression để parse
    QRegularExpression re("S(\\d+)B(\\d+)H([01])P([01])L([01])F([01])TL([01])TR([01])SB([01])W1([01])W2([01])");
    QRegularExpressionMatch match = re.match(data);

    if (match.hasMatch()) {
        // Speed
        qreal newSpeed = match.captured(1).toDouble();
        if (newSpeed != m_speed) {
            m_speed = newSpeed;
            emit speedChanged();
        }

        // Battery
        qreal newBattery = match.captured(2).toDouble();
        if (newBattery != m_battery) {
            m_battery = newBattery;
            emit batteryChanged();
        }

        // Headlight
        bool newHeadlight = (match.captured(3) == "1");
        if (newHeadlight != m_headlight) {
            m_headlight = newHeadlight;
            emit headlightChanged();
        }

        // Parking
        bool newParking = (match.captured(4) == "1");
        if (newParking != m_parking) {
            m_parking = newParking;
            emit parkingChanged();
        }

        // Light
        bool newLight = (match.captured(5) == "1");
        if (newLight != m_light) {
            m_light = newLight;
            emit lightChanged();
        }

        // Fog
        bool newFog = (match.captured(6) == "1");
        if (newFog != m_fog) {
            m_fog = newFog;
            emit fogChanged();
        }

        // Turn Left
        bool newTurnLeft = (match.captured(7) == "1");
        if (newTurnLeft != m_turnLeft) {
            m_turnLeft = newTurnLeft;
            emit turnLeftChanged();
        }

        // Turn Right
        bool newTurnRight = (match.captured(8) == "1");
        if (newTurnRight != m_turnRight) {
            m_turnRight = newTurnRight;
            emit turnRightChanged();
        }

        // Seatbelt
        bool newSeatbelt = (match.captured(9) == "1");
        if (newSeatbelt != m_seatbelt) {
            m_seatbelt = newSeatbelt;
            emit seatbeltChanged();
        }

        // Warning 1
        bool newWarning1 = (match.captured(10) == "1");
        if (newWarning1 != m_warning1) {
            m_warning1 = newWarning1;
            emit warning1Changed();
        }

        // Warning 2
        bool newWarning2 = (match.captured(11) == "1");
        if (newWarning2 != m_warning2) {
            m_warning2 = newWarning2;
            emit warning2Changed();
        }

        // Debug (uncomment để xem)
        // qDebug() << "Parsed:" << "S=" << m_speed << "B=" << m_battery
        //          << "H=" << m_headlight << "P=" << m_parking;
    } else {
        // Format không đúng
        qDebug() << "Invalid data format:" << data;
    }
}

void SerialReader::handleError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::ResourceError) {
        emit errorOccurred("Device disconnected!");
        disconnectPort();
    }
}
