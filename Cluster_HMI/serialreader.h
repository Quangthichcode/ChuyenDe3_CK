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

    // Thêm properties cho các nút
    Q_PROPERTY(bool headlight READ headlight NOTIFY headlightChanged)
    Q_PROPERTY(bool parking READ parking NOTIFY parkingChanged)
    Q_PROPERTY(bool light READ light NOTIFY lightChanged)
    Q_PROPERTY(bool fog READ fog NOTIFY fogChanged)
    Q_PROPERTY(bool turnLeft READ turnLeft NOTIFY turnLeftChanged)
    Q_PROPERTY(bool turnRight READ turnRight NOTIFY turnRightChanged)
    Q_PROPERTY(bool seatbelt READ seatbelt NOTIFY seatbeltChanged)
    Q_PROPERTY(bool warning1 READ warning1 NOTIFY warning1Changed)
    Q_PROPERTY(bool warning2 READ warning2 NOTIFY warning2Changed)

public:
    explicit SerialReader(QObject *parent = nullptr);
    ~SerialReader();

    bool isConnected() const { return m_connected; }
    QString portName() const { return m_portName; }
    qreal speed() const { return m_speed; }
    qreal battery() const { return m_battery; }

    // Getters cho các nút
    bool headlight() const { return m_headlight; }
    bool parking() const { return m_parking; }
    bool light() const { return m_light; }
    bool fog() const { return m_fog; }
    bool turnLeft() const { return m_turnLeft; }
    bool turnRight() const { return m_turnRight; }
    bool seatbelt() const { return m_seatbelt; }
    bool warning1() const { return m_warning1; }
    bool warning2() const { return m_warning2; }

    void setPortName(const QString &name);

    Q_INVOKABLE bool connectToPort();
    Q_INVOKABLE void disconnectPort();
    Q_INVOKABLE QStringList availablePorts();
    Q_INVOKABLE bool autoConnect();

signals:
    void connectedChanged();
    void portNameChanged();
    void speedChanged();
    void batteryChanged();

    // Signals cho các nút
    void headlightChanged();
    void parkingChanged();
    void lightChanged();
    void fogChanged();
    void turnLeftChanged();
    void turnRightChanged();
    void seatbeltChanged();
    void warning1Changed();
    void warning2Changed();

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

    // Trạng thái các nút
    bool m_headlight;
    bool m_parking;
    bool m_light;
    bool m_fog;
    bool m_turnLeft;
    bool m_turnRight;
    bool m_seatbelt;
    bool m_warning1;
    bool m_warning2;

    QByteArray m_buffer;

    void parseData(const QString &data);
};

#endif // SERIALREADER_H
