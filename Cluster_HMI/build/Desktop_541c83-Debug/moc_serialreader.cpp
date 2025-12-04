/****************************************************************************
** Meta object code from reading C++ file 'serialreader.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.13)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../serialreader.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'serialreader.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.13. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_SerialReader_t {
    QByteArrayData data[37];
    char stringdata0[445];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_SerialReader_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_SerialReader_t qt_meta_stringdata_SerialReader = {
    {
QT_MOC_LITERAL(0, 0, 12), // "SerialReader"
QT_MOC_LITERAL(1, 13, 16), // "connectedChanged"
QT_MOC_LITERAL(2, 30, 0), // ""
QT_MOC_LITERAL(3, 31, 15), // "portNameChanged"
QT_MOC_LITERAL(4, 47, 12), // "speedChanged"
QT_MOC_LITERAL(5, 60, 14), // "batteryChanged"
QT_MOC_LITERAL(6, 75, 16), // "headlightChanged"
QT_MOC_LITERAL(7, 92, 14), // "parkingChanged"
QT_MOC_LITERAL(8, 107, 12), // "lightChanged"
QT_MOC_LITERAL(9, 120, 10), // "fogChanged"
QT_MOC_LITERAL(10, 131, 15), // "turnLeftChanged"
QT_MOC_LITERAL(11, 147, 16), // "turnRightChanged"
QT_MOC_LITERAL(12, 164, 15), // "seatbeltChanged"
QT_MOC_LITERAL(13, 180, 15), // "warning1Changed"
QT_MOC_LITERAL(14, 196, 15), // "warning2Changed"
QT_MOC_LITERAL(15, 212, 13), // "errorOccurred"
QT_MOC_LITERAL(16, 226, 5), // "error"
QT_MOC_LITERAL(17, 232, 8), // "readData"
QT_MOC_LITERAL(18, 241, 11), // "handleError"
QT_MOC_LITERAL(19, 253, 28), // "QSerialPort::SerialPortError"
QT_MOC_LITERAL(20, 282, 13), // "connectToPort"
QT_MOC_LITERAL(21, 296, 14), // "disconnectPort"
QT_MOC_LITERAL(22, 311, 14), // "availablePorts"
QT_MOC_LITERAL(23, 326, 11), // "autoConnect"
QT_MOC_LITERAL(24, 338, 9), // "connected"
QT_MOC_LITERAL(25, 348, 8), // "portName"
QT_MOC_LITERAL(26, 357, 5), // "speed"
QT_MOC_LITERAL(27, 363, 7), // "battery"
QT_MOC_LITERAL(28, 371, 9), // "headlight"
QT_MOC_LITERAL(29, 381, 7), // "parking"
QT_MOC_LITERAL(30, 389, 5), // "light"
QT_MOC_LITERAL(31, 395, 3), // "fog"
QT_MOC_LITERAL(32, 399, 8), // "turnLeft"
QT_MOC_LITERAL(33, 408, 9), // "turnRight"
QT_MOC_LITERAL(34, 418, 8), // "seatbelt"
QT_MOC_LITERAL(35, 427, 8), // "warning1"
QT_MOC_LITERAL(36, 436, 8) // "warning2"

    },
    "SerialReader\0connectedChanged\0\0"
    "portNameChanged\0speedChanged\0"
    "batteryChanged\0headlightChanged\0"
    "parkingChanged\0lightChanged\0fogChanged\0"
    "turnLeftChanged\0turnRightChanged\0"
    "seatbeltChanged\0warning1Changed\0"
    "warning2Changed\0errorOccurred\0error\0"
    "readData\0handleError\0QSerialPort::SerialPortError\0"
    "connectToPort\0disconnectPort\0"
    "availablePorts\0autoConnect\0connected\0"
    "portName\0speed\0battery\0headlight\0"
    "parking\0light\0fog\0turnLeft\0turnRight\0"
    "seatbelt\0warning1\0warning2"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_SerialReader[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      20,   14, // methods
      13,  138, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
      14,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,  114,    2, 0x06 /* Public */,
       3,    0,  115,    2, 0x06 /* Public */,
       4,    0,  116,    2, 0x06 /* Public */,
       5,    0,  117,    2, 0x06 /* Public */,
       6,    0,  118,    2, 0x06 /* Public */,
       7,    0,  119,    2, 0x06 /* Public */,
       8,    0,  120,    2, 0x06 /* Public */,
       9,    0,  121,    2, 0x06 /* Public */,
      10,    0,  122,    2, 0x06 /* Public */,
      11,    0,  123,    2, 0x06 /* Public */,
      12,    0,  124,    2, 0x06 /* Public */,
      13,    0,  125,    2, 0x06 /* Public */,
      14,    0,  126,    2, 0x06 /* Public */,
      15,    1,  127,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      17,    0,  130,    2, 0x08 /* Private */,
      18,    1,  131,    2, 0x08 /* Private */,

 // methods: name, argc, parameters, tag, flags
      20,    0,  134,    2, 0x02 /* Public */,
      21,    0,  135,    2, 0x02 /* Public */,
      22,    0,  136,    2, 0x02 /* Public */,
      23,    0,  137,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,   16,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 19,   16,

 // methods: parameters
    QMetaType::Bool,
    QMetaType::Void,
    QMetaType::QStringList,
    QMetaType::Bool,

 // properties: name, type, flags
      24, QMetaType::Bool, 0x00495001,
      25, QMetaType::QString, 0x00495103,
      26, QMetaType::QReal, 0x00495001,
      27, QMetaType::QReal, 0x00495001,
      28, QMetaType::Bool, 0x00495001,
      29, QMetaType::Bool, 0x00495001,
      30, QMetaType::Bool, 0x00495001,
      31, QMetaType::Bool, 0x00495001,
      32, QMetaType::Bool, 0x00495001,
      33, QMetaType::Bool, 0x00495001,
      34, QMetaType::Bool, 0x00495001,
      35, QMetaType::Bool, 0x00495001,
      36, QMetaType::Bool, 0x00495001,

 // properties: notify_signal_id
       0,
       1,
       2,
       3,
       4,
       5,
       6,
       7,
       8,
       9,
      10,
      11,
      12,

       0        // eod
};

