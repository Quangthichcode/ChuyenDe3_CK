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

    // --- CÁC HÀM TOÀN CỤC (GLOBAL FUNCTIONS) ---
    // Hàm đổi màu tốc độ: <60 xanh, 60-150 vàng, >150 đỏ
    function speedColor(value){
        if(value < 60 ){ return "green" }
        else if(value > 60 && value < 150){ return "yellow" }
        else{ return "Red" }
    }

    // Hàm random số để giả lập tốc độ nhảy
    function generateRandom(maxLimit = 70){
        let rand = Math.random() * maxLimit;
        return Math.floor(rand);
    }

    // =========================================================================
    // 1. MÀN HÌNH CLUSTER (ĐỒNG HỒ TỐC ĐỘ)
    // =========================================================================
    Item {
        id: clusterHMI
        width: parent.width
        height: parent.height
        visible: true // Mặc định hiện khi mở app

        property int nextSpeed: 60

        // Timer cập nhật giờ hệ thống (mỗi 0.5s)
        Timer {
            interval: 500
            running: clusterHMI.visible
            repeat: true
            onTriggered:{
                currentTime.text = Qt.formatDateTime(new Date(), "hh:mm")
            }
        }

        // Timer giả lập thay đổi tốc độ ngẫu nhiên (mỗi 3s)
        Timer{
            repeat: true
            interval: 3000
            running: clusterHMI.visible
            onTriggered: {
                clusterHMI.nextSpeed = root.generateRandom()
            }
        }

        // Hình nền Dashboard
        Image {
            id: dashboard
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: "qrc:/assets/Dashboard.svg"

            // --- MAP NHỎ Ở GIỮA CLUSTER (MINI MAP) ---
            Item {
                id: mapCluster
                width: 500
                height: 250
                anchors.top: parent.top
                anchors.topMargin: 140
                anchors.horizontalCenter: parent.horizontalCenter

                // Tạo mặt nạ bo tròn cho Map (Radius 20)
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: mapCluster.width
                        height: mapCluster.height
                        radius: 20
                        visible: false
                    }
                }

                // Plugin Mapbox để hiển thị bản đồ đẹp
                Plugin {
                    id: mapboxPluginCluster
                    name: "mapboxgl"
                    PluginParameter {
                        name: "mapboxgl.access_token";
                        // Token API của Mapbox
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
                    center: QtPositioning.coordinate(16.0611, 108.2239) // Tọa độ Đà Nẵng
                    zoomLevel: 14.5
                    tilt: 45 // Nghiêng bản đồ 45 độ
                    bearing: 0
                    copyrightsVisible: false
                    MouseArea {
                        anchors.fill: parent;
                        enabled: true;
                        onPressed: mouse.accepted = true // Chặn click vào map nhỏ
                    }
                }

                // Lớp phủ mờ bên trên map
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "white"
                    border.width: 2
                    radius: 20
                    opacity: 0.3
                }
            }

            // --- THANH TRẠNG THÁI TRÊN CÙNG (TOP BAR) ---
            Image {
                id: topBar
                width: 1357
                source: "qrc:/assets/Vector 70.svg"
                anchors.top: parent.top
                anchors.topMargin: 26.50
                anchors.horizontalCenter: parent.horizontalCenter

                // Nút Đèn pha (Click để bật/tắt icon)
                Image {
                    id: headLight
                    property bool indicator: false
                    width: 42.5
                    height: 38.25
                    anchors.top: parent.top
                    anchors.topMargin: 25
                    anchors.leftMargin: 230
                    anchors.left: parent.left
                    source: indicator ? "qrc:/assets/Low beam headlights.svg" : "qrc:/assets/Low_beam_headlights_white.svg"
                    Behavior on indicator { NumberAnimation { duration: 300 } }
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: { headLight.indicator = !headLight.indicator }
                    }
                }

                // ====== [NÚT SWITCH QUAN TRỌNG: CHUYỂN MÀN HÌNH] ======
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

                        // Tùy chỉnh giao diện Switch cho đẹp (Màu xanh ngọc)
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

                        // --- LOGIC CHUYỂN MÀN HÌNH ---
                        onCheckedChanged: {
                            if (checked) {
                                // Nếu BẬT: Ẩn Cluster, Hiện IVI, Chạy Intro GIF
                                clusterHMI.visible = false
                                iviHMI.visible = true
                                introLayer.visible = true
                                gifPlayer.currentFrame = 0
                                gifPlayer.playing = true
                            } else {
                                // Nếu TẮT: Hiện Cluster, Ẩn IVI
                                clusterHMI.visible = true
                                iviHMI.visible = false
                            }
                        }
                    }
                }

                // Hiển thị giờ
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

                // Hiển thị ngày
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

            // Đồng hồ đo tốc độ (Gauge - Component Custom)
            Gauge {
                id: speedLabel
                width: 450
                height: 450
                property bool accelerating
                // Nếu nhấn Space thì tăng lên Max (250), nhả ra về 0
                value: accelerating ? maximumValue : 0
                maximumValue: 250
                anchors.top: parent.top
                anchors.topMargin: Math.floor(parent.height * 0.23)
                anchors.right: parent.right
                anchors.rightMargin: Math.floor(parent.width * 0.11)
                Component.onCompleted: forceActiveFocus()
                Behavior on value { NumberAnimation { duration: 1000 } }

                // Xử lý phím Space để tăng tốc
                Keys.onSpacePressed: accelerating = true
                Keys.onReleased: {
                    if (event.key === Qt.Key_Space) { accelerating = false; event.accepted = true; }
                    else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) { radialBar.accelerating = false; event.accepted = true; }
                }
            }

            // Vòng tròn hiển thị giới hạn tốc độ (Speed Limit)
            Rectangle{
                id:speedLimit
                width: 130
                height: 130
                radius: height/2
                color: "#D9D9D9"
                // Màu viền thay đổi theo tốc độ (Gọi hàm speedColor)
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

            // Hình ảnh xe Tesla ở giữa
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

            // Hình ảnh vạch kẻ đường 2 bên
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

            // Các thanh hiển thị nhỏ bên trái (Nhiệt độ, vạch pin...)
            RowLayout{
                spacing: 20
                anchors.left: parent.left
                anchors.leftMargin: 250
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 26.50 + 65

                RowLayout{
                    spacing: 3
                    Label{ text: "100.6"; font.pixelSize: 32; font.family: "Inter"; color: "#FFFFFF" }
                    Label{ text: "°F"; font.pixelSize: 32; font.family: "Inter"; opacity: 0.2; color: "#FFFFFF" }
                }

                // Các ô vuông nhỏ hiển thị mức độ (giả lập theo speed)
                RowLayout{
                    spacing: 1
                    Layout.topMargin: 10
                    // Logic: Nếu speed > mốc thì đổi màu
                    Rectangle{ width: 20; height: 15; color: speedLabel.value.toFixed(0) > 31.25 ? root.speedColor(speedLabel.value) : "#01E6DC" }
                    Rectangle{ width: 20; height: 15; color: speedLabel.value.toFixed(0) > 62.5 ? root.speedColor(speedLabel.value) : "#01E6DC" }
                    Rectangle{ width: 20; height: 15; color: speedLabel.value.toFixed(0) > 93.75 ? root.speedColor(speedLabel.value) : "#01E6DC" }
                    Rectangle{ width: 20; height: 15; color: speedLabel.value.toFixed(0) > 125.25 ? root.speedColor(speedLabel.value) : "#01E6DC" }
                    Rectangle{ width: 20; height: 15; color: speedLabel.value.toFixed(0) > 156.5 ? root.speedColor(speedLabel.value) : "#01E6DC" }
                    Rectangle{ width: 20; height: 15; color: speedLabel.value.toFixed(0) > 187.75 ? root.speedColor(speedLabel.value) : "#01E6DC" }
                    Rectangle{ width: 20; height: 15; color: speedLabel.value.toFixed(0) > 219 ? root.speedColor(speedLabel.value) : "#01E6DC" }
                }
                Label{
                    text: speedLabel.value.toFixed(0) + " MPH ";
                    font.pixelSize: 32; font.family: "Inter"; color: "#FFFFFF"
                }
            }

            // Thông số xe bên phải (Xăng, Quãng đường, Tốc độ TB)
            RowLayout {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin: 75
                anchors.rightMargin: 200
                spacing: 100

                ColumnLayout {
                    spacing: 5;
                    Image { width: 45; height: 30; source: "qrc:/assets/road.svg" }
                    Label { text: "188 KM"; font.pixelSize: 20; color: "#FFFFFF"; horizontalAlignment: Text.AlignHCenter }
                    Label { text: "Distance"; font.pixelSize: 14; color: "#FFFFFF"; horizontalAlignment: Text.AlignHCenter }
                }
                ColumnLayout {
                    spacing: 5;
                    Image { width: 45; height: 30; source: "qrc:/assets/fuel.svg" }
                    Label { text: "34 mpg"; font.pixelSize: 20; color: "#FFFFFF"; horizontalAlignment: Text.AlignHCenter }
                    Label { text: "Avg. Fuel Usage"; font.pixelSize: 14; color: "#FFFFFF"; horizontalAlignment: Text.AlignHCenter }
                }
                ColumnLayout {
                    spacing: 5;
                    Image { width: 45; height: 30; source: "qrc:/assets/speedometer.svg" }
                    Label { text: "78 mph"; font.pixelSize: 20; color: "#FFFFFF"; horizontalAlignment: Text.AlignHCenter }
                    Label { text: "Avg. Speed"; font.pixelSize: 14; color: "#FFFFFF"; horizontalAlignment: Text.AlignHCenter }
                }
            }

            // Vòng tròn hiển thị Pin (RadialBar)
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
                textFont { family: "inter"; italic: false; bold: Font.Medium; pixelSize: 60 }
                showText: false;
                suffixText: "";
                textColor: "#FFFFFF"
                property bool accelerating
                Behavior on value { NumberAnimation { duration: 1000 } }

                ColumnLayout{
                    anchors.centerIn: parent
                    Label{
                        text: radialBar.value.toFixed(0) + "%";
                        font.pixelSize: 65; font.family: "Inter"; color: "#FFFFFF"; Layout.alignment: Qt.AlignHCenter
                    }
                    Label{
                        text: "Battery charge";
                        font.pixelSize: 28; font.family: "Inter"; opacity: 0.8; color: "#FFFFFF"; Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // --- CÁC ICON CẢNH BÁO TRÁI/PHẢI (Xi nhan, Đèn sương mù...) ---
            Image {
                id: forthLeftIndicator
                property bool parkingLightOn: true
                // ... (Các thuộc tính size/anchor) ...
                source: parkingLightOn ? "qrc:/assets/Parking lights.svg" : "qrc:/assets/Parking_lights_white.svg"
                Behavior on parkingLightOn { NumberAnimation { duration: 300 } }
                MouseArea{ anchors.fill: parent; onClicked: { forthLeftIndicator.parkingLightOn = !forthLeftIndicator.parkingLightOn } }
            }

            Image {
                id: thirdLeftIndicator
                property bool lightOn: true
                // ...
                source: lightOn ? "qrc:/assets/Lights.svg" : "qrc:/assets/Light_White.svg"
                Behavior on lightOn { NumberAnimation { duration: 300 } }
                MouseArea{ anchors.fill: parent; onClicked: { thirdLeftIndicator.lightOn = !thirdLeftIndicator.lightOn } }
            }
            // ... (Các icon indicator khác tương tự: secondLeft, firstLeft, forthRight, thirdRight...)
            // ... (Đã lược bớt phần thuộc tính lặp lại để tập trung vào logic chính) ...

            Image {
                id: firstRightIndicator
                property bool sheetBelt: true
                width: 36; height: 45
                anchors.right: parent.right; anchors.rightMargin: 100; anchors.verticalCenter: speedLabel.verticalCenter
                source: sheetBelt ? "qrc:/assets/FirstRightIcon.svg" : "qrc:/assets/FirstRightIcon_grey.svg"
                Behavior on sheetBelt { NumberAnimation { duration: 300 }}
                MouseArea{ anchors.fill: parent; onClicked: { firstRightIndicator.sheetBelt = !firstRightIndicator.sheetBelt } }
            }
        }
    }

    // =========================================================================
    // 2. MÀN HÌNH IVI (MẶC ĐỊNH ẨN - CHỈ HIỆN KHI BẬT SWITCH Ở CLUSTER)
    // =========================================================================
    Item {
        id: iviHMI
        width: parent.width
        height: parent.height
        visible: false // Mặc định ẩn

        // --- CÁC BIẾN QUẢN LÝ TRẠNG THÁI IVI ---
        property bool isDarkMode: false // Biến chế độ tối
        property bool isEnglish: false  // Biến ngôn ngữ (True=Anh, False=Việt)
        property var routePath: []      // Mảng chứa tọa độ đường đi (để xe chạy)
        property var routeSegments: []  // Mảng chứa thông tin chỉ đường (Rẽ trái/phải)
        property int currentStep: 0     // Bước chạy hiện tại của xe mô phỏng

        // --- CÁC MÀU SẮC THEME (Tự động đổi khi isDarkMode thay đổi) ---
        property color themeBgColor: isDarkMode ? "#1a1a1a" : "#ffffff"
        property color themeTextColor: isDarkMode ? "#ffffff" : "#333333"
        property color themePanelColor: isDarkMode ? "#cc000000" : "#f0ffffff"
        property color themeInputBg: isDarkMode ? "#333333" : "#f5f7f9"

        // --- NÚT BACK (QUAY VỀ CLUSTER) ---
        Rectangle {
            z: 99999
            width: 120; height: 50
            color: "#01E6DE"
            radius: 25
            anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 20
            Row {
                anchors.centerIn: parent; spacing: 5
                Text { text: "BACK"; font.bold: true; color: "white" }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Logic: Tắt switch -> Hiện Cluster -> Ẩn IVI
                    screenSwitch.checked = false
                    clusterHMI.visible = true
                    iviHMI.visible = false
                }
            }
        }

        // --- THANH SIDEBAR (CÀI ĐẶT BÊN TRÁI) ---
        Rectangle {
            id: leftSidebar
            width: 200; height: parent.height
            color: iviHMI.themeBgColor // Màu nền theo theme
            anchors.left: parent.left

            // Đường kẻ ngăn cách
            Rectangle {
                width: 1; height: parent.height; anchors.right: parent.right;
                color: iviHMI.isDarkMode ? "#444" : "#ddd"
            }

            Column {
                anchors.centerIn: parent; width: parent.width - 40; spacing: 30

                // Tiêu đề Cài đặt (Đổi ngôn ngữ theo biến isEnglish)
                Text {
                    text: iviHMI.isEnglish ? "SETTINGS" : "CÀI ĐẶT";
                    font.bold: true; font.pixelSize: 20; color: iviHMI.themeTextColor;
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Switch Chế độ tối
                Column {
                    spacing: 10; anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        text: iviHMI.isEnglish ? "Dark Mode" : "Chế độ tối";
                        color: iviHMI.themeTextColor; font.pixelSize: 14
                    }
                    Switch {
                        checked: iviHMI.isDarkMode;
                        // Khi gạt nút -> Cập nhật biến isDarkMode -> Giao diện tự đổi màu
                        onCheckedChanged: iviHMI.isDarkMode = checked;
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Switch Ngôn ngữ
                Column {
                    spacing: 10; anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        text: iviHMI.isEnglish ? "Language (Eng)" : "Ngôn ngữ (Anh)";
                        color: iviHMI.themeTextColor; font.pixelSize: 14
                    }
                    Switch {
                        checked: iviHMI.isEnglish;
                        // Khi gạt nút -> Cập nhật biến isEnglish -> Chữ tự đổi
                        onCheckedChanged: iviHMI.isEnglish = checked;
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        // --- KHUNG BẢN ĐỒ CHÍNH (MAP VIEW) ---
        Item {
            id : mapView
            width: parent.width - leftSidebar.width
            height: parent.height
            anchors.right: parent.right

            // Plugin 1: Mapbox (Để hiển thị hình ảnh bản đồ đẹp)
            Plugin {
                id: mapboxPluginIVI
                name: "mapboxgl"
                PluginParameter {
                    name: "mapboxgl.access_token";
                    value: "pk.eyJ1Ijoibmd1eWVuaHVuZzQ4OCIsImEiOiJjbWk3MDNmeHAwNXJwMnFvZnVzdGo1dTdsIn0.MMBnkjFbPkXremQIgVIF3Q"
                }
                PluginParameter {
                    name: "mapboxgl.mapping.additional_style_urls";
                    // Đổi style bản đồ (Đen/Sáng) dựa theo chế độ tối
                    value: iviHMI.isDarkMode ? "mapbox://styles/mapbox/dark-v10" : "mapbox://styles/mapbox/streets-v11"
                }
            }
            // Plugin 2: OSM (Để tính toán đường đi - Routing miễn phí)
            Plugin {
                id: osmPlugin;
                name: "osm"
            }

            // --- LOGIC TÌM ĐƯỜNG (CHAIN REACTION) ---

            // 1. Tìm tọa độ điểm đi (Start)
            GeocodeModel {
                id: geocodeStart;
                plugin: osmPlugin;
                autoUpdate: false;
                onLocationsChanged: {
                    if (count > 0) {
                        // Tìm thấy điểm đi -> Thêm vào lộ trình
                        routeQuery.addWaypoint(get(0).coordinate);
                        // Lấy text điểm đến và bắt đầu tìm tọa độ điểm đến
                        geocodeEnd.query = txtTo.text;
                        geocodeEnd.update()
                    }
                }
            }

            // 2. Tìm tọa độ điểm đến (End)
            GeocodeModel {
                id: geocodeEnd;
                plugin: osmPlugin;
                autoUpdate: false;
                onLocationsChanged: {
                    if (count > 0) {
                        // Tìm thấy điểm đến -> Thêm vào lộ trình
                        routeQuery.addWaypoint(get(0).coordinate);
                        // Bắt đầu tính toán đường đi nối 2 điểm
                        routeModel.update()
                    }
                }
            }

            // 3. Model tính toán đường đi (Route)
            RouteModel {
                id: routeModel
                plugin: osmPlugin;
                query: RouteQuery { id: routeQuery }
                autoUpdate: false
                onStatusChanged: {
                    if (status == RouteModel.Ready) {
                        // Khi tính xong đường đi:
                        var route = get(0)
                        iviHMI.routePath = route.path // Lưu đường đi vào biến để xe chạy
                        iviHMI.routeSegments = route.segments // Lưu các đoạn rẽ để chỉ đường
                        mapIVI.visibleRegion = route.bounds // Zoom bản đồ vừa khít đường đi
                        btnSimulate.enabled = true // Cho phép bấm nút "Chạy xe"

                        var dist = (route.distance/1000).toFixed(1)
                        instructionText.text = iviHMI.isEnglish ? "Route found: " + dist + " km" : "Đã tìm thấy đường: " + dist + " km"
                    }
                }
            }

            // --- GIAO DIỆN BẢN ĐỒ ---
            Map {
                id: mapIVI
                anchors.fill: parent
                plugin: mapboxPluginIVI
                center: QtPositioning.coordinate(16.0544, 108.2022) // Tọa độ mặc định
                zoomLevel: 14

                // Vẽ đường màu xanh lên bản đồ
                MapItemView {
                    model: routeModel;
                    delegate: MapRoute {
                        route: routeData;
                        // Màu đường xanh nhạt nếu dark mode, xanh đậm nếu light mode
                        line.color: iviHMI.isDarkMode ? "#4fc3f7" : "#3b99fc";
                        line.width: 6; smooth: true
                    }
                }

                // Marker điểm đi (Cờ)
                MapQuickItem {
                    coordinate: routeQuery.waypoints.length > 0 ? routeQuery.waypoints[0] : QtPositioning.coordinate(0,0);
                    visible: routeQuery.waypoints.length > 0;
                    anchorPoint.x: sourceItem.width/2; anchorPoint.y: sourceItem.height;
                    sourceItem: Image { source: "qrc:/icon/final_location.png"; width: 40; height: 40 }
                }

                // Marker điểm đến (Cờ)
                MapQuickItem {
                    coordinate: routeQuery.waypoints.length > 1 ? routeQuery.waypoints[1] : QtPositioning.coordinate(0,0);
                    visible: routeQuery.waypoints.length > 1;
                    anchorPoint.x: sourceItem.width/2; anchorPoint.y: sourceItem.height;
                    sourceItem: Image { source: "qrc:/icon/final_location.png"; width: 40; height: 40 }
                }

                // --- XE MÔ PHỎNG (DI CHUYỂN KHI TIMER CHẠY) ---
                MapQuickItem {
                    id: navMarker
                    visible: simTimer.running
                    coordinate: mapIVI.center // Xe luôn ở giữa màn hình khi chạy
                    anchorPoint.x: carImg.width / 2;
                    anchorPoint.y: carImg.height / 2

                    // Animation mượt mà khi thay đổi tọa độ
                    Behavior on coordinate { CoordinateAnimation { duration: 150 } }

                    sourceItem: Image {
                        id: carImg;
                        source: "qrc:/icon/car-removebg-preview.png";
                        width: 60; height: 60;
                        fillMode: Image.PreserveAspectFit;
                        // Xoay hình ảnh xe theo hướng di chuyển
                        transform: Rotation {
                            origin.x: carImg.width / 2; origin.y: carImg.height / 2;
                            angle: navMarker.rotation
                        }
                    }
                    property real rotation: 0
                }
            }

            // --- THANH CHỈ DẪN ĐƯỜNG ĐI (TOP PANEL) ---
            Rectangle {
                anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; anchors.topMargin: 20
                width: Math.min(parent.width - 40, 700); height: contentRow.height + 30;
                color: iviHMI.themePanelColor; radius: 15
                // Chỉ hiện khi đang chạy xe hoặc tìm xong đường
                visible: simTimer.running || instructionText.text.includes("Đã") || instructionText.text.includes("found")

                Row {
                    id: contentRow; anchors.centerIn: parent; spacing: 15; width: parent.width - 30
                    // Icon mũi tên chỉ hướng (Rẽ trái/phải)
                    Image {
                        id: iconTurn;
                        source: "https://img.icons8.com/ios-filled/50/ffffff/compass.png";
                        width: 30; height: 30; anchors.verticalCenter: parent.verticalCenter;
                        fillMode: Image.PreserveAspectFit
                    }
                    // Text chỉ đường (Ví dụ: Rẽ trái 200m)
                    Text {
                        id: instructionText;
                        text: iviHMI.isEnglish ? "Ready to navigate" : "Sẵn sàng tìm đường";
                        color: iviHMI.themeTextColor; font.pixelSize: 18; font.bold: true;
                        width: parent.width - iconTurn.width - parent.spacing;
                        wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // --- BẢNG NHẬP LIỆU & NÚT ĐIỀU KHIỂN (BOTTOM LEFT) ---
            Rectangle {
                anchors.bottom: parent.bottom; anchors.left: parent.left;
                anchors.margins: 20; anchors.bottomMargin: 30
                width: 340; height: 230;
                color: iviHMI.themePanelColor; radius: 15;
                border.color: iviHMI.isDarkMode ? "#444" : "#e0e0e0"; border.width: 1; layer.enabled: true

                Column {
                    anchors.centerIn: parent; width: parent.width - 40; spacing: 12

                    Text {
                        text: iviHMI.isEnglish ? "🚗 Navigation Route" : "🚗 Lộ trình di chuyển";
                        font.bold: true; font.pixelSize: 16; color: iviHMI.themeTextColor
                    }

                    // Ô nhập Điểm đi
                    TextField {
                        id: txtFrom; width: parent.width;
                        placeholderText: iviHMI.isEnglish ? "From..." : "Điểm đi...";
                        text: "Sân bay Đà Nẵng";
                        font.pixelSize: 14; color: iviHMI.themeTextColor;
                        background: Rectangle {
                            color: iviHMI.themeInputBg; radius: 8;
                            border.color: txtFrom.activeFocus ? "#2196F3" : (iviHMI.isDarkMode ? "#555" : "#e0e0e0") }
                    }

                    // Ô nhập Điểm đến
                    TextField {
                        id: txtTo; width: parent.width;
                        placeholderText: iviHMI.isEnglish ? "To..." : "Điểm đến..."; text: "Cầu Rồng";
                        font.pixelSize: 14; color: iviHMI.themeTextColor;
                        background: Rectangle {
                            color: iviHMI.themeInputBg; radius: 8;
                            border.color: txtTo.activeFocus ? "#2196F3" : (iviHMI.isDarkMode ? "#555" : "#e0e0e0")
                        }
                    }

                    Row {
                        width: parent.width; spacing: 10

                        // --- NÚT TÌM ĐƯỜNG (FIND ROUTE) ---
                        Button {
                            text: iviHMI.isEnglish ? "Find Route" : "Tìm đường";
                            width: (parent.width - 10) / 2; height: 40;
                            background: Rectangle { color: parent.down ? "#1976D2" : "#2196F3"; radius: 8 }
                            contentItem: Text { text: parent.text; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }

                            onClicked: {
                                // Reset trạng thái cũ
                                simTimer.running = false;
                                routeQuery.clearWaypoints();
                                routeModel.reset();
                                // Bắt đầu chuỗi tìm kiếm từ điểm đi
                                geocodeStart.query = txtFrom.text;
                                geocodeStart.update();
                                btnSimulate.enabled = false
                            }
                        }

                        // --- NÚT CHẠY MÔ PHỎNG (START SIMULATION) ---
                        Button {
                            id: btnSimulate;
                            text: simTimer.running ? (iviHMI.isEnglish ? "Stop" : "Dừng lại") : (iviHMI.isEnglish ? "Start" : "Chạy xe");
                            width: (parent.width - 10) / 2; height: 40; enabled: false;
                            background: Rectangle { color: !parent.enabled ? "#cccccc" : (parent.down ? "#388E3C" : "#4CAF50"); radius: 8 }
                            contentItem: Text { text: parent.text; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                            onClicked: {
                                if (simTimer.running) { simTimer.stop() }
                                else {
                                    // Bắt đầu chạy: Reset bước về 0, Zoom gần vào xe
                                    iviHMI.currentStep = 0; mapIVI.zoomLevel = 16.5; mapIVI.tilt = 60; simTimer.start()
                                }
                            }
                        }
                    }
                }
            }

            // --- TIMER ĐIỀU KHIỂN XE CHẠY ---
            Timer {
                id: simTimer; interval: 150; repeat: true // Chạy mỗi 150ms
                onTriggered: {
                    // Nếu chạy hết đường -> Dừng lại
                    if (iviHMI.currentStep >= iviHMI.routePath.length - 1) {
                        stop();
                        instructionText.text = iviHMI.isEnglish ? "Arrived!" : "Đã đến nơi!";
                        return
                    }
                    // Lấy tọa độ hiện tại và tiếp theo
                    var currentCoord = iviHMI.routePath[iviHMI.currentStep];
                    var nextCoord = iviHMI.routePath[iviHMI.currentStep + 1]

                    // Di chuyển xe và map
                    navMarker.coordinate = currentCoord;
                    mapIVI.center = currentCoord;
                    // Xoay xe theo hướng đi
                    navMarker.rotation = currentCoord.azimuthTo(nextCoord)

                    // Cập nhật chỉ dẫn (Rẽ trái/phải)
                    mapView.updateInstruction(currentCoord)
                    iviHMI.currentStep++
                }
            }

            // --- HÀM XỬ LÝ CHỈ DẪN ĐƯỜNG (DỊCH THUẬT & UPDATE ICON) ---
            function updateInstruction(currentPos) {
                // Duyệt qua các đoạn đường (segments)
                for (var i = 0; i < iviHMI.routeSegments.length; i++) {
                    var segment = iviHMI.routeSegments[i];
                    var maneuver = segment.maneuver
                    if (!maneuver.valid) continue;

                    // Tính khoảng cách từ xe đến chỗ rẽ
                    var dist = currentPos.distanceTo(maneuver.position)

                    // Nếu còn < 40m thì hiện thông báo
                    if (dist < 40) {
                        var rawText = maneuver.instructionText
                        // Dịch sang tiếng Việt nếu cần
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

                        // Đổi icon mũi tên dựa vào text
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

        // --- LAYER INTRO GIF (MỞ ĐẦU) ---
        Rectangle {
            id: introLayer
            anchors.fill: parent
            color: "black"
            z: 9999 // Đảm bảo luôn nằm trên cùng
            visible: false // Chỉ hiện khi switch màn hình được bật

            AnimatedImage {
                id: gifPlayer
                source: "https://i.pinimg.com/originals/46/1b/c3/461bc3941474e17e43c4bc0c2e4c3af5.gif"
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                playing: introLayer.visible // Chỉ play khi hiện

                // Khi chạy xong frame cuối thì kích hoạt timer tắt
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
                onTriggered: introLayer.visible = false // Ẩn màn hình intro
            }

            MouseArea {
                anchors.fill: parent
                onClicked: introLayer.visible = false // Cho phép click để bỏ qua
            }

            Text {
                text: iviHMI.isEnglish ? "Tap to skip >>" : "Chạm để bỏ qua >>"
                color: "white"
                anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 20
                font.pixelSize: 14; opacity: 0.7
            }
        }
    }
}
