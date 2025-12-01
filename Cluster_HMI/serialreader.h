#ifndef SERIALREADER_H
#define SERIALREADER_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QTimer>

class SerialReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ isConnected NOTIFY connectedChanged)
    Q_PROPERTY(QString portName READ portName WRITE setPortName NOTIFY portNameChanged)
    Q_PROPERTY(qreal speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(qreal battery READ battery NOTIFY batteryChanged)

public:
    explicit SerialReader(QObject *parent = nullptr);
    ~SerialReader();

    bool isConnected() const { return m_connected; }
    QString portName() const { return m_portName; }
    qreal speed() const { return m_speed; }
    qreal battery() const { return m_battery; }

    void setPortName(const QString &name);

    // Hàm QML có thể gọi
    Q_INVOKABLE bool connectToPort();
    Q_INVOKABLE void disconnectPort();
    Q_INVOKABLE QStringList availablePorts();
    Q_INVOKABLE bool autoConnect(); // Tự động tìm và kết nối ESP32

signals:
    void connectedChanged();
    void portNameChanged();
    void speedChanged();
    void batteryChanged();
    void errorOccurred(QString error);

private slots:
    void readData();
    void handleError(QSerialPort::SerialPortError error);

private:
    QSerialPort *m_serialPort;
    QString m_portName;
    bool m_connected;
    qreal m_speed;
    qreal m_battery;
    QByteArray m_buffer;

    void parseData(const QString &data);
};

#endif // SERIALREADER_H
