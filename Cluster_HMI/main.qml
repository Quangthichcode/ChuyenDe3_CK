import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import QtGraphicalEffects 1.15
import "./"

Window {
    id: root
    width: 1920
    height: 960
    visible: true
    title: qsTr("Car DashBoard - Dual Screen Mode")
    color: "#1E1E1E"

    // --- GLOBAL FUNCTIONS ---
    function speedColor(value){
        if(value < 60 ){ return "green" }
        else if(value > 60 && value < 150){ return "yellow" }
        else{ return "Red" }
    }

    function generateRandom(maxLimit = 70){
        let rand = Math.random() * maxLimit;
        return Math.floor(rand);
    }

     // --- CLUSTER HMI ---
    Item {
        id: clusterHMI
        width: parent.width
        height: parent.height
        visible: true // Mặc định hiện

        property int nextSpeed: 60

        Timer {
            interval: 500
            running: clusterHMI.visible
            repeat: true
            onTriggered:{
                currentTime.text = Qt.formatDateTime(new Date(), "hh:mm")
            }
        }

        Timer{
            repeat: true
            interval: 3000
            running: clusterHMI.visible
            onTriggered: {
                clusterHMI.nextSpeed = root.generateRandom()
            }
        }

        Image {
            id: dashboard
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: "qrc:/assets/Dashboard.svg"

            // --- MAP NHỎ Ở GIỮA CLUSTER ---
            Item {
                id: mapCluster
                width: 500
                height: 250
                anchors.top: parent.top
                anchors.topMargin: 140
                anchors.horizontalCenter: parent.horizontalCenter

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: mapCluster.width
                        height: mapCluster.height
                        radius: 20
                        visible: false
                    }
                }

                Plugin {
                    id: mapboxPluginCluster
                    name: "mapboxgl"
                    PluginParameter {
                        name: "mapboxgl.access_token";
                        value: "pk.eyJ1Ijoibmd1eWVuaHVuZzQ4OCIsImEiOiJjbWk3MDNmeHAwNXJwMnFvZnVzdGo1dTdsIn0.MMBnkjFbPkXremQIgVIF3Q"
                    }

                    PluginParameter {
                        name: "mapboxgl.mapping.additional_style_urls";
                        value: "mapbox://styles/mapbox/streets-v11"
                    }
                }

                Map {
                    id: mapCenter
                    anchors.fill: parent
                    plugin: mapboxPluginCluster
                    center: QtPositioning.coordinate(16.0611, 108.2239)
                    zoomLevel: 14.5
                    tilt: 45
                    bearing: 0
                    copyrightsVisible: false
                    MouseArea {
                        anchors.fill: parent;
                        enabled: true;
                        onPressed: mouse.accepted = true
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "white"
                    border.width: 2
                    radius: 20
                    opacity: 0.3
                }
            }

            // --- TOP BAR & SWITCH CHUYỂN MÀN HÌNH ---
            Image {
                id: topBar
                width: 1357
                source: "qrc:/assets/Vector 70.svg"
                anchors.top: parent.top
                anchors.topMargin: 26.50
                anchors.horizontalCenter: parent.horizontalCenter

                // Nút đèn pha
                Image {
                    id: headLight
                    property bool indicator: false
                    width: 42.5
                    height: 38.25
                    anchors.top: parent.top
                    anchors.topMargin: 25
                    anchors.leftMargin: 230
                    anchors.left: parent.left
                    //source: indicator ? "qrc:/assets/Low beam headlights.svg" : "qrc:/assets/Low_beam_headlights_white.svg"
                    Behavior on indicator {
                        NumberAnimation {
                            duration: 300
                        }
                    }
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: { headLight.indicator = !headLight.indicator }
                    }
                }
                // Serial Control Panel

                /// Kết nối signals từ SerialReader
                Connections {
                    target: serialReader

                    // Biến trở
                    function onSpeedChanged() {
                        speedLabel.value = serialReader.speed
                    }

                    function onBatteryChanged() {
                        radialBar.value = serialReader.battery
                    }

                    // ===== CÁC NÚT NHẤN =====

                    // Đèn pha (top bar)
                    function onHeadlightChanged() {
                        secondLeftIndicator.headLightOn = serialReader.headlight
                    }

                    // Đèn parking (left side)
                    function onParkingChanged() {
                        thirdLeftIndicator.lightOn = serialReader.parking
                    }

                    // Đèn thường (left side)
                    function onLightChanged() {
                        thirdLeftIndicator.lightOn = serialReader.light
                    }

                    // Đèn sương mù (left side)
                    function onFogChanged() {
                        firstLeftIndicator.rareLightOn = serialReader.fog
                    }
                    // Xi nhan trái
                    function onTurnLeftChanged() {
                           forthLeftIndicator.parkingLightOn = !serialReader.turnLeft
                       }
                    // Xi nhan phải
                    function onTurnRightChanged() {
                        // Điều khiển tất cả icon bên phải
                        forthRightIndicator.indicator = !serialReader.turnRight
                    }
                    // Dây an toàn (right side)
                    function onSeatbeltChanged() {
                        firstRightIndicator.sheetBelt = serialReader.seatbelt
                    }

                    // Cảnh báo - có thể dùng cho road lines
                    function onWarning1Changed() {
                        secondRightIndicator.indicator = serialReader.warning1
                    }

                    function onWarning2Changed() {
                        thirdRightIndicator.indicator = serialReader.warning2
                    }

                    function onErrorOccurred(error) {
                        console.error("Serial Error:", error)
                    }
                }
                // AUTO-CONNECT KHI KHỞI ĐỘNG
                   Component.onCompleted: {
                       // Delay 1 giây rồi tự động kết nối
                       autoConnectTimer.start()
                   }
                   Timer {
                           id: autoConnectTimer
                           interval: 1000
                           repeat: false
                           onTriggered: {
                               console.log("Auto-connecting to ESP32...")
                               var success = serialReader.autoConnect()

                               if (success) {
                                   console.log("✅ Connected!")
                               } else {
                                   console.log("❌ ESP32 not found, retrying...")
                                   // Thử lại sau 3 giây
                                   retryTimer.start()
                               }
                           }
                       }
                   Timer {
                           id: retryTimer
                           interval: 3000
                           repeat: true
                           onTriggered: {
                               if (!serialReader.connected) {
                                   console.log("Retrying connection...")
                                   var success = serialReader.autoConnect()
                                   if (success) {
                                       retryTimer.stop()
                                   }
                               } else {
                                   retryTimer.stop()
                               }
                           }
                       }

                // ====== [NÚT SWITCH CHUYỂN MÀN HÌNH] ======
                Row {
                    anchors.top: parent.top
                    anchors.topMargin: 25
                    anchors.left: headLight.right
                    anchors.leftMargin: 30
                    spacing: 10

                    Label {
                        text: "IVI MODE"
                        color: "white"
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Switch {
                        id: screenSwitch
                        checked: false
                        focusPolicy: Qt.NoFocus

                        indicator: Rectangle {
                            implicitWidth: 48
                            implicitHeight: 26
                            x: screenSwitch.leftPadding
                            y: parent.height / 2 - height / 2
                            radius: 13
                            color: screenSwitch.checked ? "#01E6DE" : "#ffffff"
                            border.color: screenSwitch.checked ? "#01E6DE" : "#cccccc"

                            Rectangle {
                                x: screenSwitch.checked ? parent.width - width : 0
                                width: 26
                                height: 26
                                radius: 13
                                color: screenSwitch.down ? "#cccccc" : "#ffffff"
                                border.color: "#999999"
                            }
                        }

                        onCheckedChanged: {
                            if (checked) {
                                clusterHMI.visible = false
                                iviHMI.visible = true
                                // Reset intro khi bật IVI lên
                                introLayer.visible = true
                                gifPlayer.currentFrame = 0
                                gifPlayer.playing = true
                            } else {
                                clusterHMI.visible = true
                                iviHMI.visible = false
                            }
                        }
                    }
                }

                Label{
                    id: currentTime
                    text: Qt.formatDateTime(new Date(), "hh:mm")
                    font.pixelSize: 31
                    font.family: "Inter"
                    font.bold: Font.DemiBold
                    color: "#FFFFFF"
                    anchors.top: parent.top
                    anchors.topMargin: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label{
                    id: currentDate
                    text: Qt.formatDateTime(new Date(), "dd/MM/yyyy")
                    font.pixelSize: 31
                    font.family: "Inter"
                    font.bold: Font.DemiBold
                    color: "#FFFFFF"
                    anchors.right: parent.right
                    anchors.rightMargin: 230
                    anchors.top: parent.top
                    anchors.topMargin: 25
                }
            }

            Gauge {
                id: speedLabel
                width: 450
                height: 450
                property bool accelerating
                value: accelerating ? maximumValue : 0
                maximumValue: 250
                anchors.top: parent.top
                anchors.topMargin: Math.floor(parent.height * 0.23)
                anchors.right: parent.right
                anchors.rightMargin: Math.floor(parent.width * 0.11)
                Component.onCompleted: forceActiveFocus()
                Behavior on value {
                    NumberAnimation {
                        duration: 1000
                    }
                }
                Keys.onSpacePressed: accelerating = true
                Keys.onReleased: {
                    if (event.key === Qt.Key_Space) { accelerating = false; event.accepted = true; }
                    else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) { radialBar.accelerating = false; event.accepted = true; }
                }
            }

            Rectangle{
                id:speedLimit
                width: 130
                height: 130
                radius: height/2
                color: "#D9D9D9"
                border.color: root.speedColor(parseInt(maxSpeedlabel.text))
                border.width: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 50
                Label{
                    id:maxSpeedlabel
                    text: getRandomInt(150, speedLabel.maximumValue).toFixed(0)
                    font.pixelSize: 45
                    font.family: "Inter"
                    font.bold: Font.Bold
                    color: "#01E6DE"
                    anchors.centerIn: parent
                    function getRandomInt(min, max) {
                        return Math.floor(Math.random() * (max - min + 1)) + min;
                    }
                }
            }

            Image {
                anchors.bottom: car.top
                anchors.bottomMargin: 30
                anchors.horizontalCenter:car.horizontalCenter
                source: "qrc:/assets/Model 3.png"
            }
            Image {
                id:car
                anchors.bottom: speedLimit.top
                anchors.bottomMargin: 30
                anchors.horizontalCenter:speedLimit.horizontalCenter
                source: "qrc:/assets/Car.svg"
            }

            Image {
                id: leftRoad
                width: 127
                height: 397
                anchors.left: speedLimit.left
                anchors.leftMargin: 100
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 26.50
                source: "qrc:/assets/Vector 2.svg"
                visible: true
            }
            Image {
                id: rightRoad
                width: 127
                height: 397
                anchors.right: speedLimit.right
                anchors.rightMargin: 100
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 26.50
                source: "qrc:/assets/Vector 1.svg"
                visible: true
            }

            RowLayout{
                spacing: 20
                anchors.left: parent.left
                anchors.leftMargin: 250
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 26.50 + 65

                RowLayout{
                    spacing: 3
                    Label{
                        text: "100.6";
                        font.pixelSize: 32;
                        font.family: "Inter";
                        font.bold: Font.Normal;
                        color: "#FFFFFF"
                    }

                    Label{
                        text: "°F";
                        font.pixelSize: 32;
                        font.family: "Inter";
                        font.bold: Font.Normal;
                        opacity: 0.2; color: "#FFFFFF"
                    }
                }

                RowLayout{
                    spacing: 1
                    Layout.topMargin: 10
                    Rectangle{
                        width: 20;
                        height: 15;
                        color: speedLabel.value.toFixed(0) > 31.25 ? root.speedColor(speedLabel.value) : "#01E6DC"
                    }

                    Rectangle{
                        width: 20;
                        height: 15;
                        color: speedLabel.value.toFixed(0) > 62.5 ? root.speedColor(speedLabel.value) : "#01E6DC"
                    }

                    Rectangle{
                        width: 20;
                        height: 15;
                        color: speedLabel.value.toFixed(0) > 93.75 ? root.speedColor(speedLabel.value) : "#01E6DC"
                    }

                    Rectangle{
                        width: 20;
                        height: 15;
                        color: speedLabel.value.toFixed(0) > 125.25 ? root.speedColor(speedLabel.value) : "#01E6DC"
                    }

                    Rectangle{
                        width: 20;
                        height: 15;
                        color: speedLabel.value.toFixed(0) > 156.5 ? root.speedColor(speedLabel.value) : "#01E6DC"
                    }

                    Rectangle{
                        width: 20;
                        height: 15;
                        color: speedLabel.value.toFixed(0) > 187.75 ? root.speedColor(speedLabel.value) : "#01E6DC"
                    }

                    Rectangle{
                        width: 20;
                        height: 15;
                        color: speedLabel.value.toFixed(0) > 219 ? root.speedColor(speedLabel.value) : "#01E6DC"
                    }

                }
                Label{
                    text: speedLabel.value.toFixed(0) + " MPH ";
                    font.pixelSize: 32;
                    font.family: "Inter";
                    font.bold: Font.Normal;
                    color: "#FFFFFF"
                }
            }

            RowLayout {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin: 75
                anchors.rightMargin: 200
                spacing: 100

                ColumnLayout {
                    spacing: 5;
                    Image {
                        width: 45;
                        height: 30;
                        source: "qrc:/assets/road.svg" }

                    Label {
                        text: "188 KM";
                        font.pixelSize: 20;
                        color: "#FFFFFF";
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        text: "Distance";
                        font.pixelSize: 14;
                        color: "#FFFFFF";
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                ColumnLayout {
                    spacing: 5;
                    Image {
                        width: 45;
                        height: 30;
                        source: "qrc:/assets/fuel.svg"
                    }

                    Label {
                        text: "34 mpg";
                        font.pixelSize: 20;
                        color: "#FFFFFF";
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label
                    { text: "Avg. Fuel Usage";
                        font.pixelSize: 14;
                        color: "#FFFFFF";
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                ColumnLayout {
                    spacing: 5;
                    Image {
                        width: 45;
                        height: 30;
                        source: "qrc:/assets/speedometer.svg"
                    }

                    Label {
                        text: "78 mph";
                        font.pixelSize: 20;
                        color: "#FFFFFF";
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        text: "Avg. Speed";
                        font.pixelSize: 14;
                        color: "#FFFFFF";
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            RadialBar {
                id:radialBar
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 6
                width: 338
                height: 338
                penStyle: Qt.RoundCap
                dialType: RadialBar.NoDial
                progressColor: "#01E4E0"
                backgroundColor: "transparent"
                dialWidth: 17
                startAngle: 270
                spanAngle: 3.6 * value
                minValue: 0
                maxValue: 100
                value: accelerating ? maxValue : 65
                textFont {
                    family: "inter";
                    italic: false;
                    bold: Font.Medium;
                    pixelSize: 60 }
                showText: false;
                suffixText: "";
                textColor: "#FFFFFF"
                property bool accelerating
                Behavior on value {
                    NumberAnimation {
                        duration: 1000
                    }
                }

                ColumnLayout{
                    anchors.centerIn: parent

                    Label{
                        text: radialBar.value.toFixed(0) + "%";
                        font.pixelSize: 65;
                        font.family: "Inter";
                        font.bold: Font.Normal;
                        color: "#FFFFFF";
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label{
                        text: "Battery charge";
                        font.pixelSize: 28;
                        font.family: "Inter";
                        font.bold: Font.Normal;
                        opacity: 0.8;
                        color: "#FFFFFF";
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Icons
            Image {
                id: forthLeftIndicator
                property bool parkingLightOn: true
                width: 72
                height: 62
                anchors.left: parent.left
                anchors.leftMargin: 175
                anchors.bottom: thirdLeftIndicator.top
                anchors.bottomMargin: 25
                source: parkingLightOn ? "qrc:/assets/xinhantrai.svg" : "qrc:/assets/xinhantraibat.svg"
                Behavior on parkingLightOn {
                    NumberAnimation {
                        duration: 300
                    }
                }

                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        forthLeftIndicator.parkingLightOn = !forthLeftIndicator.parkingLightOn
                    }
                }
            }

            Image {
                id: thirdLeftIndicator
                property bool lightOn: true
                width: 52
                height: 70.2
                anchors.left: parent.left
                anchors.leftMargin: 145
                anchors.bottom: secondLeftIndicator.top
                anchors.bottomMargin: 25
                source: lightOn ? "qrc:/assets/Lights.svg" : "qrc:/assets/Light_White.svg"
                Behavior on lightOn {
                    NumberAnimation {
                        duration: 300
                    }
                }

                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        thirdLeftIndicator.lightOn = !thirdLeftIndicator.lightOn
                    }
                }
            }

            Image {
                id: secondLeftIndicator
                property bool headLightOn: true
                width: 51
                height: 51
                anchors.left: parent.left
                anchors.leftMargin: 125
                anchors.bottom: firstLeftIndicator.top
                anchors.bottomMargin: 30
                source: headLightOn ?  "qrc:/assets/Low beam headlights.svg" : "qrc:/assets/Low_beam_headlights_white.svg"
                Behavior on headLightOn {
                    NumberAnimation {
                        duration: 300
                    }
                }

                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        secondLeftIndicator.headLightOn = !secondLeftIndicator.headLightOn
                    }
                }
            }

            Image {
                id: firstLeftIndicator
                property bool rareLightOn: false
                width: 51
                height: 51
                anchors.left: parent.left
                anchors.leftMargin: 100
                anchors.verticalCenter: speedLabel.verticalCenter
                source: rareLightOn ? "qrc:/assets/Rare_fog_lights_red.svg" : "qrc:/assets/Rare fog lights.svg"
                Behavior on rareLightOn {
                    NumberAnimation {
                        duration: 300
                    }
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        firstLeftIndicator.rareLightOn = !firstLeftIndicator.rareLightOn
                    }
                }
            }

            Image {
                id: forthRightIndicator
                property bool indicator: true
                width: 72
                height: 62
                anchors.right: parent.right
                anchors.rightMargin: 195
                anchors.bottom: thirdRightIndicator.top
                anchors.bottomMargin: 50
                source: indicator ? "qrc:/assets/xinhanphai.svg" : "qrc:/assets/xinhanphaibat.svg"
                Behavior on indicator {
                    NumberAnimation {
                        duration: 300
                    }
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        forthRightIndicator.indicator = !forthRightIndicator.indicator
                    }
                }
            }

            Image {
                id: thirdRightIndicator
                property bool indicator: true
                width: 56.83
                height: 36.17
                anchors.right: parent.right
                anchors.rightMargin: 155
                anchors.bottom: secondRightIndicator.top
                anchors.bottomMargin: 50
                source: indicator ? "qrc:/assets/thirdRightIcon.svg" : "qrc:/assets/thirdRightIcon_red.svg"
                Behavior on indicator {
                    NumberAnimation {
                        duration: 300
                    }
                }

                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        thirdRightIndicator.indicator = !thirdRightIndicator.indicator
                    }
                }
            }

              Image {
                id: secondRightIndicator
                property bool indicator: true
                width: 56.83
                height: 36.17
                anchors.right: parent.right
                anchors.rightMargin: 125
                anchors.bottom: firstRightIndicator.top
                anchors.bottomMargin: 50
                source: indicator ? "qrc:/assets/FourthRightIcon.svg" : "qrc:/assets/FourthRightIcon_red.svg"
                Behavior on indicator {
                    NumberAnimation {
                        duration: 300
                    }
                }

                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        secondRightIndicator.indicator = !secondRightIndicator.indicator
                    }
                }
            }

            Image {
                id: firstRightIndicator
                property bool sheetBelt: true
                width: 36
                height: 45
                anchors.right: parent.right
                anchors.rightMargin: 100
                anchors.verticalCenter: speedLabel.verticalCenter
                source: sheetBelt ? "qrc:/assets/FirstRightIcon_grey.svg" : "qrc:/assets/FirstRightIcon.svg"
                Behavior on sheetBelt { NumberAnimation { duration: 300 }}

                MouseArea{
                    anchors.fill: parent;
                    onClicked: { firstRightIndicator.sheetBelt = !firstRightIndicator.sheetBelt } }
            }
        }
    }

    // =========================================================================
    // 2. MÀN HÌNH IVI (MẶC ĐỊNH ẨN)
    // =========================================================================
    Item {
        id: iviHMI
        width: parent.width
        height: parent.height
        visible: false // Mặc định ẩn

        // Biến riêng cho IVI
        property bool isDarkMode: false
        property bool isEnglish: false
        property var routePath: []
        property var routeSegments: []
        property int currentStep: 0

        // Theme cho IVI
        property color themeBgColor: isDarkMode ? "#1a1a1a" : "#ffffff"
        property color themeTextColor: isDarkMode ? "#ffffff" : "#333333"
        property color themePanelColor: isDarkMode ? "#cc000000" : "#f0ffffff"
        property color themeInputBg: isDarkMode ? "#333333" : "#f5f7f9"

        // Nút BACK để quay về Cluster (QUAN TRỌNG)
        Rectangle {
            z: 99999
            width: 120
            height: 50
            color: "#01E6DE"
            radius: 25
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20

            Row {
                anchors.centerIn: parent
                spacing: 5
                Text { text: "BACK"; font.bold: true; color: "white" }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Tắt switch và quay về Cluster
                    screenSwitch.checked = false
                    clusterHMI.visible = true
                    iviHMI.visible = false
                }
            }
        }

        // Sidebar
        Rectangle {
            id: leftSidebar
            width: 200; height: parent.height
            color: iviHMI.themeBgColor
            anchors.left: parent.left
            Rectangle {
                width: 1;
                height: parent.height;
                anchors.right: parent.right;
                color: iviHMI.isDarkMode ? "#444" : "#ddd"
            }
            Column {
                anchors.centerIn: parent;
                width: parent.width - 40;
                spacing: 30

                Text {
                    text: iviHMI.isEnglish ? "SETTINGS" : "CÀI ĐẶT";
                    font.bold: true;
                    font.pixelSize: 20;
                    color: iviHMI.themeTextColor;
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    spacing: 10;
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        text: iviHMI.isEnglish ? "Dark Mode" : "Chế độ tối";
                        color: iviHMI.themeTextColor;
                        font.pixelSize: 14
                    }
                    Switch {
                        checked: iviHMI.isDarkMode;
                        onCheckedChanged: iviHMI.isDarkMode = checked;
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Column {
                    spacing: 10;
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        text: iviHMI.isEnglish ? "Language (Eng)" : "Ngôn ngữ (Anh)";
                        color: iviHMI.themeTextColor;
                        font.pixelSize: 14
                    }
                    Switch {
                        checked: iviHMI.isEnglish;
                        onCheckedChanged: iviHMI.isEnglish = checked;
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        Item {
            id : mapView
            width: parent.width - leftSidebar.width
            height: parent.height
            anchors.right: parent.right

            Plugin {
                id: mapboxPluginIVI
                name: "mapboxgl"
                PluginParameter {
                    name: "mapboxgl.access_token";
                    value: "pk.eyJ1Ijoibmd1eWVuaHVuZzQ4OCIsImEiOiJjbWk3MDNmeHAwNXJwMnFvZnVzdGo1dTdsIn0.MMBnkjFbPkXremQIgVIF3Q"
                }
                PluginParameter {
                    name: "mapboxgl.mapping.additional_style_urls";
                    value: iviHMI.isDarkMode ? "mapbox://styles/mapbox/dark-v10" : "mapbox://styles/mapbox/streets-v11"
                }
            }
            Plugin {
                id: osmPlugin;
                name: "osm"
            }

            GeocodeModel {
                id: geocodeStart;
                plugin: osmPlugin;
                autoUpdate: false;
                onLocationsChanged: {
                    if (count > 0) { routeQuery.addWaypoint(get(0).coordinate);
                        geocodeEnd.query = txtTo.text;
                        geocodeEnd.update()
                    }
                }
            }

            GeocodeModel {
                id: geocodeEnd;
                plugin: osmPlugin;
                autoUpdate: false;
                onLocationsChanged: {
                    if (count > 0) {
                        routeQuery.addWaypoint(get(0).coordinate);
                        routeModel.update()
                    }
                }
            }

            RouteModel {
                id: routeModel
                plugin: osmPlugin; query: RouteQuery { id: routeQuery } autoUpdate: false
                onStatusChanged: {
                    if (status == RouteModel.Ready) {
                        var route = get(0)
                        iviHMI.routePath = route.path
                        iviHMI.routeSegments = route.segments
                        mapIVI.visibleRegion = route.bounds
                        btnSimulate.enabled = true
                        var dist = (route.distance/1000).toFixed(1)
                        instructionText.text = iviHMI.isEnglish ? "Route found: " + dist + " km" : "Đã tìm thấy đường: " + dist + " km"
                    }
                }
            }

            Map {
                id: mapIVI
                anchors.fill: parent
                plugin: mapboxPluginIVI
                center: QtPositioning.coordinate(16.0544, 108.2022)
                zoomLevel: 14

                MapItemView {
                    model: routeModel;
                    delegate: MapRoute {
                        route: routeData;
                        line.color: iviHMI.isDarkMode ? "#4fc3f7" : "#3b99fc";
                        line.width: 6; smooth: true
                    }
                }

                MapQuickItem {
                    coordinate: routeQuery.waypoints.length > 0 ? routeQuery.waypoints[0] : QtPositioning.coordinate(0,0);
                    visible: routeQuery.waypoints.length > 0;
                    anchorPoint.x: sourceItem.width/2;
                    anchorPoint.y: sourceItem.height;
                    sourceItem: Image {
                        source: "qrc:/icon/final_location.png";
                        width: 40;
                        height: 40
                    }
                }

                MapQuickItem {
                    coordinate: routeQuery.waypoints.length > 1 ? routeQuery.waypoints[1] : QtPositioning.coordinate(0,0);
                    visible: routeQuery.waypoints.length > 1;
                    anchorPoint.x: sourceItem.width/2;
                    anchorPoint.y: sourceItem.height;
                    sourceItem: Image {
                        source: "qrc:/icon/final_location.png";
                        width: 40;
                        height: 40
                    }
                }

                MapQuickItem {
                    id: navMarker
                    visible: simTimer.running
                    coordinate: mapIVI.center
                    anchorPoint.x: carImg.width / 2;
                    anchorPoint.y: carImg.height / 2
                    Behavior on coordinate {
                        CoordinateAnimation {
                            duration: 150
                        }
                    }
                    sourceItem: Image {
                        id: carImg;
                        source: "qrc:/icon/car-removebg-preview.png";
                        width: 60;
                        height: 60;
                        fillMode: Image.PreserveAspectFit;
                        transform: Rotation {
                            origin.x: carImg.width / 2;
                            origin.y: carImg.height / 2;
                            angle: navMarker.rotation
                        }
                    }
                    property real rotation: 0
                }
            }

            Rectangle {
                anchors.top: parent.top;
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.topMargin: 20
                width: Math.min(parent.width - 40, 700);
                height: contentRow.height + 30;
                color: iviHMI.themePanelColor;
                radius: 15
                visible: simTimer.running || instructionText.text.includes("Đã") || instructionText.text.includes("found")

                Row {
                    id: contentRow;
                    anchors.centerIn: parent;
                    spacing: 15;
                    width: parent.width - 30

                    Image {
                        id: iconTurn;
                        source: "https://img.icons8.com/ios-filled/50/ffffff/compass.png";
                        width: 30;
                        height: 30;
                        anchors.verticalCenter: parent.verticalCenter;
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        id: instructionText;
                        text: iviHMI.isEnglish ? "Ready to navigate" : "Sẵn sàng tìm đường";
                        color: iviHMI.themeTextColor;
                        font.pixelSize: 18;
                        font.bold: true;
                        width: parent.width - iconTurn.width - parent.spacing;
                        wrapMode: Text.WordWrap;
                        horizontalAlignment: Text.AlignHCenter;
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.margins: 20;
                anchors.bottomMargin: 30
                width: 340;
                height: 230;
                color: iviHMI.themePanelColor;
                radius: 15;
                border.color: iviHMI.isDarkMode ? "#444" : "#e0e0e0";
                border.width: 1;
                layer.enabled: true

                Column {
                    anchors.centerIn: parent;
                    width: parent.width - 40;
                    spacing: 12

                    Text {
                        text: iviHMI.isEnglish ? "🚗 Navigation Route" : "🚗 Lộ trình di chuyển";
                        font.bold: true;
                        font.pixelSize: 16;
                        color: iviHMI.themeTextColor
                    }

                    TextField {
                        id: txtFrom;
                        width: parent.width;
                        placeholderText: iviHMI.isEnglish ? "From..." : "Điểm đi...";
                        text: "Sân bay Đà Nẵng";
                        font.pixelSize: 14; color: iviHMI.themeTextColor;
                        background: Rectangle {
                            color: iviHMI.themeInputBg;
                            radius: 8;
                            border.color: txtFrom.activeFocus ? "#2196F3" : (iviHMI.isDarkMode ? "#555" : "#e0e0e0") }
                    }

                    TextField {
                        id: txtTo;
                        width: parent.width;
                        placeholderText: iviHMI.isEnglish ? "To..." : "Điểm đến..."; text: "Cầu Rồng";
                        font.pixelSize: 14;
                        color: iviHMI.themeTextColor;
                        background: Rectangle {
                            color: iviHMI.themeInputBg; radius: 8;
                            border.color: txtTo.activeFocus ? "#2196F3" : (iviHMI.isDarkMode ? "#555" : "#e0e0e0")
                        }
                    }

                    Row {
                        width: parent.width;
                        spacing: 10

                        Button {
                            text: iviHMI.isEnglish ? "Find Route" : "Tìm đường";
                            width: (parent.width - 10) / 2;
                            height: 40;
                            background: Rectangle {
                                color: parent.down ? "#1976D2" : "#2196F3";
                                radius: 8
                            }

                            contentItem: Text {
                                text: parent.text;
                                color: "white";
                                font.bold: true;
                                horizontalAlignment: Text.AlignHCenter;
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: {
                                simTimer.running = false;
                                routeQuery.clearWaypoints();
                                routeModel.reset();
                                geocodeStart.query = txtFrom.text;
                                geocodeStart.update();
                                btnSimulate.enabled = false
                            }
                        }

                        Button {
                            id: btnSimulate;
                            text: simTimer.running ? (iviHMI.isEnglish ? "Stop" : "Dừng lại") : (iviHMI.isEnglish ? "Start" : "Chạy xe");
                            width: (parent.width - 10) / 2;
                            height: 40;
                            enabled: false;
                            background: Rectangle {
                                color: !parent.enabled ? "#cccccc" : (parent.down ? "#388E3C" : "#4CAF50");
                                radius: 8
                            }

                            contentItem: Text {
                                text: parent.text;
                                color: "white";
                                font.bold: true;
                                horizontalAlignment: Text.AlignHCenter;
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: {
                                if (simTimer.running) { simTimer.stop()
                                }
                                else { iviHMI.currentStep = 0; mapIVI.zoomLevel = 16.5; mapIVI.tilt = 60; simTimer.start()
                                }
                            }
                        }
                    }
                }
            }

            Timer {
                id: simTimer; interval: 150; repeat: true
                onTriggered: {
                    if (iviHMI.currentStep >= iviHMI.routePath.length - 1) {
                        stop();
                        instructionText.text = iviHMI.isEnglish ? "Arrived!" : "Đã đến nơi!";
                        return
                    }
                    var currentCoord = iviHMI.routePath[iviHMI.currentStep];
                    var nextCoord = iviHMI.routePath[iviHMI.currentStep + 1]
                    navMarker.coordinate = currentCoord;
                    mapIVI.center = currentCoord;
                    navMarker.rotation = currentCoord.azimuthTo(nextCoord)
                    mapView.updateInstruction(currentCoord)
                    iviHMI.currentStep++
                }
            }

            function updateInstruction(currentPos) {
                for (var i = 0; i < iviHMI.routeSegments.length; i++) {
                    var segment = iviHMI.routeSegments[i];
                    var maneuver = segment.maneuver
                    if (!maneuver.valid) continue;
                    var dist = currentPos.distanceTo(maneuver.position)
                    if (dist < 40) {
                        var rawText = maneuver.instructionText
                        if (!iviHMI.isEnglish) {
                            rawText = rawText.replace("Turn left onto", "Rẽ trái vào");
                            rawText = rawText.replace("Turn right onto", "Rẽ phải vào");
                            rawText = rawText.replace("Turn left", "Rẽ trái");
                            rawText = rawText.replace("Turn right", "Rẽ phải");
                            rawText = rawText.replace("Make a U-turn", "Quay đầu xe");
                            rawText = rawText.replace("Head", "Đi về hướng");
                            rawText = rawText.replace("Continue", "Tiếp tục đi");
                            rawText = rawText.replace("Arrive at", "Đến điểm");
                            rawText = rawText.replace("Enter the roundabout", "Vào vòng xoay");
                            rawText = rawText.replace("Take the", "Đi theo lối ra");
                            rawText = rawText.replace("exit", "");
                            rawText = rawText.replace("north", "Bắc");
                            rawText = rawText.replace("south", "Nam");
                            rawText = rawText.replace("east", "Đông");
                            rawText = rawText.replace("west", "Tây") }
                            instructionText.text = rawText
                        var textLower = maneuver.instructionText.toLowerCase()
                        if (textLower.includes("left"))
                            iconTurn.source = "https://img.icons8.com/ios-filled/50/ffffff/left.png"
                        else if (textLower.includes("right"))
                            iconTurn.source = "https://img.icons8.com/ios-filled/50/ffffff/right.png"
                        else if (textLower.includes("u-turn"))
                            iconTurn.source = "https://img.icons8.com/ios-filled/50/ffffff/u-turn.png"
                        else iconTurn.source = "https://img.icons8.com/ios-filled/50/ffffff/long-arrow-up.png"
                        break
                    }
                }
            }
        }

        // --- INTRO GIF (ĐÃ THÊM VÀO ĐÂY) ---
        Rectangle {
            id: introLayer
            anchors.fill: parent
            color: "black"
            z: 9999 // Nằm trên cùng
            visible: false // Mặc định ẩn, chỉ hiện khi chuyển sang IVI

            AnimatedImage {
                id: gifPlayer
                source: "https://i.pinimg.com/originals/46/1b/c3/461bc3941474e17e43c4bc0c2e4c3af5.gif"
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                playing: introLayer.visible // Chỉ chạy khi intro hiện

                onCurrentFrameChanged: {
                    if (currentFrame === gifPlayer.frameCount - 1) {
                        delayTimer.start()
                    }
                }
            }

            Timer {
                id: delayTimer
                interval: 500
                repeat: false
                onTriggered: introLayer.visible = false
            }

            MouseArea {
                anchors.fill: parent
                onClicked: introLayer.visible = false
            }

            Text {
                text: iviHMI.isEnglish ? "Tap to skip >>" : "Chạm để bỏ qua >>"
                color: "white"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 20
                font.pixelSize: 14
                opacity: 0.7
            }
        }
    }
}
