# 📱 LawyerUp Android

LawyerUp Android is the official mobile application for **LawyerUp**, a modern legal-tech platform that connects users with verified lawyers. This Flutter app supports seamless interactions like booking appointments, reading legal news, uploading documents, and chatting with lawyers in real-time.

---

## 🚀 Features

### For Users:
- 🔐 **Authentication** – Signup, Login with role (User or Lawyer)
- 📰 **News Feed** – Legal news with like, dislike, and comment functionality
- 👩‍⚖️ **Lawyer Listing** – View lawyers, see ratings, and read profiles
- 📅 **Book Appointments** – Select time slots, set mode (online/offline), and send a request
- 💬 **Chat System** – In-feature chat after approval from the lawyer
- 📄 **PDF Library** – View and download legal documents
- ⚙️ **Settings** – Edit profile, manage notifications, upgrade plan, delete account
- 📲 **Shake to Report** – Shake phone to report issues or bugs instantly

### For Lawyers:
- 📝 **Join as a Lawyer** – Fill out form with details, documents, and available schedule
- 👤 **Lawyer Dashboard** – View bookings, chat with users, manage availability
- 🗂️ **Profile Management** – Show qualifications, experience, contact, and services


---

## 🧱 Architecture

This app follows **Clean Architecture**, organized into 3 main layers:

```
lib/
├── data/           # Models, API services, Hive adapters
├── domain/         # Entities, repositories, use cases
└── presentation/   # UI, Cubits, widgets, pages
```

Each feature (e.g., News, Booking, Lawyer, Auth) is modular and scalable.

---

## 🛠️ Tech Stack

| Tech        | Description                          |
|-------------|--------------------------------------|
| Flutter     | UI Framework                         |
| Dart        | Programming Language                 |
| Hive        | Local NoSQL storage                  |
| Dio         | Networking and API calls             |
| BLoC        | Business Logic Component for state   |
| MongoDB     | Backend database (already set up)    |
| Multer      | File upload handler in backend       |
| Socket.io (Planned) | Real-time messaging/chat     |

---

## ✅ Getting Started

### 1. Prerequisites

- Flutter SDK (>=3.x)
- Dart (>=2.18.0)
- Android Studio / VS Code
- Emulator or physical device
- Backend API running (URL configured)

### 2. Clone the Project

```bash
git clone https://github.com/your-username/lawyerup_android.git
cd lawyerup_android
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

> ⚠️ Make sure the backend API is live and accessible. API URLs are managed in `lib/app/constants/api_endpoints.dart`.

---

## 📂 Project Structure

```
lib/
├── app/
│   ├── constants/         # API URLs and global settings
│   └── utils/             # Shared helpers/utilities
├── features/
│   ├── auth/
│   ├── news/
│   ├── lawyer/
│   ├── booking/
│   ├── chat/
│   └── pdf_library/
└── main.dart
```

---

## 🔐 Authentication

- Role-based login: `User`, `Lawyer`
- Uses Hive for persistent login and token storage
- Validations for confirm password and input fields

---

## 🧪 Testing

Includes:
- ✅ Unit Tests (Logic, Validators)
- ✅ Widget Tests (UI components)
- ✅ BLoC Tests (Cubit/Bloc logic)

Run tests:

```bash
flutter test
```

---

## 🌐 Environment Configuration

All API endpoints are defined in:

```dart
// lib/app/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'https://your-server.com';
  static const String baseHost = '$baseUrl/uploads';

  static const String login = '$baseUrl/api/auth/login';
  static const String register = '$baseUrl/api/auth/signup';
  // Add more as needed
}
```
---

## 🤝 Contributing

We welcome contributions!  
Feel free to open issues, submit PRs, and suggest new features.

### How to Contribute

1. Fork the repo
2. Create a new branch (`git checkout -b feature-name`)
3. Make your changes
4. Commit (`git commit -am 'Add feature'`)
5. Push (`git push origin feature-name`)
6. Open a Pull Request

---

## 📄 License

Copyright 2025 LawyerUp Nepal

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

## 👨‍💻 Developed By

**Sachin Khatri**  
[LawyerUp Nepal](https://lawyerupnepal.com)

---

## 📞 Contact

For support or business inquiries:  
📧 Email: support@lawyerupnepal.com  
🌐 Website: [lawyerupnepal.com](https://lawyerupnepal.com)
=======
For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference..

