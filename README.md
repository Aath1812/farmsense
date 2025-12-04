# 🚜 FarmSense: Smart Crop Management Assistant

**FarmSense** is a comprehensive mobile application designed to assist farmers in managing their crop cycles, tracking yields, and staying updated with real-time weather conditions. Built with **Flutter** and **Riverpod**, it features a professional, offline-first architecture for the OJT Project.

> **Status:** Code Complete & Submission Ready

---

## ✨ Key Features & Enhancements

### 1. 🌾 Crop Management & Logging (CRUD)
* **Status Tracking:** Add, Edit, and Delete crop logs, tracking the status (Sown, Growing, Harvested) and yield amount.
* **Hive Persistence:** All crop data is stored locally using **Hive**, ensuring full offline functionality.

### 2. 🌦️ Dynamic Weather System
* **Live API Integration:** Fetches real-time weather data (Temperature, Condition, Humidity) using the **OpenWeatherMap API**.
* **Location-Aware:** The weather system dynamically updates based on the farmer's **"Farm Location"** entered in the Profile Screen, providing personalized weather forecasting.
* **Dynamic UI:** The Weather Card's gradient visually changes color based on the current condition (e.g., Orange for Clear, Grey for Cloudy/Rain).

### 3. 📊 Farmer-Friendly Analytics
* **Yield Leaderboards:** Replaced confusing charts with a clear **Crop Ranking** system using visual bars to track performance.
* **Actionable Metrics (Contextual Ranking):**
    * **Biggest Harvests (kg):** Ranks crops by total weight produced.
    * **Active Fields / Most Planted:** Ranks crops by activity count for planning.

### 4. ⚙️ Professional Architecture & UX
* **Modular Navigation:** Uses the Material 3 `NavigationBar` and smooth page transitions for a modern feel.
* **Refactored Profile:** The User Profile logic (saving Age, Land Size, Soil Type) is correctly managed by a dedicated **Riverpod StateNotifier**, ensuring clean separation of business logic from the UI.
* **Robust Error Handling:** API errors (like 404 Not Found) and null values are handled gracefully, preventing crashes.

---

## 🛠️ Tech Stack

* **Framework:** Flutter (Dart)
* **State Management:** Flutter Riverpod 2.x
* **Local Database:** Hive (NoSQL)
* **Networking:** HTTP Package
* **Charts:** `fl_chart` (Used for initial analysis & removed to replace with custom linear gauge list)
* **Design:** Material 3 (Custom Light & Dark Themes)

---

## 🚀 Installation & Setup

Follow these steps to run the project locally:

### Prerequisites
* Flutter SDK installed (v3.0+)
* VS Code or Android Studio

### Steps
1.  **Unzip the project** (or clone the repository).
2.  Open the terminal in the project folder.
3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Configure API Key:**
    * Open `lib/repositories/weather_repository.dart`.
    * Ensure the `_apiKey` variable contains your 32-character OpenWeatherMap Key.
5.  **Run the App:**
    ```bash
    flutter run
    ```

---

## 📸 Screenshots (Placeholder)

| Home Screen (Dynamic Weather) | Crop Logs List | Analytics (Crop Ranking) | Profile Screen (Research Fields) |
| :---: | :---: | :---: | :---: |
|  |  |  |  |
