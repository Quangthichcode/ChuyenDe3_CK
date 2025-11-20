import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
// import QtMultimedia 5.15 // Không cần nữa vì không dùng Video Player

Window {
    id: root
    width: 1200
    height: 700
    visible: true
    title: qsTr("IVI HMI - MAP")

    // --- CÁC BIẾN TRẠNG THÁI (SETTINGS) ---
    property bool isDarkMode: false
    property bool isEnglish: false

    // --- BIẾN TOÀN CỤC DỮ LIỆU XE ---
    property var routePath: []
    property var routeSegments: []
    property int currentStep: 0

    // --- THEME ---
    property color themeBgColor: isDarkMode ? "#1a1a1a" : "#ffffff"
    property color themeTextColor: isDarkMode ? "#ffffff" : "#333333"
    property color themePanelColor: isDarkMode ? "#cc000000" : "#f0ffffff"
    property color themeInputBg: isDarkMode ? "#333333" : "#f5f7f9"

    // --- SIDEBAR TRÁI ---
    Rectangle {
        id: leftSidebar
        width: 200
        height: parent.height
        color: root.themeBgColor
        anchors.left: parent.left

        Rectangle {
            width: 1; height: parent.height
            anchors.right: parent.right
            color: root.isDarkMode ? "#444" : "#ddd"
        }

        Column {
            anchors.centerIn: parent
            width: parent.width - 40
            spacing: 30

            Text {
                text: root.isEnglish ? "SETTINGS" : "CÀI ĐẶT"
                font.bold: true
                font.pixelSize: 20
                color: root.themeTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text: root.isEnglish ? "Dark Mode" : "Chế độ tối"
                    color: root.themeTextColor
                    font.pixelSize: 14
                }
                Switch {
                    checked: root.isDarkMode
                    onCheckedChanged: root.isDarkMode = checked
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Column {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text: root.isEnglish ? "Language (Eng)" : "Ngôn ngữ (Anh)"
                    color: root.themeTextColor
                    font.pixelSize: 14
                }
                Switch {
                    checked: root.isEnglish
                    onCheckedChanged: root.isEnglish = checked
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    // --- PHẦN BẢN ĐỒ ---
    Item {
        id : mapView
        width: parent.width - leftSidebar.width
        height: parent.height
        anchors.right: parent.right

        Plugin {
            id: mapboxPlugin
            name: "mapboxgl"
            PluginParameter { name: "mapboxgl.access_token"; value: "pk.eyJ1Ijoibmd1eWVuaHVuZzQ4OCIsImEiOiJjbWk3MDNmeHAwNXJwMnFvZnVzdGo1dTdsIn0.MMBnkjFbPkXremQIgVIF3Q" }
            PluginParameter {
                name: "mapboxgl.mapping.additional_style_urls";
                value: root.isDarkMode ? "mapbox://styles/mapbox/dark-v10" : "mapbox://styles/mapbox/streets-v11"
            }
        }

        Plugin { id: osmPlugin; name: "osm" }

        GeocodeModel {
            id: geocodeStart
            plugin: osmPlugin
            autoUpdate: false
            onLocationsChanged: {
                if (count > 0) {
                    routeQuery.addWaypoint(get(0).coordinate)
                    geocodeEnd.query = txtTo.text
                    geocodeEnd.update()
                }
            }
        }

        GeocodeModel {
            id: geocodeEnd
            plugin: osmPlugin
            autoUpdate: false
            onLocationsChanged: {
                if (count > 0) {
                    routeQuery.addWaypoint(get(0).coordinate)
                    routeModel.update()
                }
            }
        }

        RouteModel {
            id: routeModel
            plugin: osmPlugin
            query: RouteQuery { id: routeQuery }
            autoUpdate: false

            onStatusChanged: {
                if (status == RouteModel.Ready) {
                    var route = get(0)
                    root.routePath = route.path
                    root.routeSegments = route.segments
                    map.visibleRegion = route.bounds
                    btnSimulate.enabled = true

                    var dist = (route.distance/1000).toFixed(1)
                    instructionText.text = root.isEnglish
                        ? "Route found: " + dist + " km"
                        : "Đã tìm thấy đường: " + dist + " km"
                }
            }
        }

        Map {
            id: map
            anchors.fill: parent
            plugin: mapboxPlugin
            center: QtPositioning.coordinate(16.0544, 108.2022)
            zoomLevel: 14

            MapItemView {
                model: routeModel
                delegate: MapRoute {
                    route: routeData
                    line.color: root.isDarkMode ? "#4fc3f7" : "#3b99fc"
                    line.width: 6
                    smooth: true
                }
            }

            MapQuickItem {
                coordinate: routeQuery.waypoints.length > 0 ? routeQuery.waypoints[0] : QtPositioning.coordinate(0,0)
                visible: routeQuery.waypoints.length > 0
                anchorPoint.x: sourceItem.width/2; anchorPoint.y: sourceItem.height
                sourceItem: Image { source: "https://img.icons8.com/color/48/marker.png"; width: 40; height: 40 }
            }
            MapQuickItem {
                coordinate: routeQuery.waypoints.length > 1 ? routeQuery.waypoints[1] : QtPositioning.coordinate(0,0)
                visible: routeQuery.waypoints.length > 1
                anchorPoint.x: sourceItem.width/2; anchorPoint.y: sourceItem.height
                sourceItem: Image { source: "https://img.icons8.com/fluency/48/finish-flag.png"; width: 40; height: 40 }
            }

            MapQuickItem {
                id: navMarker
                visible: simTimer.running
                coordinate: map.center
                anchorPoint.x: carImg.width / 2
                anchorPoint.y: carImg.height / 2

                Behavior on coordinate { CoordinateAnimation { duration: 150 } }

                sourceItem: Image {
                    id: carImg
                    source: "qrc:/icon/car-removebg-preview.png"
                    width: 60; height: 60
                    fillMode: Image.PreserveAspectFit
                    transform: Rotation {
                        origin.x: carImg.width / 2
                        origin.y: carImg.height / 2
                        angle: navMarker.rotation
                    }
                }
                property real rotation: 0
            }
        }

        // Thanh chỉ dẫn
        Rectangle {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            width: Math.min(parent.width - 40, 700)
            height: contentRow.height + 30
            color: root.themePanelColor
            radius: 15
            visible: simTimer.running || instructionText.text.includes("Đã") || instructionText.text.includes("found")

            Row {
                id: contentRow
                anchors.centerIn: parent
                spacing: 15
                width: parent.width - 30

                Image {
                    id: iconTurn
                    source: "https://img.icons8.com/ios-filled/50/ffffff/compass.png"
                    width: 30; height: 30
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: instructionText
                    text: root.isEnglish ? "Ready to navigate" : "Sẵn sàng tìm đường"
                    color: root.themeTextColor
                    font.pixelSize: 18
                    font.bold: true
                    width: parent.width - iconTurn.width - parent.spacing
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Bảng điều khiển
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 20
            anchors.bottomMargin: 30
            width: 340
            height: 230
            color: root.themePanelColor
            radius: 15
            border.color: root.isDarkMode ? "#444" : "#e0e0e0"
            border.width: 1
            layer.enabled: true

            Column {
                anchors.centerIn: parent
                width: parent.width - 40
                spacing: 12

                Text {
                    text: root.isEnglish ? "🚗 Navigation Route" : "🚗 Lộ trình di chuyển"
                    font.bold: true
                    font.pixelSize: 16
                    color: root.themeTextColor
                }

                TextField {
                    id: txtFrom
                    width: parent.width
                    placeholderText: root.isEnglish ? "From..." : "Điểm đi..."
                    text: "Sân bay Đà Nẵng"
                    font.pixelSize: 14
                    color: root.themeTextColor
                    background: Rectangle {
                        color: root.themeInputBg
                        radius: 8
                        border.color: txtFrom.activeFocus ? "#2196F3" : (root.isDarkMode ? "#555" : "#e0e0e0")
                    }
                }

                TextField {
                    id: txtTo
                    width: parent.width
                    placeholderText: root.isEnglish ? "To..." : "Điểm đến..."
                    text: "Cầu Rồng"
                    font.pixelSize: 14
                    color: root.themeTextColor
                    background: Rectangle {
                        color: root.themeInputBg
                        radius: 8
                        border.color: txtTo.activeFocus ? "#2196F3" : (root.isDarkMode ? "#555" : "#e0e0e0")
                    }
                }

                Row {
                    width: parent.width
                    spacing: 10

                    Button {
                        text: root.isEnglish ? "Find Route" : "Tìm đường"
                        width: (parent.width - 10) / 2
                        height: 40
                        background: Rectangle {
                            color: parent.down ? "#1976D2" : "#2196F3"
                            radius: 8
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            simTimer.running = false
                            routeQuery.clearWaypoints()
                            routeModel.reset()
                            geocodeStart.query = txtFrom.text
                            geocodeStart.update()
                            btnSimulate.enabled = false
                        }
                    }

                    Button {
                        id: btnSimulate
                        text: simTimer.running ? (root.isEnglish ? "Stop" : "Dừng lại") : (root.isEnglish ? "Start" : "Chạy xe")
                        width: (parent.width - 10) / 2
                        height: 40
                        enabled: false
                        background: Rectangle {
                            color: !parent.enabled ? "#cccccc" : (parent.down ? "#388E3C" : "#4CAF50")
                            radius: 8
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            if (simTimer.running) {
                                simTimer.stop()
                            } else {
                                root.currentStep = 0
                                map.zoomLevel = 16.5
                                map.tilt = 60
                                simTimer.start()
                            }
                        }
                    }
                }
            }
        }

        // --- TIMER LOGIC ---
        Timer {
            id: simTimer
            interval: 150
            repeat: true
            onTriggered: {
                if (root.currentStep >= root.routePath.length - 1) {
                    stop()
                    instructionText.text = root.isEnglish ? "Arrived!" : "Đã đến nơi!"
                    return
                }

                var currentCoord = root.routePath[root.currentStep]
                var nextCoord = root.routePath[root.currentStep + 1]

                navMarker.coordinate = currentCoord
                map.center = currentCoord
                navMarker.rotation = currentCoord.azimuthTo(nextCoord)

                mapView.updateInstruction(currentCoord)

                root.currentStep++
            }
        }

        // Hàm xử lý logic hiển thị và dịch thuật
        function updateInstruction(currentPos) {
            for (var i = 0; i < root.routeSegments.length; i++) {
                var segment = root.routeSegments[i]
                var maneuver = segment.maneuver

                // Nếu không có chỉ dẫn hợp lệ thì bỏ qua
                if (!maneuver.valid) continue

                // Tính khoảng cách từ xe đến điểm rẽ
                var dist = currentPos.distanceTo(maneuver.position)

                // Nếu khoảng cách < 40 mét thì hiện thông báo
                if (dist < 40) {
                    var rawText = maneuver.instructionText

                    // --- PHẦN DỊCH THUẬT THỦ CÔNG ---
                    if (!root.isEnglish) { // Nếu đang là Tiếng Việt
                        rawText = rawText.replace("Turn left onto", "Rẽ trái vào")
                        rawText = rawText.replace("Turn right onto", "Rẽ phải vào")
                        rawText = rawText.replace("Turn left", "Rẽ trái")
                        rawText = rawText.replace("Turn right", "Rẽ phải")
                        rawText = rawText.replace("Make a U-turn", "Quay đầu xe")
                        rawText = rawText.replace("Head", "Đi về hướng")
                        rawText = rawText.replace("Continue", "Tiếp tục đi")
                        rawText = rawText.replace("Arrive at", "Đến điểm")
                        rawText = rawText.replace("Enter the roundabout", "Vào vòng xoay")
                        rawText = rawText.replace("Take the", "Đi theo lối ra")
                        rawText = rawText.replace("exit", "")

                        rawText = rawText.replace("north", "Bắc")
                        rawText = rawText.replace("south", "Nam")
                        rawText = rawText.replace("east", "Đông")
                        rawText = rawText.replace("west", "Tây")
                    }

                    instructionText.text = rawText

                    // --- ĐỔI ICON MŨI TÊN ---
                    var textLower = maneuver.instructionText.toLowerCase()
                    if (textLower.includes("left"))
                        iconTurn.source = "https://img.icons8.com/ios-filled/50/ffffff/left.png"
                    else if (textLower.includes("right"))
                        iconTurn.source = "https://img.icons8.com/ios-filled/50/ffffff/right.png"
                    else if (textLower.includes("u-turn"))
                        iconTurn.source = "https://img.icons8.com/ios-filled/50/ffffff/u-turn.png"
                    else
                        iconTurn.source = "https://img.icons8.com/ios-filled/50/ffffff/straight.png"

                    break
                }
            }
        }
    }

    // ============================================================
    // PHẦN INTRO GIF MỚI THÊM VÀO ĐÂY
    // ============================================================
    Rectangle {
        id: introLayer
        anchors.fill: parent
        color: "black" // Nền đen che map bên dưới
        z: 9999 // Luôn nằm trên cùng
        visible: true // Mặc định hiện

        AnimatedImage {
            id: gifPlayer
            // Dán link GIF bạn đã cung cấp vào đây
            source: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZTQzNzVsZmd0MDlldWd4bTVwZzVtNGs4czZpbzFmaGEwdGdoMnVveCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/WsdtV7MsWiEUzgJjJ1/giphy.gif"

            anchors.fill: parent
            fillMode: Image.PreserveAspectFit // Giữ tỉ lệ, có thể đổi thành Fill để tràn màn hình

            // Khi ảnh GIF chạy hết một chu kỳ (về frame 0)
            onCurrentFrameChanged: {
                if (currentFrame === gifPlayer.frameCount - 1) { // Đảm bảo là frame cuối cùng
                    // Thêm delay 500ms để nó không tắt quá nhanh
                    delayTimer.start()
                }
            }
        }

        // Timer để tạo độ trễ khi tắt GIF
        Timer {
            id: delayTimer
            interval: 500 // 0.5 giây
            repeat : false
            onTriggered: introLayer.visible = false // Ẩn màn hình intro
        }

        // Nút "Bỏ qua" (Skip) - Tùy chọn
        MouseArea {
            anchors.fill: parent
            onClicked: introLayer.visible = false // Bấm vào màn hình là tắt intro
        }

        Text {
            text: root.isEnglish ? "Tap to skip >>" : "Chạm để bỏ qua >>"
            color: "white"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 20
            font.pixelSize: 14
            opacity: 0.7
        }
    }
}
