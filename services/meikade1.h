#ifndef MEIKADE1_H
#define MEIKADE1_H

#include <asemanabstractagentclient.h>

#define ASEMAN_AGENT_PING_CALLBACK ASEMAN_AGENT_CALLBACK(QString)
#define ASEMAN_AGENT_LASTMESSAGE_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantMap)
#define ASEMAN_AGENT_GETADVERTISE_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantMap)
#define ASEMAN_AGENT_PUSHACTIVITY_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_PUSHACTION_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_PUSHDEVICEMODEL_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_ADDNOTE_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_NOTE_CALLBACK ASEMAN_AGENT_CALLBACK(QString)
#define ASEMAN_AGENT_GETPOEMNOTES_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantMap)
#define ASEMAN_AGENT_GETNOTES_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantList)


#ifdef QT_QML_LIB
#include <QJSValue>
#endif

class Meikade1: public AsemanAbstractAgentClient
{
    Q_OBJECT
    Q_ENUMS(Errors)
    Q_PROPERTY(QString name_ping READ name_ping NOTIFY fakeSignal)
    Q_PROPERTY(QString name_lastMessage READ name_lastMessage NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getAdvertise READ name_getAdvertise NOTIFY fakeSignal)
    Q_PROPERTY(QString name_pushActivity READ name_pushActivity NOTIFY fakeSignal)
    Q_PROPERTY(QString name_pushAction READ name_pushAction NOTIFY fakeSignal)
    Q_PROPERTY(QString name_pushDeviceModel READ name_pushDeviceModel NOTIFY fakeSignal)
    Q_PROPERTY(QString name_addNote READ name_addNote NOTIFY fakeSignal)
    Q_PROPERTY(QString name_note READ name_note NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getPoemNotes READ name_getPoemNotes NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getNotes READ name_getNotes NOTIFY fakeSignal)

public:
    enum Errors {
        ErrorUnknownError = 0x0,
        ErrorNoteNotFound = 0x1,
        ErrorSessionError = 0x2,
        ErrorUserNotFound = 0x4
    };

    Meikade1(QObject *parent = Q_NULLPTR) :
        AsemanAbstractAgentClient(parent),
        _service("meikade"),
        _version(1) {
    }
    virtual ~Meikade1() {
    }

    virtual qint64 pushRequest(const QString &method, const QVariantList &args) {
        return AsemanAbstractAgentClient::pushRequest(_service, _version, method, args);
    }

