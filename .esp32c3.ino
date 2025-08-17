#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
// #include <max6675.h>

#define SERVICE_UUID        "12345678-1234-5678-1234-56789abcdef0"
#define CHARACTERISTIC_UUID "abcd1234-5678-1234-5678-abcdef123456"

const int kontakPin = 10;
const int beepPin = 20;
const int staterPin = 3;
String codeVer = "6e7a6c";
String codeKontakOn = "6e316c";
String codeKontakOff = "0a";
String codeBeep = "1b";
String codeStaterOn = "1c";
String codeStaterOff = "0c";
String codeSuhuOn = "1d";
String codeSuhuOff = "0d";

// #define pinCLK 2
// #define pinCS 0
// #define pinDO 4

bool suhu = false;

BLEServer* pServer;
BLECharacteristic *pCharacteristic;
// MAX6675 thermocouple(pinCLK, pinCS, pinDO);

void con() {
    digitalWrite(beepPin, HIGH);
    delay(400);
    digitalWrite(beepPin, LOW);
    delay(400);
    digitalWrite(beepPin, HIGH);
    delay(400);
    digitalWrite(beepPin, LOW);
};

void dc() {
    digitalWrite(kontakPin, LOW);
    suhu = false;
    digitalWrite(beepPin, HIGH);
    delay(800);
    digitalWrite(beepPin, LOW);
};

void alert() {
    digitalWrite(beepPin, HIGH);
    delay(10000);
    digitalWrite(beepPin, LOW);
};

// void readTemp() {
//     float cel = thermocouple.readCelsius();
//     Serial.println(cel);
//     char suhu[6];
//     dtostrf(cel, 4, 2, suhu);
//     pCharacteristic->setValue((uint8_t*)suhu, strlen(suhu));
//     pCharacteristic->notify();
// }

class MyServerCallbacks : public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
    }
    void onDisconnect(BLEServer* pServer) {
      dc();
      Serial.println("Perangkat terputus");
      BLEDevice::startAdvertising(); // Mulai ulang iklan jika terputus
    }
};

class MyCallbacks : public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
        String data = pCharacteristic->getValue();
        if (data.length() > 0) {
            Serial.println(data.c_str());
            if (data == codeVer) {
                con();
                Serial.println("Perangkat terverivikasi");
            } else if (data == codeKontakOn) {
                digitalWrite(kontakPin, HIGH);
                Serial.println("Kontak ON");
            } else if (data == codeKontakOff) {
                digitalWrite(kontakPin, LOW);
                Serial.println("Kontak OFF");
            } else if (data == codeBeep) {
                con();
                Serial.println("Beep");
            } else if (data == codeStaterOn) {
                digitalWrite(staterPin, HIGH);
                Serial.println("Stater ON");
            } else if (data == codeStaterOff) {
                digitalWrite(staterPin, LOW);
                Serial.println("Stater OFF");
            } else if (data == codeSuhuOn) {
                suhu = true;
            } else if (data == codeSuhuOff) {
                suhu = false;
            } else {
                Serial.println("Anomali!");
                alert();
                pServer->disconnect(pServer->getConnId());
            }
        }
    }
};

void setup() {
    Serial.begin(9600);
    pinMode(kontakPin, OUTPUT);
    pinMode(beepPin, OUTPUT);
    digitalWrite(kontakPin, LOW);
    digitalWrite(beepPin, LOW);

    BLEDevice::init("JillProject");
    pServer = BLEDevice::createServer();
    pServer->setCallbacks(new MyServerCallbacks());

    BLEService *pService = pServer->createService(SERVICE_UUID);

    pCharacteristic = pService->createCharacteristic(
                        CHARACTERISTIC_UUID,
                        BLECharacteristic::PROPERTY_WRITE |
                        BLECharacteristic::PROPERTY_READ
                      );
    pCharacteristic->setCallbacks(new MyCallbacks());

    pService->start();
    BLEDevice::startAdvertising();
    Serial.println("ESP Siap...");
}

void loop() {
    // if (suhu == true) {
    //     readTEmp();
    //     delay(5000);
    // }
}

