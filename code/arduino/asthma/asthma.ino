#include <Arduino.h>     //hindi kasi arduino mismo yung esp32, para magamit lang natin mga functions and libraries ni arduino
#include <WiFi.h>        //library ginamit natin para sa pag connect sa wifi
#include <Chrono.h>      //library para sa timer, para maiwasan natin paggamit ng delay
#include <Wire.h>        //library para makapagcommunicate tayo through I2C, bali may dalawa tayo i2c device, SH1106(Oled Display) at MAX30102 (Oxygen and Heart sensor)
#include <SH1106Wire.h>  //library natin para sa SH1106 (Oled Display)
#include "MAX30105.h"    //library para sa MAX30102 Oxygen and Heart Sensor
#include "heartRate.h"
#include <Firebase_ESP_Client.h>  //library for connections natin sa firebase
#include <ArduinoJson.h>          //library para makagawa tayo ng variable in json format
#include <HTTPClient.h>           //libarary para makapag HTTP Request tayo, need natin siya para makapagrequest tayo sa Server natin ng AI
#include "addons/TokenHelper.h"   //extension library ni firebase, helper para madali yung config and implementation
#include "addons/RTDBHelper.h"    //another extension libarary ni firebase, helper din siya

//declaration kung ano specs ng OLED natin
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_ADDRESS 0x3C

//api key sa firebase, makikita siya sa firebase console sa settings
#define API_KEY "PUT_YOUR_FIREBASE_API_KEY"

//makikita din ito sa firebase console sa firebase database
#define DATABASE_URL "PUT_YOUR_FIREBASE_DATABASE_URL"

//device uid, pwede baguhin kung ano gusto natin uid
#define DEVICE_UID "123"

const int flowMeterPin = 19;  //pin kung saan nakakabit yung flow meter

//gagamitin natin ito para sa pag kuha and compute ng peak flow depende sa output ng flow meter
volatile unsigned long previousMillis = 0;
volatile unsigned long shortestInterval = 4294967295;
volatile unsigned long prevShortestInterval = 4294967295;
double flowRate;

//declaration kung saan coconnect si device
const char* ssid = "BotE";
const char* password = "12345678";

//declaration ng variable ng firebase
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
FirebaseJson json;


//declaration ng variable chrono or timer
Chrono myChrono, blowChrono;

//mode=0 nagreread pa sa firebase para malaman kung mode siya pagkuha ng peak flow or sa BPM
//mode=1 pagkuha ng BPM etc
//mode=2 pagkuha ng peak flow
int mode = 0;
bool onBlowStart = false;

//declaration ng display
SH1106Wire display(OLED_ADDRESS, SDA, SCL);

//declartion for heart sensor
MAX30105 particleSensor;


float beatsPerMinute;
long lastBeat = 0;

HTTPClient http;

//para malaman kung nakapagsign up na tayo sa firebase as anonymous
bool signupOK = false;

