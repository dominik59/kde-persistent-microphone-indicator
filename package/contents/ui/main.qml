import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.private.volume
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    preferredRepresentation: compactRepresentation

    // PreferredDevice.source is a C++ Q_PROPERTY on a singleton — QML tracks its
    // mutedChanged signal reactively, unlike Instantiator delegates which don't
    // propagate model dataChanged to required properties.
    readonly property var defaultSource: PreferredDevice.source
    property bool micMuted: defaultSource ? defaultSource.muted : false
    property bool micInUse: !micMuted && activeStreams > 0
    property bool backendOk: true
    property string backendError: ""
    property int activeStreams: sourceOutputInstantiator.count
    property bool debugLogging: true
    readonly property real iconSizeMultiplier: Plasmoid.configuration.iconSizeMultiplier

    readonly property string currentIconName: {
        if (!backendOk) {
            return "dialog-error-symbolic"
        }
        if (micMuted) {
            return "microphone-disabled-symbolic"
        }
        if (micInUse) {
            return "audio-input-microphone"
        }
        return "audio-input-microphone-symbolic"
    }

    readonly property string currentStatusText: {
        if (!backendOk) {
            return "Unable to read microphone status"
        }
        if (micMuted) {
            return "Microphone muted"
        }
        if (micInUse) {
            return "Microphone in use"
        }
        return "Microphone idle"
    }


    // Kirigami.Icon accepts both icon names and URLs — use a local SVG for the
    // active state to get a coloured icon instead of the monochrome symbolic one.
    readonly property var currentIconSource: micInUse ? Qt.resolvedUrl("../icons/mic-active.svg") : currentIconName

    Plasmoid.icon: currentIconName
    Plasmoid.status: PlasmaCore.Types.ActiveStatus
    toolTipMainText: "Persistent Microphone Indicator"
    toolTipSubText: currentStatusText

    function logDebug(message) {
        if (debugLogging) {
            console.log("[kde-persistent-microphone-indicator] " + message)
        }
    }

    function logCurrentState(reason) {
        logDebug(reason
            + ": defaultSource=" + (defaultSource ? ("'" + defaultSource.name + "'") : "<none>")
            + ", micMuted=" + micMuted
            + ", activeStreams=" + activeStreams
            + ", micInUse=" + micInUse
            + ", icon=" + currentIconName)
    }

    onMicMutedChanged: {
        logDebug("micMuted changed -> " + micMuted)
    }

    onMicInUseChanged: {
        logDebug("micInUse changed -> " + micInUse)
    }

    onBackendOkChanged: {
        logDebug("backendOk changed -> " + backendOk)
    }

    onBackendErrorChanged: {
        logDebug("backendError changed -> '" + backendError + "'")
    }

    onActiveStreamsChanged: {
        logDebug("activeStreams changed -> " + activeStreams)
    }

    onCurrentIconNameChanged: {
        logDebug("currentIconName changed -> " + currentIconName)
    }


    onDefaultSourceChanged: {
        logCurrentState("defaultSource changed")
    }

    compactRepresentation: MouseArea {
        implicitWidth: Kirigami.Units.iconSizes.smallMedium
        implicitHeight: Kirigami.Units.iconSizes.smallMedium
        onClicked: root.expanded = !root.expanded

        // The tray slot size is fixed by the containment — scale the icon
        // within the slot instead of trying to resize the slot itself.
        Kirigami.Icon {
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.smallMedium * root.iconSizeMultiplier
            height: Kirigami.Units.iconSizes.smallMedium * root.iconSizeMultiplier
            source: root.currentIconSource
        }
    }


    Instantiator {
        id: sourceOutputInstantiator
        model: SourceOutputModel {
            id: sourceOutputModel
        }

        delegate: QtObject {
            required property var model

            readonly property int streamIndex: model.Index || -1
        }

        onObjectAdded: function(index) {
            root.logDebug("source output added at index " + index)
            root.logCurrentState("source output added")
        }

        onObjectRemoved: function(index) {
            root.logDebug("source output removed at index " + index)
            root.logCurrentState("source output removed")
        }
    }

    Component.onCompleted: {
        root.logDebug("Component.onCompleted")
        root.logCurrentState("Component.onCompleted")
    }

    Component.onDestruction: {
        root.logDebug("Component.onDestruction")
    }

    fullRepresentation: Item {
        implicitWidth: 320
        implicitHeight: 180

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                source: root.currentIconSource
            }

            PlasmaComponents3.Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: root.currentStatusText
            }

            PlasmaComponents3.Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: root.backendOk
                    ? ("Active recording streams: " + root.activeStreams)
                    : ("Backend error: " + root.backendError)
            }

            PlasmaComponents3.Button {
                Layout.alignment: Qt.AlignHCenter
                text: "Log state"
                icon.name: "view-refresh"
                onClicked: root.logCurrentState("manual")
            }
        }
    }
}