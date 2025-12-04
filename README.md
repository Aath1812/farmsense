# 🚜 FarmSense: Smart Crop Management Assistant

**FarmSense** is a comprehensive mobile application designed to assist farmers in managing their crop cycles, tracking yields, and staying updated with real-time weather conditions. Built with **Flutter** and **Riverpod**, it combines efficient local data management with modern UI design.

> **Student Name:** Atharva Vinod Babhulgaonkar  
> **Roll No:** PSTE155  
> **Year & Section:** 2nd Year, Sem-3A  
> **Project Type:** OJT Project (Mobile App Development)

---

## 📱 App Overview

FarmSense solves the problem of manual record-keeping for farmers by providing a digital logbook. It allows users to:
1.  **Track Crops:** Log sowing dates, growth status, and harvest yields.
2.  **Monitor Weather:** Get live weather updates to plan farming activities.
3.  **Analyze Trends:** Visualize yield performance through interactive charts.

---

## ✨ Key Features

### 1. 🌾 Crop Management (CRUD)
* **Add Logs:** Easily record new crops with details like Crop Type, Sowing Date, and Notes.
* **Track Status:** Update status tags (e.g., *Sown*, *Growing*, *Harvested*) with color-coded chips.
* **Edit/Delete:** Modify records or remove error entries instantly.
* **Offline Support:** All data is saved locally using **Hive**, ensuring the app works without internet.

### 2. 🌦️ Real-Time Weather
* Fetches live weather data (Temperature, Condition, Humidity) using the **OpenWeatherMap API**.
* **Dynamic UI:** The Weather Card changes color gradients based on the condition (e.g., Orange for Sunny, Blue for Rain).
* **Error Handling:** Gracefully falls back to mock data if the API limit is reached or internet is unavailable.

### 3. 📊 Analytics & Visuals
* **Yield Analysis:** Visualizes total production output using **Bar Charts**.
* **Crop Distribution:** Displays the ratio of different crops using **Pie Charts**.
* **Summary Stats:** automatically calculates "Total Yield" and "Best Performing Crop".

### 4. 👤 User Profile
* Fully editable profile section (Name, Bio, Contact Info).
* State management handles updates instantly across the app.

---

## 🛠️ Tech Stack

* **Framework:** Flutter (Dart)
* **State Management:** Flutter Riverpod 2.x
* **Local Database:** Hive (NoSQL)
* **Networking:** HTTP Package
* **Charts:** fl_chart
* **Navigation:** Material 3 NavigationBar & Animations
* **Design:** Material 3 (Custom Light & Dark Themes)

---

## 🚀 Installation & Setup

Follow these steps to run the project locally:

### Prerequisites
* Flutter SDK installed (v3.0+)
* VS Code or Android Studio
* An Android Emulator or Physical Device

### Steps
1.  **Unzip the project** (or clone the repository).
2.  Open the terminal in the project folder.
3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Configure API Key (Optional):**
    * Open `lib/repositories/weather_repository.dart`.
    * Replace the `_apiKey` string with your own OpenWeatherMap Key if needed.
5.  **Run the App:**
    ```bash
    flutter run
    ```

---

## 📂 Project Structure

```text
lib/
├── core/                  # App-wide constants (Theme, etc.)
├── models/                # Data models (CropLog, WeatherModel)
├── repositories/          # Data fetching logic (Hive, API)
├── viewmodels/            # State Management (Riverpod Providers)
├── views/
│   ├── screens/           # Full page screens (Home, Add, Analytics)
│   └── widgets/           # Reusable widgets (WeatherCard, Skeleton)
└── main.dart              # Entry point