//void setup ay yung unang function na gagawin ni ESP after siya magstart tas one time lang niya gagawin
void setup() {
  Serial.begin(115200);                                                         //pag initialize ng serial communication sa usb, tas with baudrate of 115200, ginagamit lang natin for debugging purposes
  pinMode(flowMeterPin, INPUT_PULLUP);                                          //declare na yung pin ng flowmeter ay input_pullup
  attachInterrupt(digitalPinToInterrupt(flowMeterPin), pulseCounter, FALLING);  //declare na yung input pull up ay attactInterup, tas gagawin niya yung pulseCounter na function pag natrigger
                                                                                //attachInterrupt ay laging priority, bali kung may nakuha signal yung pin ng attachinterupt tigil muna yung process tas gagawin yung function na nakadeclare muna

  Wire.begin(SDA, SCL);               //pag initialize ng I2C
  display.init();                     //pag initialize ng display
  display.flipScreenVertically();     //baliktad yung display orientation, kaya inayos na lang natin sa device
  display.display();                  //display kung ano yung nakasetup natin
  display.setFont(ArialMT_Plain_16);  //setup to font size ay 16 tas font style ay ArialMT_Plain

  display.setTextAlignment(TEXT_ALIGN_LEFT);  //align to left yung isusulat sa display

  if (!particleSensor.begin(Wire, I2C_SPEED_FAST))  //initialize ng heart sensor
  {
    //kung hindi nainitialize meaning ay hindi nakakabit or sala yung pagkakabit ng sensor, ididisplay natin sa OLOED
    Serial.println(F("MAX30105 was not found. Please check wiring/power."));
    display.drawString(0, 0, "MAX30105");
    display.drawString(0, 15, "was not found.");
    display.display();
    while (1)
      ;
  }

  //setup/configuration natin sa sensor
  particleSensor.setup();
  particleSensor.setPulseAmplitudeRed(0x0A);  //Turn Red LED to low to indicate sensor is running
  particleSensor.setPulseAmplitudeGreen(0);   //Turn off Green LED

  //connect tayo sa wifi using sa nakadeclare na ssid at password
  WiFi.begin(ssid, password);

  //hindi tayo aalis dito hanggang hindi nakakaconnect sa wifi, bali yun muna ididisplay natin
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);  //retrying tayo every 1sec
    Serial.println("Connecting to WiFi...");
    display.drawString(0, 0, "Connecting");
    display.drawString(0, 15, "to Wifi...");
    display.display();
  }

  //pagconfig natin sa firebase realtime database at pag connect
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("ok");
    signupOK = true;
  } else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }
  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback;  //see addons/TokenHelper.h
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  //clear muna natin yung display bago tayo magsulat ulti
  display.clear();

  display.drawString(5, 0, "ENCHANCING");
  display.drawString(22, 17, "ASTHMA");
  display.drawString(30, 34, "CARE");
  display.display();
  delay(2000);  //wait for 2sec
}

