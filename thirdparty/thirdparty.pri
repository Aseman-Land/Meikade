
!qtHaveModule(asemanqml): {
    QT_ASEMAN_MODULES += core gui qml network widgets sql
    ASEMAN_QML_MODULES += materialicons controls models viewport base network controls_beta sql

    DEFINES += QASEMAN_STATIC
    include(qtaseman/aseman.pri)
}

# include(lottiequick/lottiequick.pri)
