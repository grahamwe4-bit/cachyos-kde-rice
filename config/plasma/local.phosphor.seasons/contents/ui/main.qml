import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PC
import org.kde.plasma.plasma5support as P5

PlasmoidItem {
    id: root
    property bool busy: false
    property string status: "Choose an Overdrive, Phosphor, Lo-Fi or Old Times session"
    toolTipMainText: "OVERDRIVE / PHOSPHOR / LO-FI / OLD TIMES"
    toolTipSubText: status
    Plasmoid.icon: "preferences-desktop-theme-global"

    P5.DataSource {
        id: runner
        engine: "executable"
        connectedSources: []
        onNewData: function(source, data) {
            disconnectSource(source)
            root.busy = false
            root.status = data["exit code"] === 0 ? "Session applied" : "Could not apply session"
        }
    }

    function choose(mode) {
        if (busy) return
        busy = true
        status = "Applying " + mode + "…"
        const loFiMode = mode === "lofi14" || mode.indexOf("lofi-") === 0
        const riceMode = loFiMode || mode === "phosphor14" || mode === "old-times" || mode.indexOf("overdrive") === 0 || mode.indexOf("custom-") === 0
        const command = riceMode
            ? "@HOME@/.local/bin/rice-switch "
            : "@HOME@/.local/bin/phosphor-season "
        runner.connectSource(command + mode)
    }

    compactRepresentation: PC.ToolButton {
        icon.name: "preferences-desktop-theme-global"
        text: "Sessions"
        display: PC.AbstractButton.IconOnly
        onClicked: root.expanded = !root.expanded
    }

    fullRepresentation: ColumnLayout {
        Layout.minimumWidth: 282
        Layout.preferredWidth: 282
        Layout.minimumHeight: 700
        spacing: 3

        PC.Label {
            text: "OVERDRIVE / 14   INTENSE"
            font.bold: true
            Layout.leftMargin: 8
            Layout.topMargin: 5
        }

        GridLayout {
            columns: 2
            columnSpacing: 5
            rowSpacing: 3
            Layout.fillWidth: true
            Layout.leftMargin: 6
            Layout.rightMargin: 6

            Repeater {
                model: [
                    {label: "Hyperpulse", value: "overdrive14", icon: Qt.resolvedUrl("../images/sessions/hyperpulse.svg")},
                    {label: "Neon Tempest", value: "overdrive-tempest", icon: Qt.resolvedUrl("../images/sessions/neon-tempest.svg")},
                    {label: "Solarflare", value: "overdrive-solarflare", icon: Qt.resolvedUrl("../images/sessions/solarflare.svg")},
                    {label: "Violet Arc", value: "overdrive-violet-arc", icon: Qt.resolvedUrl("../images/sessions/violet-arc.svg")}
                ]
                delegate: PC.Button {
                    required property var modelData
                    text: modelData.label
                    icon.source: modelData.icon
                    icon.width: 18
                    icon.height: 18
                    Layout.fillWidth: true
                    implicitHeight: 36
                    enabled: !root.busy
                    onClicked: root.choose(modelData.value)
                }
            }
        }

        PC.Label {
            text: "PHOSPHOR / 14   BALANCED"
            font.bold: true
            Layout.leftMargin: 8
            Layout.topMargin: 3
        }

        GridLayout {
            columns: 2
            columnSpacing: 5
            rowSpacing: 3
            Layout.fillWidth: true
            Layout.leftMargin: 6
            Layout.rightMargin: 6

            Repeater {
                model: [
                    {label: "Spring", value: "spring"},
                    {label: "Summer", value: "summer"},
                    {label: "Autumn", value: "autumn"},
                    {label: "Winter", value: "winter"},
                    {label: "Auto · calendar", value: "auto"}
                ]
                delegate: PC.Button {
                    required property var modelData
                    text: modelData.label
                    Layout.fillWidth: true
                    implicitHeight: 34
                    enabled: !root.busy
                    onClicked: root.choose(modelData.value)
                }
            }
        }

        PC.Label {
            text: "LO-FI / 14   CHILL"
            font.bold: true
            Layout.leftMargin: 8
            Layout.topMargin: 3
        }

        GridLayout {
            columns: 2
            columnSpacing: 5
            rowSpacing: 3
            Layout.fillWidth: true
            Layout.leftMargin: 6
            Layout.rightMargin: 6

            Repeater {
                model: [
                    {label: "Night Radio", value: "lofi14", icon: Qt.resolvedUrl("../images/sessions/night-radio.svg")},
                    {label: "Rainline", value: "lofi-rainline", icon: Qt.resolvedUrl("../images/sessions/rainline.svg")},
                    {label: "Afterglow", value: "lofi-afterglow", icon: Qt.resolvedUrl("../images/sessions/afterglow.svg")},
                    {label: "Cassette", value: "lofi-cassette", icon: Qt.resolvedUrl("../images/sessions/cassette.svg")}
                ]
                delegate: PC.Button {
                    required property var modelData
                    text: modelData.label
                    icon.source: modelData.icon
                    icon.width: 18
                    icon.height: 18
                    Layout.fillWidth: true
                    implicitHeight: 36
                    enabled: !root.busy
                    onClicked: root.choose(modelData.value)
                }
            }
        }

        PC.Label {
            text: "OLD TIMES   MONOCHROME"
            font.bold: true
            Layout.leftMargin: 8
            Layout.topMargin: 3
        }

        PC.Button {
            text: "Old Times"
            icon.source: Qt.resolvedUrl("../images/sessions/old-times.svg")
            icon.width: 18
            icon.height: 18
            Layout.fillWidth: true
            Layout.leftMargin: 6
            Layout.rightMargin: 6
            implicitHeight: 36
            enabled: !root.busy
            onClicked: root.choose("old-times")
        }

        PC.Label {
            text: "COLORWAYS / 14   ORIGINALS"
            font.bold: true
            Layout.leftMargin: 8
            Layout.topMargin: 3
        }

        GridLayout {
            columns: 2
            columnSpacing: 5
            rowSpacing: 3
            Layout.fillWidth: true
            Layout.leftMargin: 6
            Layout.rightMargin: 6

            Repeater {
                model: [
                    {label: "Aurora Drift", value: "custom-aurora-drift", icon: Qt.resolvedUrl("../images/sessions/aurora-drift.svg")},
                    {label: "Crimson Frequency", value: "custom-crimson-frequency", icon: Qt.resolvedUrl("../images/sessions/crimson-frequency.svg")},
                    {label: "Moonlit Orchid", value: "custom-moonlit-orchid", icon: Qt.resolvedUrl("../images/sessions/moonlit-orchid.svg")},
                    {label: "Arctic Mirage", value: "custom-arctic-mirage", icon: Qt.resolvedUrl("../images/sessions/arctic-mirage.svg")},
                    {label: "Wildwood Circuit", value: "custom-wildwood-circuit", icon: Qt.resolvedUrl("../images/sessions/wildwood-circuit.svg")},
                    {label: "Copper Nocturne", value: "custom-copper-nocturne", icon: Qt.resolvedUrl("../images/sessions/copper-nocturne.svg")},
                    {label: "Solar Vanta", value: "custom-solar-vanta", icon: Qt.resolvedUrl("../images/sessions/solar-vanta.svg")},
                    {label: "Abyssal Current", value: "custom-abyssal-current", icon: Qt.resolvedUrl("../images/sessions/abyssal-current.svg")}
                ]
                delegate: PC.Button {
                    required property var modelData
                    text: modelData.label
                    icon.source: modelData.icon
                    icon.width: 18
                    icon.height: 18
                    Layout.fillWidth: true
                    implicitHeight: 36
                    enabled: !root.busy
                    onClicked: root.choose(modelData.value)
                }
            }
        }

        PC.Label {
            text: "SPECTRUM / 14   32 THEMES"
            font.bold: true
            Layout.leftMargin: 8
        }
        PC.ComboBox {
            id: spectrumChoice
            implicitWidth: 260
            implicitHeight: 36
            Layout.fillWidth: true
            Layout.leftMargin: 6
            Layout.rightMargin: 6
            textRole: "label"
            model: [
                { label: "Neon Harbor", value: "custom-spectrum-neon-harbor" },
                { label: "Ghost Signal", value: "custom-spectrum-ghost-signal" },
                { label: "Electric Bloom", value: "custom-spectrum-electric-bloom" },
                { label: "Midnight Prism", value: "custom-spectrum-midnight-prism" },
                { label: "Chrome Mirage", value: "custom-spectrum-chrome-mirage" },
                { label: "Circuit Rose", value: "custom-spectrum-circuit-rose" },
                { label: "Plasma Horizon", value: "custom-spectrum-plasma-horizon" },
                { label: "Quantum Tide", value: "custom-spectrum-quantum-tide" },
                { label: "Starlight Engine", value: "custom-spectrum-starlight-engine" },
                { label: "Velvet Voltage", value: "custom-spectrum-velvet-voltage" },
                { label: "Cyber Lotus", value: "custom-spectrum-cyber-lotus" },
                { label: "Nightfall Reactor", value: "custom-spectrum-nightfall-reactor" },
                { label: "Solar Echo", value: "custom-spectrum-solar-echo" },
                { label: "Obsidian Pulse", value: "custom-spectrum-obsidian-pulse" },
                { label: "Iridescent Rain", value: "custom-spectrum-iridescent-rain" },
                { label: "Lunar Frequency", value: "custom-spectrum-lunar-frequency" },
                { label: "Deep Space Radio", value: "custom-spectrum-deep-space-radio" },
                { label: "Digital Sakura", value: "custom-spectrum-digital-sakura" },
                { label: "Photon Garden", value: "custom-spectrum-photon-garden" },
                { label: "Cobalt Reverie", value: "custom-spectrum-cobalt-reverie" },
                { label: "Amber Signal", value: "custom-spectrum-amber-signal" },
                { label: "Violet Tides", value: "custom-spectrum-violet-tides" },
                { label: "Emerald Orbit", value: "custom-spectrum-emerald-orbit" },
                { label: "Crimson Eclipse", value: "custom-spectrum-crimson-eclipse" },
                { label: "Glacier Protocol", value: "custom-spectrum-glacier-protocol" },
                { label: "Rose Quartz Drive", value: "custom-spectrum-rose-quartz-drive" },
                { label: "Spectral Forest", value: "custom-spectrum-spectral-forest" },
                { label: "Golden Static", value: "custom-spectrum-golden-static" },
                { label: "Ultraviolet Dream", value: "custom-spectrum-ultraviolet-dream" },
                { label: "Oceanic Pulse", value: "custom-spectrum-oceanic-pulse" },
                { label: "Ruby Transmission", value: "custom-spectrum-ruby-transmission" },
                { label: "Celestial Drift", value: "custom-spectrum-celestial-drift" }
            ]
        }
        PC.Button {
            text: "Apply Spectrum Theme"
            Layout.fillWidth: true
            Layout.leftMargin: 6
            Layout.rightMargin: 6
            enabled: !root.busy && spectrumChoice.currentIndex >= 0
            onClicked: root.choose(spectrumChoice.model[spectrumChoice.currentIndex].value)
        }

        PC.Label {
            text: root.status
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.bottomMargin: 5
        }
    }
}
