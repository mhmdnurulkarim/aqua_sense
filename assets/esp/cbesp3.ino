#include <SoftwareSerial.h>

SoftwareSerial Data(16, 17);

#include <Arduino.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <TimeLib.h>

// Insert your network credentials
#define WIFI_SSID "wifi.com"
#define WIFI_PASSWORD "50001jam"

// Insert Firebase project API Key
#define API_KEY "AIzaSyArADf57SHliMuSiU7mf1ILITMf2pyBa6k"
#define FIREBASE_PROJECT_ID "tugasakhir-c7b7b"

// Insert RTDB URL and define the RTDB URL
#define USER_EMAIL "esp32@esp.com"
#define USER_PASSWORD "taini123"

// Server to get real date and time
#define NTP_SERVER "time.nist.gov"
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, NTP_SERVER);

#define UPDATE_INTERVAL 60000 // Delay between data updates in milliseconds (1 minute)
#define UPLOAD_INTERVAL 300000 // Delay between data uploads in milliseconds (5 minute)

// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long prevUpdateMillis = 0;
unsigned long prevUploadMillis = 0;
unsigned long prevReadInterval = 0;
unsigned long readDataInterval = 1000;

bool signupOK = false;

String getTanggalWaktu() {
    timeClient.update();
    unsigned long rawTime = timeClient.getEpochTime();
    time_t t = rawTime + (7 * 3600); // Adjust for your time zone

    int jam = hour(t);
    String jamStr = jam < 10 ? "0" + String(jam) : String(jam);

    int menit = minute(t);
    String menitStr = menit < 10 ? "0" + String(menit) : String(menit);

    int detik = second(t);
    String detikStr = detik < 10 ? "0" + String(detik) : String(detik);

    int tgl = day(t);
    String tglStr = tgl < 10 ? "0" + String(tgl) : String(tgl);

    int bln = month(t);
    String blnStr = bln < 10 ? "0" + String(bln) : String(bln);

    int thn = year(t);
    String thnStr = String(thn);

    String tanggal = tglStr + "/" + blnStr + "/" + thnStr;
    String waktu = jamStr + ":" + menitStr + ":" + detikStr;

    return tanggal + " " + waktu;
}

String getNamaHari(int day, int month, int year) {
    tmElements_t tm;
    tm.Day = day;
    tm.Month = month;
    tm.Year = CalendarYrToTm(year);
    tm.Hour = 0;
    tm.Minute = 0;
    tm.Second = 0;
    time_t t = makeTime(tm);
    switch (weekday(t)) {
        case 1:
            return "minggu";
        case 2:
            return "senin";
        case 3:
            return "selasa";
        case 4:
            return "rabu";
        case 5:
            return "kamis";
        case 6:
            return "jumat";
        case 7:
            return "sabtu";
        default:
            return "";
    }
}

void uploadData(FirebaseData &fbdo, float pHValue, float DO) {
    if (WiFi.status() == WL_CONNECTED && Firebase.ready()) {
        String tanggalWaktu = getTanggalWaktu();
        FirebaseJson data;
        int day = tanggalWaktu.substring(0, 2).toInt();
        int month = tanggalWaktu.substring(3, 5).toInt();
        int year = tanggalWaktu.substring(6, 10).toInt();
        String namaHari = getNamaHari(day, month, year);

        String documentPath =
                "history/" + tanggalWaktu.substring(6, 10) + "-" + tanggalWaktu.substring(3, 5) +
                "-" + tanggalWaktu.substring(0, 2) + "/" + namaHari + "/" +
                tanggalWaktu.substring(11, 19);
        data.set("fields/Tanggal/stringValue", tanggalWaktu.substring(0, 10));
        data.set("fields/Jam/stringValue", tanggalWaktu.substring(11));
        data.set("fields/Hari/stringValue", namaHari);
        data.set("fields/pH/doubleValue", pHValue);
        data.set("fields/DO/doubleValue", DO);
        if (Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(),
                                              data.raw())) {
            Serial.print("ok\n%s\n\n");
            Serial.println(fbdo.payload());
        } else {
            Serial.println("Gagal mengirim data ke Firestore");
            Serial.println(fbdo.errorReason());
        }
    }
}

String values[3];

void setup() {
    Serial.begin(9600); // Inisialisasi komunikasi serial
    Data.begin(9600); // Inisialisasi UART2 dengan pin GPIO16 (RX) dan GPIO17 (TX)
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    // Assign the API key (required)
    config.api_key = API_KEY; // Mengatur API key Firebase
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;
    config.token_status_callback = tokenStatusCallback; // Assign the callback function for the long running token generation task

    fbdo.setResponseSize(8192);  // Meningkatkan ukuran buffer respons
    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
    timeClient.begin();
}

void loop() {
    unsigned long currentTime = millis();
    if (currentTime - prevReadInterval >= readDataInterval) {
        prevReadInterval = currentTime;
        String data_Data = "";

        if (Data.available() > 0) {
            String data_Data = Data.readStringUntil('\n'); // Baca data dari serial
            // Serial.println(data_Data);
            int lastIndex = -1;
            for (int i = 0; i < 3; i++) {
                int separatorIndex = data_Data.indexOf('#', lastIndex + 1);
                if (separatorIndex != -1) {
                    values[i] = data_Data.substring(lastIndex + 1, separatorIndex);
                    // Serial.println(data_Data.substring(lastIndex + 1, separatorIndex));
                    lastIndex = separatorIndex;
                }
            }
        }

        float voltage = values[0].toFloat();
        float pH = values[1].toFloat();
        float DO = values[2].toFloat();

        Serial.println(voltage);
        Serial.println(pH);
        Serial.println(DO);

        // Pengiriman data ke monitoring
        if (currentTime - prevUpdateMillis >= UPDATE_INTERVAL) {
            updateData(fbdo, pH, DO);
            prevUpdateMillis = currentTime;
        }

        // Pengiriman data ke histori
        if (currentTime - prevUploadMillis >= UPLOAD_INTERVAL) {
            uploadData(fbdo, pH, DO);
            prevUploadMillis = currentTime;
        }
    }
}
