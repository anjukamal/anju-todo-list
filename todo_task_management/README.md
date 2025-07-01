# Todo Task Management App

A cross-platform Todo Task Management Mobile App built for the Katomaran Hackathon. The app allows users to log in via Google and manage tasks with full CRUD operations, offline support, and a clean, responsive UI.

## Features
- Google Sign-In authentication
- Create, Read, Update, Delete (CRUD) tasks
- Task fields: title, description, due date, status, priority
- Offline support using SQLite
- Smooth animations for list interactions using the `animations` package
- Pull-to-refresh and swipe-to-delete functionality
- Responsive UI for Android and iOS
- Provider for state management

## Tech Stack
- **Frontend**: Flutter (Dart)
- **Authentication**: Firebase Authentication (Google Sign-In)
- **Cloud Storage**: Firestore
- **Offline Storage**: SQLite
- **State Management**: provider
- **Dependencies**: firebase_core (^3.14.0), firebase_auth (^5.6.0), google_sign_in (^6.3.0), cloud_firestore (^5.6.9), animations, uuid, intl, sqflite, path_provider

## Architecture
![Architecture Diagram](assets/images/architecture_diagram.png)

The app follows a layered architecture:
- **Presentation Layer**: Screens (LoginScreen, TaskListScreen, TaskFormScreen) and Widgets (TaskListItem)
- **Business Logic Layer**: Providers (AuthProvider, TaskProvider) for state management
- **Data Layer**: TaskProvider handles Firebase and SQLite interactions
- **External Services**: Firebase Authentication, Firestore, Google Sign-In
- **Offline Storage**: SQLite for local persistence

## Setup
1. Clone the repository:
   ```bash
   git clone <repository-url>

This project is a part of a hackathon run by https://www.katomaran.com