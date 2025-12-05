// ESP32 Cluster Controller - XI NHAN NHẤP NHÁY
// Logic debounce + Blinker cho xi nhan

// GPIO cho biến trở
const int SPEED_POT_PIN = 34;
const int BATTERY_POT_PIN = 35;

// GPIO cho các nút nhấn
const int BTN_HEADLIGHT = 25;
const int BTN_PARKING = 26;
const int BTN_LIGHT = 27;
const int BTN_FOG = 14;
const int BTN_TURN_LEFT = 12;
const int BTN_TURN_RIGHT = 13;
const int BTN_SEATBELT = 15;
const int BTN_WARNING_1 = 32;
const int BTN_WARNING_2 = 33;

// Trạng thái các nút
bool state_headlight = false;
bool state_parking = false;
bool state_light = false;
bool state_fog = false;
bool state_seatbelt = true;
bool state_warning_1 = false;
bool state_warning_2 = false;

// ===== XI NHAN LOGIC =====
bool turn_left_enabled = false;    // Xi nhan trái có được bật không
bool turn_right_enabled = false;   // Xi nhan phải có được bật không
bool turn_left_blink = false;      // Trạng thái nhấp nháy hiện tại (ON/OFF)
bool turn_right_blink = false;     // Trạng thái nhấp nháy hiện tại (ON/OFF)

unsigned long lastBlinkTime = 0;
const unsigned long blinkInterval = 500;  // 500ms = 0.5 giây (nhấp nháy 1 lần/giây)

// Debounce
bool lastButtonState_0 = HIGH;
bool lastButtonState_1 = HIGH;
bool lastButtonState_2 = HIGH;
bool lastButtonState_3 = HIGH;
bool lastButtonState_4 = HIGH;
bool lastButtonState_5 = HIGH;
bool lastButtonState_6 = HIGH;
bool lastButtonState_7 = HIGH;
bool lastButtonState_8 = HIGH;

bool currentButtonState_0 = HIGH;
bool currentButtonState_1 = HIGH;
bool currentButtonState_2 = HIGH;
bool currentButtonState_3 = HIGH;
bool currentButtonState_4 = HIGH;
bool currentButtonState_5 = HIGH;
bool currentButtonState_6 = HIGH;
bool currentButtonState_7 = HIGH;
bool currentButtonState_8 = HIGH;

unsigned long lastDebounceTime_0 = 0;
unsigned long lastDebounceTime_1 = 0;
unsigned long lastDebounceTime_2 = 0;
unsigned long lastDebounceTime_3 = 0;
unsigned long lastDebounceTime_4 = 0;
unsigned long lastDebounceTime_5 = 0;
unsigned long lastDebounceTime_6 = 0;
unsigned long lastDebounceTime_7 = 0;
unsigned long lastDebounceTime_8 = 0;

const unsigned long debounceDelay = 50;

float speedValue = 0;
float batteryValue = 0;

void setup() {
  Serial.begin(115200);
  
  pinMode(SPEED_POT_PIN, INPUT);
  pinMode(BATTERY_POT_PIN, INPUT);
  
  pinMode(BTN_HEADLIGHT, INPUT_PULLUP);
  pinMode(BTN_PARKING, INPUT_PULLUP);
  pinMode(BTN_LIGHT, INPUT_PULLUP);
  pinMode(BTN_FOG, INPUT_PULLUP);
  pinMode(BTN_TURN_LEFT, INPUT_PULLUP);
  pinMode(BTN_TURN_RIGHT, INPUT_PULLUP);
  pinMode(BTN_SEATBELT, INPUT_PULLUP);
  pinMode(BTN_WARNING_1, INPUT_PULLUP);
  pinMode(BTN_WARNING_2, INPUT_PULLUP);
  
  pinMode(2, OUTPUT);
  
  while(!Serial) {
    delay(10);
  }
  
  Serial.println("\n====================================");
  Serial.println("ESP32 Cluster Controller");
  Serial.println("With Turn Signal Blinker");
  Serial.println("====================================");
  Serial.println("Ready!");
  Serial.println("====================================\n");
  
  for (int i = 0; i < 3; i++) {
    digitalWrite(2, HIGH);
    delay(100);
    digitalWrite(2, LOW);
    delay(100);
  }
}

