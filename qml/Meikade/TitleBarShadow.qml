import QtQuick 2.0
import AsemanTools 1.0

Rectangle {
    height: 3*Devices.density
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#55000000" }
        GradientStop { position: 1.0; color: "#00000000" }
    }
}