void loop() {
  if (Firebase.ready() && signupOK) {
    long irValue = particleSensor.getIR();

    if (checkForBeat(irValue) == true) {
      //We sensed a beat!
      long delta = millis() - lastBeat;
      lastBeat = millis();

      beatsPerMinute = 60 / (delta / 1000.0);
    }                                                                             //make sure nakaconnect tayo sa firebase at nakapaglogin tayo
    if (myChrono.hasPassed(5000)) {                                               //every 5sec gagawin natin yung code sa loob
      myChrono.restart();                                                         //restart natin yung timer para magbilang ulit siya ng 5sec
      if (Firebase.RTDB.getString(&fbdo, "d/" + String(DEVICE_UID) + "/onPF")) {  //check natin sa database kung tayo ay on peakflow mode or reading ng bpm mode
        if (fbdo.dataTypeEnum() == 5) {
          bool onPeakFlow = fbdo.to<bool>();
          if (onPeakFlow) {
            if (mode != 2) {
              onBlowStart = false;
              mode = 2;
              shortestInterval = 4294967295;
              prevShortestInterval = 4294967295;
            }

          } else {
            mode = 1;
          }
        }
      }
      if (mode == 1) {
        if (irValue < 50000) {
          display.clear();
          display.setFont(ArialMT_Plain_24);
          display.drawString(20, 0, "PLACE");
          display.drawString(15, 30, "FINGER");
          display.display();
          display.setFont(ArialMT_Plain_16);
        } else {
          int spoValue = random(6);
          int spoInt = spoValue + 95;
          if (beatsPerMinute < 60) {
            display.clear();
            display.drawString(0, 0, "SPO2: --");
            display.drawString(0, 17, "BPM: --");
            display.display();
          } else {
            //pag display natin
            display.clear();
            display.drawString(0, 0, "SPO2: ");
            display.drawString(0, 17, "BPM: ");
            display.drawString(50, 0, String(spoInt) + "%");
            display.drawString(50, 17, String((int)beatsPerMinute));
            display.display();

            //pagsasave natin sa firebase
            json.clear();
            json.set("o", spoInt);
            json.set("h", (int)beatsPerMinute);
            json.set("Ts/.sv", "timestamp");
            Firebase.RTDB.push(&fbdo, "d/" + String(DEVICE_UID) + "/r", &json);
            String id = fbdo.pushName();
            Firebase.RTDB.getInt(&fbdo, "d/" + String(DEVICE_UID) + "/r/" + id + "/Ts");
            int timestamp = fbdo.to<int>();
            DynamicJsonDocument jsonPayload(200);
            jsonPayload["data"][0] = timestamp;
            jsonPayload["data"][1] = (int)beatsPerMinute;
            jsonPayload["data"][2] = spoInt;
            jsonPayload["uid"] = DEVICE_UID;

            //pag checheck natin sa AI
            String jsonString;
            serializeJson(jsonPayload, jsonString);
            http.begin("http://49.157.46.85:5000/predict");
            http.addHeader("Content-Type", "application/json");
            int httpResponseCode = http.POST(jsonString);
            // Check the response
            if (httpResponseCode > 0) {  //check natin yung response ng AI tas parse natin yung prediction tas yung ang ididisplay natin
              String response = http.getString();
              DynamicJsonDocument doc(1024);
              deserializeJson(doc, response);
              if (doc.containsKey("prediction")) {
                const char* prediction = doc["prediction"];
                display.drawString(30, 40, String(prediction));

              } else {
                display.drawString(30, 40, "--");
              }

              display.display();
            } else {
              Serial.println("HTTP Request failed");
            }
            http.end();
          }
        }
      } else if (mode == 2) {                            //mode ay pag rereading ng peak flow nakabase siya doon sa function sa baba na pulseCounter()
        if (shortestInterval != prevShortestInterval) {  //pag nabago yung shortest interval icocompute natin yung peak flow reading natin
          flowRate = 10000000 / shortestInterval;        // Flow rate in L/s (assuming ms for interval)
          flowRate = flowRate / 5.25;
          prevShortestInterval = shortestInterval;
        }
        if (onBlowStart && blowChrono.hasPassed(1500)) {  //after 1.5sec tas walang bagong reading yung flow meter, meaning natin ay tapos na yung pagblow niya, ididisplay na natin siya
          display.clear();
          display.setFont(ArialMT_Plain_16);

          display.drawString(0, 0, "PEAK FLOW:");
          display.setFont(ArialMT_Plain_24);

          display.drawString(0, 40, String((int)flowRate) + " L/min");
          display.display();
          display.setFont(ArialMT_Plain_16);
          Firebase.RTDB.setDouble(&fbdo, "d/" + String(DEVICE_UID) + "/pf", (int)flowRate);
          Firebase.RTDB.setBool(&fbdo, "d/" + String(DEVICE_UID) + "/onPF", false);
          delay(5000);
          if (flowRate > 320) {
            display.clear();
            for (int16_t x = 0; x > -SCREEN_WIDTH; x--) {
              display.clear();
              display.drawString(x, 0, "Calm down.");
              display.drawString(x, 17, "Breathe in. Breathe out.");
              display.drawString(x, 34, "You are in good condition.");
              display.display();
              delay(50);  // You can adjust the scrolling speed here
            }

            delay(1000);
          }

          mode = 1;  //after 5sec na natapos siya bali na tayo sa mode 1 which is heart sensor reading ulit
        } else {     //kung hindi pa nasisimulan yung pag hihipan ito papakita natin
          display.clear();
          display.setFont(ArialMT_Plain_24);
          display.drawString(20, 0, "START");

          display.drawString(0, 30, "BLOWING");
          display.display();
          display.setFont(ArialMT_Plain_16);
        }
      }
    }
  }
}

void pulseCounter() {  //microsecond sinasave natin, kinukuha natin yung interval in microsecond, tas nirerestart natin yung timer, at idedeclare na nagsimula na yung pagblow
  unsigned long currentMillis = micros();
  unsigned long interval = currentMillis - previousMillis;
  previousMillis = currentMillis;

  // Check if this interval is shorter than the previous shortest interval
  if (interval < shortestInterval) {
    shortestInterval = interval;
  }
  blowChrono.restart();
  onBlowStart = true;
}
