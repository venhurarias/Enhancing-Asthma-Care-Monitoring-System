# Enhancing Asthma Care Monitoring System

This project is an IoT-based healthcare system designed to assist in monitoring asthma conditions using real-time physiological data. It integrates an ESP32 device, cloud database (Firebase), a web platform, and an AI-powered prediction system to provide intelligent health insights.

The system measures **heart rate (BPM)**, **oxygen saturation (SpO2)**, and **peak flow rate**, then sends the data to a server where an AI model analyzes the condition and returns predictions. A web application is also included for real-time monitoring, communication, and patient management.

---

## Project Overview

The system consists of four main components:

1. **ESP32 Device (Embedded System)**
2. **Firebase Realtime Database (Cloud Storage)**
3. **AI Server (Flask + Machine Learning)**
4. **Web Application (Monitoring + Communication Platform)**

It is designed to:
- monitor vital signs in real time  
- assist asthma patients in tracking breathing conditions  
- provide intelligent predictions using AI  
- enable doctor-patient interaction through web platform  
- store and visualize health data remotely  

---

## Features

### 🫀 Real-Time Health Monitoring
- Measures:
  - Heart Rate (BPM)
  - Oxygen Saturation (SpO2)
- Uses **MAX30102 sensor**

---

### 🌬️ Peak Flow Measurement
- Uses a **flow meter sensor**
- Calculates airflow using interrupt-based pulse detection
- Displays peak flow in **L/min**

---

### 📡 Cloud Integration (Firebase)
- Stores real-time readings:
  - BPM
  - SpO2
  - Peak flow
- Uses device UID for structured data storage
- Enables synchronization across device, AI, and web

---

### 🤖 AI-Based Prediction
- Sends data to a Flask API server
- Uses **Decision Tree Classifier**
- Evaluates condition based on:
  - time (hour, minute)
  - BPM
  - SpO2
- Returns prediction shown on device and web

---

### 📺 OLED Display Interface
- Displays:
  - BPM and SpO2 readings
  - Peak flow results
  - AI prediction feedback
- Uses SH1106 OLED (I2C)

---

### 🌐 WiFi Connectivity
- Connects ESP32 to internet
- Enables real-time synchronization with Firebase and AI server

---

## 🌍 Web Application Features

A full web system is integrated into this project to support monitoring and healthcare interaction.

### 📊 Real-Time Patient Dashboard
- Displays:
  - Live BPM, SpO2, and Peak Flow readings
  - Historical data and trends
- Updates automatically via Firebase

---

### 📞 Video Call System
- Enables real-time doctor-patient consultation  
- Uses token-based communication (Agora integration)  
- Secure session handling  

---

### 💬 Chat System
- Real-time messaging between patient and doctor  
- Useful for follow-ups and monitoring  

---

### 📅 Appointment System
- Schedule consultations between patients and doctors  
- Manage appointment history and availability  

---

### 🧾 Patient Data Management
- Stores patient readings and history  
- Allows doctors to review condition over time  
- Integrated with AI prediction results  

---

## System Workflow

### 1. Device Startup
- Connects to WiFi  
- Initializes sensors and OLED display  
- Authenticates with Firebase  

---

### 2. Monitoring Mode (Normal Mode)
- Reads:
  - Heart rate
  - SpO2
- Displays values on screen  
- Sends data to Firebase  

---

### 3. AI Prediction
- Sends collected data to Flask API:  POST /predict
- Server processes data using trained model  
- Returns prediction (health status)  
- Result is displayed on OLED and web dashboard  

---

### 4. Peak Flow Mode
- Triggered via Firebase flag (`onPF`)  
- User performs blowing action  
- Flow meter detects airflow pulses  
- Calculates peak flow rate  
- Displays result and stores in Firebase  

---

### 5. Web Monitoring & Interaction
- Doctors monitor patient data in real time  
- Patients can:
- view their health data  
- chat with doctors  
- join video consultations  
- schedule appointments  

---

## Hardware Components

- ESP32  
- MAX30102 (Heart Rate + SpO2 Sensor)  
- Flow Meter Sensor  
- SH1106 OLED Display (I2C)  
- WiFi Network  

---

## Wiring Connections

### 🔌 ESP32 Pin Configuration

| Component            | ESP32 Pin        |
|---------------------|-----------------|
| Flow Meter Signal   | GPIO 19         |
| MAX30102 (SDA)      | GPIO 21 (SDA)   |
| MAX30102 (SCL)      | GPIO 22 (SCL)   |
| OLED (SDA)          | GPIO 21 (SDA)   |
| OLED (SCL)          | GPIO 22 (SCL)   |
| MAX30102 VCC        | 3.3V            |
| MAX30102 GND        | GND             |
| OLED VCC            | 3.3V or 5V      |
| OLED GND            | GND             |

---

### 📟 I2C Devices (Shared Bus)

Both the OLED and MAX30102 share the same I2C lines:

- SDA → GPIO 21  
- SCL → GPIO 22  

---

### 🌬️ Flow Meter

- Signal → GPIO 19  
- VCC → 5V or 3.3V  
- GND → GND  

---

## Software Components

### Embedded (ESP32)
- Arduino Framework  
- Firebase ESP Client  
- HTTPClient  
- Chrono  

---

### AI Server (Flask)
- Flask API  
- Scikit-learn (Decision Tree Classifier)  
- Firebase Sync  
- Joblib  

---

### Web Application
- Real-time dashboard (Firebase-based)  
- Video call integration (Agora)  
- Chat system  
- Appointment scheduling  

---

## API Endpoints

### `/predict`
- Accepts:
- timestamp
- BPM
- SpO2  
- Returns:
- prediction result  

---

### `/token`
- Generates token for video call sessions  

---

## Notes

- Uses interrupt-based flow measurement for accuracy  
- AI model dynamically trains from Firebase data  
- Supports:
- Vital signs monitoring  
- Peak flow measurement  
- Web platform enhances usability and remote care  

---

## Limitations

- Requires stable internet connection  
- AI accuracy depends on dataset quality  
- No offline prediction capability  
- SpO2 may be simulated in current version  

---

## Summary

This project demonstrates a complete **IoT healthcare ecosystem** that combines:

- embedded systems (ESP32)  
- biomedical sensing  
- cloud database (Firebase)  
- AI prediction (Machine Learning)  
- web-based telehealth platform  

It is suitable for:
- asthma monitoring  
- remote patient care  
- telemedicine systems  
- smart healthcare solutions  
