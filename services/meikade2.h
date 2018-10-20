#ifndef MEIKADE2_H
#define MEIKADE2_H

#include <asemanabstractagentclient.h>

#define ASEMAN_AGENT_PING_CALLBACK ASEMAN_AGENT_CALLBACK(QString)
#define ASEMAN_AGENT_LASTMESSAGE_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantMap)
#define ASEMAN_AGENT_GETADVERTISE_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantMap)
#define ASEMAN_AGENT_GETLASTVERSION_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantMap)
#define ASEMAN_AGENT_GETCHANGELOG_CALLBACK ASEMAN_AGENT_CALLBACK(QString)
#define ASEMAN_AGENT_SUBMITELOG_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_PUSHACTIVITY_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_PUSHACTION_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_PUSHDEVICEMODEL_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_ADDNOTE_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_NOTE_CALLBACK ASEMAN_AGENT_CALLBACK(QString)
#define ASEMAN_AGENT_GETPOEMNOTES_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantMap)
#define ASEMAN_AGENT_GETNOTES_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantList)
#define ASEMAN_AGENT_CONTACTUS_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_GETSTOREITEMS_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantList)
#define ASEMAN_AGENT_GETSTOREITEM_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantMap)
#define ASEMAN_AGENT_GETSTORECATEGORIES_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantList)
#define ASEMAN_AGENT_SETSTOREDOWNLOADED_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_ADMINHOWMANYUSERS_CALLBACK ASEMAN_AGENT_CALLBACK(int)


#ifdef QT_QML_LIB
#include <QJSValue>
#endif

class Meikade2: public AsemanAbstractAgentClient
{
    Q_OBJECT
    Q_ENUMS(Errors)
    Q_PROPERTY(QString name_ping READ name_ping NOTIFY fakeSignal)
    Q_PROPERTY(QString name_lastMessage READ name_lastMessage NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getAdvertise READ name_getAdvertise NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getLastVersion READ name_getLastVersion NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getChangeLog READ name_getChangeLog NOTIFY fakeSignal)
    Q_PROPERTY(QString name_submiteLog READ name_submiteLog NOTIFY fakeSignal)
    Q_PROPERTY(QString name_pushActivity READ name_pushActivity NOTIFY fakeSignal)
    Q_PROPERTY(QString name_pushAction READ name_pushAction NOTIFY fakeSignal)
    Q_PROPERTY(QString name_pushDeviceModel READ name_pushDeviceModel NOTIFY fakeSignal)
    Q_PROPERTY(QString name_addNote READ name_addNote NOTIFY fakeSignal)
    Q_PROPERTY(QString name_note READ name_note NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getPoemNotes READ name_getPoemNotes NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getNotes READ name_getNotes NOTIFY fakeSignal)
    Q_PROPERTY(QString name_contactUs READ name_contactUs NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getStoreItems READ name_getStoreItems NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getStoreItem READ name_getStoreItem NOTIFY fakeSignal)
    Q_PROPERTY(QString name_getStoreCategories READ name_getStoreCategories NOTIFY fakeSignal)
    Q_PROPERTY(QString name_setStoreDownloaded READ name_setStoreDownloaded NOTIFY fakeSignal)
    Q_PROPERTY(QString name_adminHowManyUsers READ name_adminHowManyUsers NOTIFY fakeSignal)

public:
    enum Errors {
        ErrorNoteNotFound = 0x1,
        ErrorUserNotFound = 0x4,
        ErrorUnknownError = 0x41F7C0,
        ErrorSessionError = 0x620299,
        ErrorPermissionDenied = 0x1D240,
        ErrorOpenFile = 0x8B9D3D,
        ErrorInvalidFileName = 0xD2512F,
        ErrorNotTrusted = 0x9F68A8
    };

    Meikade2(QObject *parent = Q_NULLPTR) :
        AsemanAbstractAgentClient(parent),
        _service("meikade"),
        _version(2) {
    }
    virtual ~Meikade2() {
    }

    virtual qint64 pushRequest(const QString &method, const QVariantList &args, qint32 priority, bool hasResult) {
        return AsemanAbstractAgentClient::pushRequest(_service, _version, method, args, priority, hasResult);
    }