void loop() {
  // ===== ĐỌC BIẾN TRỞ =====
  speedValue = map(analogRead(SPEED_POT_PIN), 0, 4095, 0, 250);
  batteryValue = map(analogRead(BATTERY_POT_PIN), 0, 4095, 0, 100);
  
  // ===== XI NHAN NHẤP NHÁY =====
  if (millis() - lastBlinkTime >= blinkInterval) {
    lastBlinkTime = millis();
    
    // Toggle trạng thái nhấp nháy nếu xi nhan đang bật
    if (turn_left_enabled) {
      turn_left_blink = !turn_left_blink;
    } else {
      turn_left_blink = false;  // Tắt nếu không enable
    }
    
    if (turn_right_enabled) {
      turn_right_blink = !turn_right_blink;
    } else {
      turn_right_blink = false;
    }
  }
  
  // ===== ĐỌC NÚT 0: HEADLIGHT =====
  {
    int reading = digitalRead(BTN_HEADLIGHT);
    if (reading != lastButtonState_0) {
      lastDebounceTime_0 = millis();
    }
    if ((millis() - lastDebounceTime_0) > debounceDelay) {
      if (reading != currentButtonState_0) {
        currentButtonState_0 = reading;
        if (currentButtonState_0 == LOW) {
          state_headlight = !state_headlight;
          Serial.println("🔘 Headlight → " + String(state_headlight ? "ON" : "OFF"));
        }
      }
    }
    lastButtonState_0 = reading;
  }
  
  // ===== ĐỌC NÚT 1: PARKING =====
  {
    int reading = digitalRead(BTN_PARKING);
    if (reading != lastButtonState_1) {
      lastDebounceTime_1 = millis();
    }
    if ((millis() - lastDebounceTime_1) > debounceDelay) {
      if (reading != currentButtonState_1) {
        currentButtonState_1 = reading;
        if (currentButtonState_1 == LOW) {
          state_parking = !state_parking;
          Serial.println("🔘 Parking → " + String(state_parking ? "ON" : "OFF"));
        }
      }
    }
    lastButtonState_1 = reading;
  }
  
  // ===== ĐỌC NÚT 2: LIGHT =====
  {
    int reading = digitalRead(BTN_LIGHT);
    if (reading != lastButtonState_2) {
      lastDebounceTime_2 = millis();
    }
    if ((millis() - lastDebounceTime_2) > debounceDelay) {
      if (reading != currentButtonState_2) {
        currentButtonState_2 = reading;
        if (currentButtonState_2 == LOW) {
          state_light = !state_light;
          Serial.println("🔘 Light → " + String(state_light ? "ON" : "OFF"));
        }
      }
    }
    lastButtonState_2 = reading;
  }
  
  // ===== ĐỌC NÚT 3: FOG =====
  {
    int reading = digitalRead(BTN_FOG);
    if (reading != lastButtonState_3) {
      lastDebounceTime_3 = millis();
    }
    if ((millis() - lastDebounceTime_3) > debounceDelay) {
      if (reading != currentButtonState_3) {
        currentButtonState_3 = reading;
        if (currentButtonState_3 == LOW) {
          state_fog = !state_fog;
          Serial.println("🔘 Fog → " + String(state_fog ? "ON" : "OFF"));
        }
      }
    }
    lastButtonState_3 = reading;
  }
  
  // ===== ĐỌC NÚT 4: TURN LEFT (XI NHAN TRÁI) =====
  {
    int reading = digitalRead(BTN_TURN_LEFT);
    if (reading != lastButtonState_4) {
      lastDebounceTime_4 = millis();
    }
    if ((millis() - lastDebounceTime_4) > debounceDelay) {
      if (reading != currentButtonState_4) {
        currentButtonState_4 = reading;
        if (currentButtonState_4 == LOW) {
          turn_left_enabled = !turn_left_enabled;
          
          // Tắt xi nhan phải khi bật trái (không thể bật cả 2)
          if (turn_left_enabled) {
            turn_right_enabled = false;
          }
          
          Serial.println("◀️ Turn LEFT → " + String(turn_left_enabled ? "BLINKING" : "OFF"));
        }
      }
    }
    lastButtonState_4 = reading;
  }
  
  // ===== ĐỌC NÚT 5: TURN RIGHT (XI NHAN PHẢI) =====
  {
    int reading = digitalRead(BTN_TURN_RIGHT);
    if (reading != lastButtonState_5) {
      lastDebounceTime_5 = millis();
    }
    if ((millis() - lastDebounceTime_5) > debounceDelay) {
      if (reading != currentButtonState_5) {
        currentButtonState_5 = reading;
        if (currentButtonState_5 == LOW) {
          turn_right_enabled = !turn_right_enabled;
          
          // Tắt xi nhan trái khi bật phải
          if (turn_right_enabled) {
            turn_left_enabled = false;
          }
          
          Serial.println("▶️ Turn RIGHT → " + String(turn_right_enabled ? "BLINKING" : "OFF"));
        }
      }
    }
    lastButtonState_5 = reading;
  }
  
  // ===== ĐỌC NÚT 6: SEATBELT =====
  {
    int reading = digitalRead(BTN_SEATBELT);
    if (reading != lastButtonState_6) {
      lastDebounceTime_6 = millis();
    }
    if ((millis() - lastDebounceTime_6) > debounceDelay) {
      if (reading != currentButtonState_6) {
        currentButtonState_6 = reading;
        if (currentButtonState_6 == LOW) {
          state_seatbelt = !state_seatbelt;
          Serial.println("🔘 Seatbelt → " + String(state_seatbelt ? "ON" : "OFF"));
        }
      }
    }
    lastButtonState_6 = reading;
  }
  
  // ===== ĐỌC NÚT 7: WARNING 1 =====
  {
    int reading = digitalRead(BTN_WARNING_1);
    if (reading != lastButtonState_7) {
      lastDebounceTime_7 = millis();
    }
    if ((millis() - lastDebounceTime_7) > debounceDelay) {
      if (reading != currentButtonState_7) {
        currentButtonState_7 = reading;
        if (currentButtonState_7 == LOW) {
          state_warning_1 = !state_warning_1;
          Serial.println("🔘 Warning 1 → " + String(state_warning_1 ? "ON" : "OFF"));
        }
      }
    }
    lastButtonState_7 = reading;
  }
  
  // ===== ĐỌC NÚT 8: WARNING 2 =====
  {
    int reading = digitalRead(BTN_WARNING_2);
    if (reading != lastButtonState_8) {
      lastDebounceTime_8 = millis();
    }
    if ((millis() - lastDebounceTime_8) > debounceDelay) {
      if (reading != currentButtonState_8) {
        currentButtonState_8 = reading;
        if (currentButtonState_8 == LOW) {
          state_warning_2 = !state_warning_2;
          Serial.println("🔘 Warning 2 → " + String(state_warning_2 ? "ON" : "OFF"));
        }
      }
    }
    lastButtonState_8 = reading;
  }
  
  // ===== GỬI DỮ LIỆU =====
  Serial.print("S");
  Serial.print((int)speedValue);
  
  Serial.print("B");
  Serial.print((int)batteryValue);
  
  Serial.print("H");
  Serial.print(state_headlight ? 1 : 0);
  
  Serial.print("P");
  Serial.print(state_parking ? 1 : 0);
  
  Serial.print("L");
  Serial.print(state_light ? 1 : 0);
  
  Serial.print("F");
  Serial.print(state_fog ? 1 : 0);
  
  // GỬI TRẠNG THÁI NHẤP NHÁY (không phải enabled)
  Serial.print("TL");
  Serial.print(turn_left_blink ? 1 : 0);
  
  Serial.print("TR");
  Serial.print(turn_right_blink ? 1 : 0);
  
  Serial.print("SB");
  Serial.print(state_seatbelt ? 1 : 0);
  
  Serial.print("W1");
  Serial.print(state_warning_1 ? 1 : 0);
  
  Serial.print("W2");
  Serial.print(state_warning_2 ? 1 : 0);
  
  Serial.println();
  
  delay(10);
}
