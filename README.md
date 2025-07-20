# ✈️ Itinera AI — Smart Trip Planner (Flutter + AI)

Welcome to the official repository for **Itinera AI**, an AI-powered mobile app built with Flutter.
This project — developed under the folder name `smart_trip_planner` — lets users generate customized, day-by-day travel itineraries by simply typing natural language prompts like:

> “5 days in Manali with friends next month, budget trip.”

Itinera AI uses OpenAI/Gemini for intelligent planning, Firebase for backend services, and Riverpod for scalable state management.

---

## 🔧 Setup & Installation

To run this project locally:

### 🛠 Requirements

- Flutter SDK (>= 3.24.4)
- Dart SDK
- Firebase CLI
- FlutterFire CLI

### ⚙️ Installation Steps   
# Install Flutter
brew install --cask flutter

# Install Firebase CLI
brew install firebase-cli

# Activate FlutterFire CLI
dart pub global activate flutterfire_cli

#### Architecture Diagram
  A[User Input] --> B[Prompt holder]
  B --> C[AI Agent (OpenAI/Gemini)]
  C --> D[Itinerary Generator]
  D --> E[Formatted Response]
  E --> F[UI Renderer (Flutter)]
  F --> G[Firestore (Save)]

# smart_trip_planner

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
