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
    QByteArrayData data[19];
    char stringdata0[234];
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
QT_MOC_LITERAL(6, 75, 13), // "errorOccurred"
QT_MOC_LITERAL(7, 89, 5), // "error"
QT_MOC_LITERAL(8, 95, 8), // "readData"
QT_MOC_LITERAL(9, 104, 11), // "handleError"
QT_MOC_LITERAL(10, 116, 28), // "QSerialPort::SerialPortError"
QT_MOC_LITERAL(11, 145, 13), // "connectToPort"
QT_MOC_LITERAL(12, 159, 14), // "disconnectPort"
QT_MOC_LITERAL(13, 174, 14), // "availablePorts"
QT_MOC_LITERAL(14, 189, 11), // "autoConnect"
QT_MOC_LITERAL(15, 201, 9), // "connected"
QT_MOC_LITERAL(16, 211, 8), // "portName"
QT_MOC_LITERAL(17, 220, 5), // "speed"
QT_MOC_LITERAL(18, 226, 7) // "battery"

    },
    "SerialReader\0connectedChanged\0\0"
    "portNameChanged\0speedChanged\0"
    "batteryChanged\0errorOccurred\0error\0"
    "readData\0handleError\0QSerialPort::SerialPortError\0"
    "connectToPort\0disconnectPort\0"
    "availablePorts\0autoConnect\0connected\0"
    "portName\0speed\0battery"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_SerialReader[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      11,   14, // methods
       4,   84, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       5,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   69,    2, 0x06 /* Public */,
       3,    0,   70,    2, 0x06 /* Public */,
       4,    0,   71,    2, 0x06 /* Public */,
       5,    0,   72,    2, 0x06 /* Public */,
       6,    1,   73,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       8,    0,   76,    2, 0x08 /* Private */,
       9,    1,   77,    2, 0x08 /* Private */,

 // methods: name, argc, parameters, tag, flags
      11,    0,   80,    2, 0x02 /* Public */,
      12,    0,   81,    2, 0x02 /* Public */,
      13,    0,   82,    2, 0x02 /* Public */,
      14,    0,   83,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    7,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 10,    7,

 // methods: parameters
    QMetaType::Bool,
    QMetaType::Void,
    QMetaType::QStringList,
    QMetaType::Bool,

 // properties: name, type, flags
      15, QMetaType::Bool, 0x00495001,
      16, QMetaType::QString, 0x00495103,
      17, QMetaType::QReal, 0x00495001,
      18, QMetaType::QReal, 0x00495001,

 // properties: notify_signal_id
       0,
       1,
       2,
       3,

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
        case 4: _t->errorOccurred((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 5: _t->readData(); break;
        case 6: _t->handleError((*reinterpret_cast< QSerialPort::SerialPortError(*)>(_a[1]))); break;
        case 7: { bool _r = _t->connectToPort();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 8: _t->disconnectPort(); break;
        case 9: { QStringList _r = _t->availablePorts();
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 10: { bool _r = _t->autoConnect();
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
            using _t = void (SerialReader::*)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&SerialReader::errorOccurred)) {
                *result = 4;
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
        if (_id < 11)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 11)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 11;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 4;
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
void SerialReader::errorOccurred(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 4, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
