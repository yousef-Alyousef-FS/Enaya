# 🏥 Enaya (عناية) - Smart Medical Center System

**Enaya** is a comprehensive healthcare management solution designed to streamline the interaction between medical staff and patients. Built with a focus on efficiency, security, and scalability, the application provides tailored experiences for Doctors, Patients, and Receptionists.

---

## ✨ Key Features
- **Role-Based Access Control (RBAC):** Specialized dashboards for three distinct user roles (Doctor, Receptionist, Patient).
- **Modern Authentication:** Secure Login and Signup flows with integrated Token management and Refresh Token logic.
- **Multilingual Support:** Full support for Arabic and English with right-to-left (RTL) layout optimization.
- **Responsive Design:** A fluid UI that adapts seamlessly to various screen sizes and orientations.
- **Clean Architecture:** A robust structural foundation that ensures maintainability and high code quality.

---

## 🛠 Tech Stack & Architecture
The project follows **Clean Architecture** principles, separating the application into three main layers:
- **Domain Layer:** Contains pure business logic (Entities and UseCases).
- **Data Layer:** Handles data fetching from APIs or Local storage, implementing the Repository pattern.
- **Presentation Layer:** Manages the UI state using the **Provider** pattern and **ViewModel** approach.

### Core Technologies:
- **Navigation:** [GoRouter](https://pub.dev/packages/go_router) for declarative routing.
- **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it) for decoupled service management.
- **Networking:** [Dio](https://pub.dev/packages/dio) with advanced Interceptors for automated header injection.
- **Code Generation:** [Freezed](https://pub.dev/packages/freezed) & [JsonSerializable] for type-safe data modeling.
- **Functional Programming:** [Dartz](https://pub.dev/packages/dartz) for elegant error handling (Either type).

---

## 📁 Project Structure
```text
lib/
├── core/            # Common utils, theme, networking, and base classes.
├── features/        # Functional modules (Feature-driven).
│   ├── auth/        # Identity management and verification.
│   ├── dashboard/   # Specialized screens for each user role.
│   └── ...          # Future modules (Appointments, Records, etc.)
└── main.dart        # Application entry point and global configurations.
```

---

## 🚀 Getting Started

### Prerequisites:
- Flutter SDK (Latest Stable)
- Dart SDK

### Installation:
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/enaya.git
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Generate required files (Models/JSON):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🛡 License
This project is proprietary and confidential. Unauthorized copying of this file via any medium is strictly prohibited.

---
*Developed with ❤️ for a better healthcare experience.*
