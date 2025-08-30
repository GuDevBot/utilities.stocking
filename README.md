# Stocking - Inventory Management App

![App Thumbnail](https://i.imgur.com/rLzG9L9.png)

A simple, offline-first mobile application built with Flutter to help users manage and organize product inventory. This app provides a clean and intuitive interface for tracking what you have, where it is, and how much of it is in stock.

## Overview & User Flow

The primary goal of Stocking is to offer a straightforward solution for small-scale inventory control, replacing notebooks or complex spreadsheets. The user can seamlessly manage their items through a simple and efficient workflow:

1.  **View Products:** The main screen displays a clear, organized list of all registered products.
2.  **Add New Items:** Users can tap a floating action button to navigate to a registration form and add new products with details like name, quantity, location, and who stored it.
3.  **Find Items Quickly:** The main list can be dynamically **filtered** by name, location, user, or date. It can also be **sorted** by multiple criteria (e.g., newest first, name A-Z).
4.  **Manage Stock:** Users can easily **delete** items from the inventory with a confirmation step to prevent accidental removal.

The app uses intelligent **autocomplete suggestions** in both the registration and filter forms, making data entry faster and more consistent.

## Features

- **Full CRUD Operations:** Create, Read, and Delete products from the inventory.
- **Advanced Filtering:** Search and filter the product list by multiple criteria simultaneously.
- **Dynamic Sorting:** Sort the list by date (newest/oldest), product name (A-Z/Z-A), location (A-Z/Z-A), and user (A-Z/Z-A).
- **Autocomplete Suggestions:** Get real-time suggestions based on existing data when filling out forms to speed up data entry.
- **Offline First:** All data is stored locally on the device, making the app fully functional without an internet connection.
- **Intuitive UI:** A clean and user-friendly interface designed for efficiency.

## Technical Details

This project was built with a focus on a clean, scalable, and maintainable codebase.

### Architecture: MVVM (Model-View-ViewModel)

The application is structured using the MVVM pattern to ensure a clear separation of concerns:

- **Model:** Represents the data and business logic. It consists of the `Product` data class and the `HiveService` which handles all database interactions.
- **View:** The UI layer of the application (e.g., `HomeView`, `RegisterProductView`). It is responsible for displaying data and capturing user input, but contains no business logic.
- **ViewModel:** Acts as the bridge between the Model and the View. It holds the application's state and business logic (e.g., `HomeViewModel`, `RegisterProductViewModel`). The View observes the ViewModel for changes and updates itself reactively.

### State Management: Provider

We use the `provider` package for state management. The View listens to changes in the ViewModel via `ChangeNotifier` and `Consumer` widgets, ensuring the UI is always in sync with the application state in an efficient manner.

### Local Database: Hive

For local data persistence, the project uses **Hive**, a lightweight and fast NoSQL database written in pure Dart. It's ideal for mobile applications, providing excellent performance and an easy-to-use API for storing Dart objects. The `build_runner` and `hive_generator` packages are used to automatically generate the necessary `TypeAdapters` for data serialization.

### Project Structure

The project follows a feature-first directory structure to keep the code organized and scalable:

lib/
|-- core/
|   |-- services/         # Reusable services (e.g., HiveService)
|-- features/
|   |-- product/
|   |   |-- enums/        # Shared enums (e.g., SortOption)
|   |   |-- models/       # Data models (e.g., Product)
|   |   |-- views/        # UI Widgets/Screens
|   |   |-- viewmodels/   # State and business logic
|-- main.dart             # App entry point

## Getting Started

To run this project locally, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd stocking
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the build_runner (for Hive model generation):**
    ```bash
    flutter packages pub run build_runner build --delete-conflicting-outputs
    ```
5.  **Run the application:**
    ```bash
    flutter run
    ```