    QString name_ping() const { return "ping"; }
    qint64 ping(int num, QObject *base = 0, Callback<QString> callBack = 0) {
        qint64 id = pushRequest("ping", QVariantList() << QVariant::fromValue<int>(num));
        _calls[id] = "ping";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    QString name_lastMessage() const { return "lastMessage"; }
    qint64 lastMessage(QObject *base = 0, Callback<QVariantMap> callBack = 0) {
        qint64 id = pushRequest("lastMessage", QVariantList());
        _calls[id] = "lastMessage";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    QString name_getAdvertise() const { return "getAdvertise"; }
    qint64 getAdvertise(QObject *base = 0, Callback<QVariantMap> callBack = 0) {
        qint64 id = pushRequest("getAdvertise", QVariantList());
        _calls[id] = "getAdvertise";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    QString name_pushActivity() const { return "pushActivity"; }
    qint64 pushActivity(QString type, int time, QString comment, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("pushActivity", QVariantList() << QVariant::fromValue<QString>(type) << QVariant::fromValue<int>(time) << QVariant::fromValue<QString>(comment));
        _calls[id] = "pushActivity";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_pushAction() const { return "pushAction"; }
    qint64 pushAction(QString action, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("pushAction", QVariantList() << QVariant::fromValue<QString>(action));
        _calls[id] = "pushAction";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_pushDeviceModel() const { return "pushDeviceModel"; }
    qint64 pushDeviceModel(QString device, double screen, double density, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("pushDeviceModel", QVariantList() << QVariant::fromValue<QString>(device) << QVariant::fromValue<double>(screen) << QVariant::fromValue<double>(density));
        _calls[id] = "pushDeviceModel";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_addNote() const { return "addNote"; }
    qint64 addNote(int poemId, int verseId, QString text, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("addNote", QVariantList() << QVariant::fromValue<int>(poemId) << QVariant::fromValue<int>(verseId) << QVariant::fromValue<QString>(text));
        _calls[id] = "addNote";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_note() const { return "note"; }
    qint64 note(int poemId, int verseId, QObject *base = 0, Callback<QString> callBack = 0) {
        qint64 id = pushRequest("note", QVariantList() << QVariant::fromValue<int>(poemId) << QVariant::fromValue<int>(verseId));
        _calls[id] = "note";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    QString name_getPoemNotes() const { return "getPoemNotes"; }
    qint64 getPoemNotes(int poemId, int offset, int limit, QObject *base = 0, Callback<QVariantMap> callBack = 0) {
        qint64 id = pushRequest("getPoemNotes", QVariantList() << QVariant::fromValue<int>(poemId) << QVariant::fromValue<int>(offset) << QVariant::fromValue<int>(limit));
        _calls[id] = "getPoemNotes";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    QString name_getNotes() const { return "getNotes"; }
    qint64 getNotes(int offset, int limit, QObject *base = 0, Callback<QVariantList> callBack = 0) {
        qint64 id = pushRequest("getNotes", QVariantList() << QVariant::fromValue<int>(offset) << QVariant::fromValue<int>(limit));
        _calls[id] = "getNotes";
        pushBase(id, base);
        callBackPush<QVariantList>(id, callBack);
        return id;
    }


#ifdef QT_QML_LIB
public Q_SLOTS:
    /*!
     * Callbacks gives result value and error map as arguments.
     */
    qint64 ping(int num, const QJSValue &jsCallback) {
        return ping(num, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 lastMessage(const QJSValue &jsCallback) {
        return lastMessage(this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 getAdvertise(const QJSValue &jsCallback) {
        return getAdvertise(this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 pushActivity(QString type, int time, QString comment, const QJSValue &jsCallback) {
        return pushActivity(type, time, comment, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 pushAction(QString action, const QJSValue &jsCallback) {
        return pushAction(action, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 pushDeviceModel(QString device, double screen, double density, const QJSValue &jsCallback) {
        return pushDeviceModel(device, screen, density, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 addNote(int poemId, int verseId, QString text, const QJSValue &jsCallback) {
        return addNote(poemId, verseId, text, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 note(int poemId, int verseId, const QJSValue &jsCallback) {
        return note(poemId, verseId, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 getPoemNotes(int poemId, int offset, int limit, const QJSValue &jsCallback) {
        return getPoemNotes(poemId, offset, limit, this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 getNotes(int offset, int limit, const QJSValue &jsCallback) {
        return getNotes(offset, limit, this, [this, jsCallback](qint64, const QVariantList &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }

#endif //QT_QML_LIB

Q_SIGNALS:
    void fakeSignal();
    void pingAnswer(qint64 id, QString result);
    void pingError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void lastMessageAnswer(qint64 id, QVariantMap result);
    void lastMessageError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void getAdvertiseAnswer(qint64 id, QVariantMap result);
    void getAdvertiseError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void pushActivityAnswer(qint64 id, bool result);
    void pushActivityError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void pushActionAnswer(qint64 id, bool result);
    void pushActionError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void pushDeviceModelAnswer(qint64 id, bool result);
    void pushDeviceModelError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void addNoteAnswer(qint64 id, bool result);
    void addNoteError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void noteAnswer(qint64 id, QString result);
    void noteError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void getPoemNotesAnswer(qint64 id, QVariantMap result);
    void getPoemNotesError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void getNotesAnswer(qint64 id, QVariantList result);
    void getNotesError(qint64 id, qint32 errorCode, const QVariant &errorValue);

protected:
    void processError(qint64 id, const CallbackError &error) {
        processResult(id, QVariant(), error);
    }

    void processAnswer(qint64 id, const QVariant &result) {
        processResult(id, result, CallbackError());
    }

    void processResult(qint64 id, const QVariant &result, const CallbackError &error) {
        const QString method = _calls.value(id);
        if(method == "ping") {
            callBackCall<QString>(id, result.value<QString>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT pingAnswer(id, result.value<QString>());
            else Q_EMIT pingError(id, error.errorCode, error.errorValue);
        } else
        if(method == "lastMessage") {
            callBackCall<QVariantMap>(id, result.value<QVariantMap>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT lastMessageAnswer(id, result.value<QVariantMap>());
            else Q_EMIT lastMessageError(id, error.errorCode, error.errorValue);
        } else
        if(method == "getAdvertise") {
            callBackCall<QVariantMap>(id, result.value<QVariantMap>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT getAdvertiseAnswer(id, result.value<QVariantMap>());
            else Q_EMIT getAdvertiseError(id, error.errorCode, error.errorValue);
        } else
        if(method == "pushActivity") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT pushActivityAnswer(id, result.value<bool>());
            else Q_EMIT pushActivityError(id, error.errorCode, error.errorValue);
        } else
        if(method == "pushAction") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT pushActionAnswer(id, result.value<bool>());
            else Q_EMIT pushActionError(id, error.errorCode, error.errorValue);
        } else
        if(method == "pushDeviceModel") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT pushDeviceModelAnswer(id, result.value<bool>());
            else Q_EMIT pushDeviceModelError(id, error.errorCode, error.errorValue);
        } else
        if(method == "addNote") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT addNoteAnswer(id, result.value<bool>());
            else Q_EMIT addNoteError(id, error.errorCode, error.errorValue);
        } else
        if(method == "note") {
            callBackCall<QString>(id, result.value<QString>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT noteAnswer(id, result.value<QString>());
            else Q_EMIT noteError(id, error.errorCode, error.errorValue);
        } else
        if(method == "getPoemNotes") {
            callBackCall<QVariantMap>(id, result.value<QVariantMap>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT getPoemNotesAnswer(id, result.value<QVariantMap>());
            else Q_EMIT getPoemNotesError(id, error.errorCode, error.errorValue);
        } else
        if(method == "getNotes") {
            callBackCall<QVariantList>(id, result.value<QVariantList>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT getNotesAnswer(id, result.value<QVariantList>());
            else Q_EMIT getNotesError(id, error.errorCode, error.errorValue);
        } else
            Q_UNUSED(result);
        if(!error.null) Q_EMIT AsemanAbstractAgentClient::error(id, error.errorCode, error.errorValue);
    }

    void processSignals(const QString &method, const QVariantList &args) {
            Q_UNUSED(args);
    }

private:
    QString _service;
    int _version;
    QHash<qint64, QString> _calls;
};


#endif //MEIKADE1_H