void SerialReader::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<SerialReader *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->connectedChanged(); break;
        case 1: _t->portNameChanged(); break;
        case 2: _t->speedChanged(); break;
        case 3: _t->batteryChanged(); break;
        case 4: _t->headlightChanged(); break;
        case 5: _t->parkingChanged(); break;
        case 6: _t->lightChanged(); break;
        case 7: _t->fogChanged(); break;
        case 8: _t->turnLeftChanged(); break;
        case 9: _t->turnRightChanged(); break;
        case 10: _t->seatbeltChanged(); break;
        case 11: _t->warning1Changed(); break;
        case 12: _t->warning2Changed(); break;
        case 13: _t->errorOccurred((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 14: _t->readData(); break;
        case 15: _t->handleError((*reinterpret_cast< QSerialPort::SerialPortError(*)>(_a[1]))); break;
        case 16: { bool _r = _t->connectToPort();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 17: _t->disconnectPort(); break;
        case 18: { QStringList _r = _t->availablePorts();
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 19: { bool _r = _t->autoConnect();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::connectedChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::portNameChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::speedChanged)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::batteryChanged)) {
                *result = 3;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::headlightChanged)) {
                *result = 4;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::parkingChanged)) {
                *result = 5;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::lightChanged)) {
                *result = 6;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::fogChanged)) {
                *result = 7;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::turnLeftChanged)) {
                *result = 8;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::turnRightChanged)) {
                *result = 9;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::seatbeltChanged)) {
                *result = 10;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::warning1Changed)) {
                *result = 11;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::warning2Changed)) {
                *result = 12;
                return;
            }
        }
        {
            using _t = void (SerialReader::*)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::errorOccurred)) {
                *result = 13;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<SerialReader *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< bool*>(_v) = _t->isConnected(); break;
        case 1: *reinterpret_cast< QString*>(_v) = _t->portName(); break;
        case 2: *reinterpret_cast< qreal*>(_v) = _t->speed(); break;
        case 3: *reinterpret_cast< qreal*>(_v) = _t->battery(); break;
        case 4: *reinterpret_cast< bool*>(_v) = _t->headlight(); break;
        case 5: *reinterpret_cast< bool*>(_v) = _t->parking(); break;
        case 6: *reinterpret_cast< bool*>(_v) = _t->light(); break;
        case 7: *reinterpret_cast< bool*>(_v) = _t->fog(); break;
        case 8: *reinterpret_cast< bool*>(_v) = _t->turnLeft(); break;
        case 9: *reinterpret_cast< bool*>(_v) = _t->turnRight(); break;
        case 10: *reinterpret_cast< bool*>(_v) = _t->seatbelt(); break;
        case 11: *reinterpret_cast< bool*>(_v) = _t->warning1(); break;
        case 12: *reinterpret_cast< bool*>(_v) = _t->warning2(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<SerialReader *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 1: _t->setPortName(*reinterpret_cast< QString*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject SerialReader::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_SerialReader.data,
    qt_meta_data_SerialReader,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *SerialReader::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SerialReader::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_SerialReader.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int SerialReader::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 20)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 20;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 20)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 20;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 13;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 13;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 13;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 13;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 13;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 13;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void SerialReader::connectedChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void SerialReader::portNameChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void SerialReader::speedChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void SerialReader::batteryChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void SerialReader::headlightChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void SerialReader::parkingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void SerialReader::lightChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void SerialReader::fogChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void SerialReader::turnLeftChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}

// SIGNAL 9
void SerialReader::turnRightChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, nullptr);
}

// SIGNAL 10
void SerialReader::seatbeltChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 10, nullptr);
}

// SIGNAL 11
void SerialReader::warning1Changed()
{
    QMetaObject::activate(this, &staticMetaObject, 11, nullptr);
}

// SIGNAL 12
void SerialReader::warning2Changed()
{
    QMetaObject::activate(this, &staticMetaObject, 12, nullptr);
}

// SIGNAL 13
void SerialReader::errorOccurred(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 13, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