    QString name_ping() const { return "ping"; }
    Q_INVOKABLE qint64 ping(int num, QObject *base = 0, Callback<QString> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("ping", QVariantList() << QVariant::fromValue<int>(num), priority, true);
        _calls[id] = "ping";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    QString name_lastMessage() const { return "lastMessage"; }
    Q_INVOKABLE qint64 lastMessage(QObject *base = 0, Callback<QVariantMap> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("lastMessage", QVariantList(), priority, true);
        _calls[id] = "lastMessage";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    QString name_getAdvertise() const { return "getAdvertise"; }
    Q_INVOKABLE qint64 getAdvertise(QObject *base = 0, Callback<QVariantMap> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("getAdvertise", QVariantList(), priority, true);
        _calls[id] = "getAdvertise";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    QString name_getLastVersion() const { return "getLastVersion"; }
    Q_INVOKABLE qint64 getLastVersion(QString platform, QObject *base = 0, Callback<QVariantMap> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("getLastVersion", QVariantList() << QVariant::fromValue<QString>(platform), priority, true);
        _calls[id] = "getLastVersion";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    QString name_getChangeLog() const { return "getChangeLog"; }
    Q_INVOKABLE qint64 getChangeLog(QString platform, QString version, QObject *base = 0, Callback<QString> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("getChangeLog", QVariantList() << QVariant::fromValue<QString>(platform) << QVariant::fromValue<QString>(version), priority, true);
        _calls[id] = "getChangeLog";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    QString name_submiteLog() const { return "submiteLog"; }
    Q_INVOKABLE qint64 submiteLog(QString deviceId, QString platform, QString version, QString log, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("submiteLog", QVariantList() << QVariant::fromValue<QString>(deviceId) << QVariant::fromValue<QString>(platform) << QVariant::fromValue<QString>(version) << QVariant::fromValue<QString>(log), priority, true);
        _calls[id] = "submiteLog";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_pushActivity() const { return "pushActivity"; }
    Q_INVOKABLE qint64 pushActivity(QString type, int time, QString comment, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("pushActivity", QVariantList() << QVariant::fromValue<QString>(type) << QVariant::fromValue<int>(time) << QVariant::fromValue<QString>(comment), priority, true);
        _calls[id] = "pushActivity";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_pushAction() const { return "pushAction"; }
    Q_INVOKABLE qint64 pushAction(QString action, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("pushAction", QVariantList() << QVariant::fromValue<QString>(action), priority, true);
        _calls[id] = "pushAction";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_pushDeviceModel() const { return "pushDeviceModel"; }
    Q_INVOKABLE qint64 pushDeviceModel(QString deviceId, QVariantMap map, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("pushDeviceModel", QVariantList() << QVariant::fromValue<QString>(deviceId) << QVariant::fromValue<QVariantMap>(map), priority, true);
        _calls[id] = "pushDeviceModel";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_addNote() const { return "addNote"; }
    Q_INVOKABLE qint64 addNote(int poemId, int verseId, QString text, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("addNote", QVariantList() << QVariant::fromValue<int>(poemId) << QVariant::fromValue<int>(verseId) << QVariant::fromValue<QString>(text), priority, true);
        _calls[id] = "addNote";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_note() const { return "note"; }
    Q_INVOKABLE qint64 note(int poemId, int verseId, QObject *base = 0, Callback<QString> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("note", QVariantList() << QVariant::fromValue<int>(poemId) << QVariant::fromValue<int>(verseId), priority, true);
        _calls[id] = "note";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    QString name_getPoemNotes() const { return "getPoemNotes"; }
    Q_INVOKABLE qint64 getPoemNotes(int poemId, int offset, int limit, QObject *base = 0, Callback<QVariantMap> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("getPoemNotes", QVariantList() << QVariant::fromValue<int>(poemId) << QVariant::fromValue<int>(offset) << QVariant::fromValue<int>(limit), priority, true);
        _calls[id] = "getPoemNotes";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    QString name_getNotes() const { return "getNotes"; }
    Q_INVOKABLE qint64 getNotes(int offset, int limit, QObject *base = 0, Callback<QVariantList> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("getNotes", QVariantList() << QVariant::fromValue<int>(offset) << QVariant::fromValue<int>(limit), priority, true);
        _calls[id] = "getNotes";
        pushBase(id, base);
        callBackPush<QVariantList>(id, callBack);
        return id;
    }

    QString name_contactUs() const { return "contactUs"; }
    Q_INVOKABLE qint64 contactUs(QString name, QString email, QString msg, QString deviceId, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("contactUs", QVariantList() << QVariant::fromValue<QString>(name) << QVariant::fromValue<QString>(email) << QVariant::fromValue<QString>(msg) << QVariant::fromValue<QString>(deviceId), priority, true);
        _calls[id] = "contactUs";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_getStoreItems() const { return "getStoreItems"; }
    Q_INVOKABLE qint64 getStoreItems(QString locale, QString keyword, int category, int offset, int limit, QVariantMap currentList, QObject *base = 0, Callback<QVariantList> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("getStoreItems", QVariantList() << QVariant::fromValue<QString>(locale) << QVariant::fromValue<QString>(keyword) << QVariant::fromValue<int>(category) << QVariant::fromValue<int>(offset) << QVariant::fromValue<int>(limit) << QVariant::fromValue<QVariantMap>(currentList), priority, true);
        _calls[id] = "getStoreItems";
        pushBase(id, base);
        callBackPush<QVariantList>(id, callBack);
        return id;
    }

    QString name_getStoreItem() const { return "getStoreItem"; }
    Q_INVOKABLE qint64 getStoreItem(QString iid, QObject *base = 0, Callback<QVariantMap> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("getStoreItem", QVariantList() << QVariant::fromValue<QString>(iid), priority, true);
        _calls[id] = "getStoreItem";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    QString name_getStoreCategories() const { return "getStoreCategories"; }
    Q_INVOKABLE qint64 getStoreCategories(QString locale, QObject *base = 0, Callback<QVariantList> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("getStoreCategories", QVariantList() << QVariant::fromValue<QString>(locale), priority, true);
        _calls[id] = "getStoreCategories";
        pushBase(id, base);
        callBackPush<QVariantList>(id, callBack);
        return id;
    }

    QString name_setStoreDownloaded() const { return "setStoreDownloaded"; }
    Q_INVOKABLE qint64 setStoreDownloaded(QString deviceId, QString iid, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("setStoreDownloaded", QVariantList() << QVariant::fromValue<QString>(deviceId) << QVariant::fromValue<QString>(iid), priority, true);
        _calls[id] = "setStoreDownloaded";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_adminHowManyUsers() const { return "adminHowManyUsers"; }
    Q_INVOKABLE qint64 adminHowManyUsers(QObject *base = 0, Callback<int> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("adminHowManyUsers", QVariantList(), priority, true);
        _calls[id] = "adminHowManyUsers";
        pushBase(id, base);
        callBackPush<int>(id, callBack);
        return id;
    }


#ifdef QT_QML_LIB
public Q_SLOTS:
    /*!
     * Callbacks gives result value and error map as arguments.
     */
    qint64 ping(int num, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return ping(num, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 lastMessage(const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return lastMessage(this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 getAdvertise(const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return getAdvertise(this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 getLastVersion(QString platform, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return getLastVersion(platform, this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 getChangeLog(QString platform, QString version, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return getChangeLog(platform, version, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 submiteLog(QString deviceId, QString platform, QString version, QString log, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return submiteLog(deviceId, platform, version, log, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 pushActivity(QString type, int time, QString comment, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return pushActivity(type, time, comment, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 pushAction(QString action, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return pushAction(action, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 pushDeviceModel(QString deviceId, QVariantMap map, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return pushDeviceModel(deviceId, map, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 addNote(int poemId, int verseId, QString text, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return addNote(poemId, verseId, text, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 note(int poemId, int verseId, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return note(poemId, verseId, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 getPoemNotes(int poemId, int offset, int limit, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return getPoemNotes(poemId, offset, limit, this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 getNotes(int offset, int limit, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return getNotes(offset, limit, this, [this, jsCallback](qint64, const QVariantList &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 contactUs(QString name, QString email, QString msg, QString deviceId, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return contactUs(name, email, msg, deviceId, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 getStoreItems(QString locale, QString keyword, int category, int offset, int limit, QVariantMap currentList, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return getStoreItems(locale, keyword, category, offset, limit, currentList, this, [this, jsCallback](qint64, const QVariantList &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 getStoreItem(QString iid, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return getStoreItem(iid, this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 getStoreCategories(QString locale, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return getStoreCategories(locale, this, [this, jsCallback](qint64, const QVariantList &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 setStoreDownloaded(QString deviceId, QString iid, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return setStoreDownloaded(deviceId, iid, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 adminHowManyUsers(const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return adminHowManyUsers(this, [this, jsCallback](qint64, const int &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
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
    void getLastVersionAnswer(qint64 id, QVariantMap result);
    void getLastVersionError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void getChangeLogAnswer(qint64 id, QString result);
    void getChangeLogError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void submiteLogAnswer(qint64 id, bool result);
    void submiteLogError(qint64 id, qint32 errorCode, const QVariant &errorValue);
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
    void contactUsAnswer(qint64 id, bool result);
    void contactUsError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void getStoreItemsAnswer(qint64 id, QVariantList result);
    void getStoreItemsError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void getStoreItemAnswer(qint64 id, QVariantMap result);
    void getStoreItemError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void getStoreCategoriesAnswer(qint64 id, QVariantList result);
    void getStoreCategoriesError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void setStoreDownloadedAnswer(qint64 id, bool result);
    void setStoreDownloadedError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void adminHowManyUsersAnswer(qint64 id, int result);
    void adminHowManyUsersError(qint64 id, qint32 errorCode, const QVariant &errorValue);

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
        if(method == "getLastVersion") {
            callBackCall<QVariantMap>(id, result.value<QVariantMap>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT getLastVersionAnswer(id, result.value<QVariantMap>());
            else Q_EMIT getLastVersionError(id, error.errorCode, error.errorValue);
        } else
        if(method == "getChangeLog") {
            callBackCall<QString>(id, result.value<QString>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT getChangeLogAnswer(id, result.value<QString>());
            else Q_EMIT getChangeLogError(id, error.errorCode, error.errorValue);
        } else
        if(method == "submiteLog") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT submiteLogAnswer(id, result.value<bool>());
            else Q_EMIT submiteLogError(id, error.errorCode, error.errorValue);
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
        if(method == "contactUs") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT contactUsAnswer(id, result.value<bool>());
            else Q_EMIT contactUsError(id, error.errorCode, error.errorValue);
        } else
        if(method == "getStoreItems") {
            callBackCall<QVariantList>(id, result.value<QVariantList>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT getStoreItemsAnswer(id, result.value<QVariantList>());
            else Q_EMIT getStoreItemsError(id, error.errorCode, error.errorValue);
        } else
        if(method == "getStoreItem") {
            callBackCall<QVariantMap>(id, result.value<QVariantMap>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT getStoreItemAnswer(id, result.value<QVariantMap>());
            else Q_EMIT getStoreItemError(id, error.errorCode, error.errorValue);
        } else
        if(method == "getStoreCategories") {
            callBackCall<QVariantList>(id, result.value<QVariantList>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT getStoreCategoriesAnswer(id, result.value<QVariantList>());
            else Q_EMIT getStoreCategoriesError(id, error.errorCode, error.errorValue);
        } else
        if(method == "setStoreDownloaded") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT setStoreDownloadedAnswer(id, result.value<bool>());
            else Q_EMIT setStoreDownloadedError(id, error.errorCode, error.errorValue);
        } else
        if(method == "adminHowManyUsers") {
            callBackCall<int>(id, result.value<int>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT adminHowManyUsersAnswer(id, result.value<int>());
            else Q_EMIT adminHowManyUsersError(id, error.errorCode, error.errorValue);
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


#endif //MEIKADE2_H

