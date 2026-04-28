import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_iconSizeMultiplier: slider.value

    Kirigami.FormLayout {
        RowLayout {
            Kirigami.FormData.label: "Tray icon size:"
            spacing: Kirigami.Units.smallSpacing

            QQC2.Slider {
                id: slider
                from: 0.5
                to: 2.0
                stepSize: 0.25
                Layout.preferredWidth: 300

                // Keep the spin box in sync when the slider moves.
                onValueChanged: spinBox.value = Math.round(value * 100)
            }

            // SpinBox works in integer units (50–200) to avoid floating-point
            // text parsing; dividing by 100 gives the real multiplier.
            QQC2.SpinBox {
                id: spinBox
                from: 50
                to: 200
                stepSize: 5
                value: Math.round(slider.value * 100)

                textFromValue: function(v) { return (v / 100).toFixed(2) + "×" }
                valueFromText: function(t) { return Math.round(parseFloat(t) * 100) }

                // Keep the slider in sync when the spin box changes.
                onValueChanged: slider.value = value / 100
            }
        }

        RowLayout {
            Layout.fillWidth: true

            QQC2.Label { text: "0.50×" }
            Item { Layout.fillWidth: true }
            QQC2.Label { text: "1.00×" }
            Item { Layout.fillWidth: true }
            QQC2.Label { text: "2.00×" }
        }
    }
}