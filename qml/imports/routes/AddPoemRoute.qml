import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import logics 1.0

AddBookPage {
    poemId: -1
    headerLabel.text: renameMode? qsTr("Rename Poem") : qsTr("Add Poem") + Translations.refresher
    nameField.placeholderText: qsTr("Poem Name") + Translations.refresher
    confirmBtn.text: headerLabel.text
    descriptionLabel.text: qsTr("Please enter poem name:") + Translations.refresher
}
