# TaskFlow 🗂️

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State-BLoC-8B00FF?logo=bloc&logoColor=white)
![Hive](https://img.shields.io/badge/Storage-Hive-FF7043?logo=hive&logoColor=white)

> **TaskFlow** is a production-quality Task Manager app for iOS and Android, built with **Clean Architecture**, **BLoC state management**, **Hive offline storage**, and **GoRouter navigation**.

---

## 📸 Screenshots

> Add screenshots here

---

## 🏗️ Tech Stack

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^8.1.5 | BLoC state management |
| `bloc` | ^8.1.4 | Core BLoC library |
| `equatable` | ^2.0.5 | Value equality for states/events |
| `go_router` | ^13.2.1 | Declarative navigation with guards |
| `dio` | ^5.4.3 | HTTP client with interceptors |
| `hive` + `hive_flutter` | ^2.2.3 | Offline-first local persistence |
| `get_it` + `injectable` | ^7.7.0 / ^2.4.2 | Dependency injection |
| `google_fonts` | ^6.2.1 | Poppins + Inter typography |
| `dartz` | ^0.10.1 | Functional `Either<Failure, T>` |
| `freezed_annotation` | ^2.4.1 | Code generation for sealed classes |
| `json_annotation` | ^4.9.0 | JSON serialization |

---

## 🚀 Getting Started

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code (Hive adapters, JSON, Injectable wiring)
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run

# 4. (Optional) Build APK
flutter build apk --release
```

> ⚠️ **Step 2 is mandatory** before `flutter run`. Without it the app will not compile.

---

## 🧱 Architecture

```
╔══════════════════════════════════════════╗
║  PRESENTATION LAYER                      ║
║  Screen → BlocBuilder/Consumer           ║
║  BlocProvider → BLoC                     ║
║  BLoC fires events → emits states        ║
╠══════════════════════════════════════════╣
║  DOMAIN LAYER                            ║
║  BLoC calls UseCase (injected)           ║
║  UseCase calls Repository (abstract)     ║
║  Returns Either<Failure, Entity>         ║
╠══════════════════════════════════════════╣
║  DATA LAYER                              ║
║  RepositoryImpl (injected as interface)  ║
║  → RemoteDatasource (Dio + JSONPlaceholder) ║
║  → LocalDatasource (Hive)               ║
║  Maps Model → Entity (toEntity())        ║
╚══════════════════════════════════════════╝
```

---

## 🗄️ Hive Storage

| Box | Key | Value |
|---|---|---|
| `auth_box` | `jwt_token` | JWT string |
| `auth_box` | `current_user` | `UserModel` |
| `projects_box` | `<projectId>` | `ProjectModel` |
| `tasks_box` | `<projectId>_<taskId>` | `TaskModel` |
| `settings_box` | `theme_mode` | `'light'` or `'dark'` |

---

## 🌐 API

Uses **JSONPlaceholder** (`https://jsonplaceholder.typicode.com`) as mock backend:

| Feature | Endpoint |
|---|---|
| Login/Register | Simulated locally (fake JWT) |
| Get Projects | `GET /albums` |
| Get Tasks | `GET /photos?albumId=:id` |
| Update Task | `PATCH /photos/:id` |
| Create Task | `POST /photos` |
| Get User | `GET /users/1` |

> **Known limitation**: JSONPlaceholder does not persist PATCH/POST server-side. Task status updates are reflected locally via optimistic updates only.

---

## 📁 Project Structure

```
lib/
├── main.dart              # Entry point
├── app.dart               # Root widget + BLoC providers
├── core/                  # Shared infrastructure
│   ├── constants/         # Colors, typography, spacing, strings
│   ├── di/                # GetIt/Injectable setup
│   ├── errors/            # AppException + Failure sealed classes
│   ├── network/           # Dio client + interceptors
│   ├── responsive/        # ResponsiveLayout, ScreenUtils
│   ├── router/            # GoRouter + auth guard
│   ├── storage/           # Hive storage wrapper
│   └── widgets/           # Reusable UI components
└── features/
    ├── auth/              # Login, Register (data/domain/presentation)
    ├── projects/          # Projects list (data/domain/presentation)
    ├── tasks/             # Task detail (data/domain/presentation)
    ├── profile/           # Profile + ThemeBloc
    └── shell/             # Bottom nav shell
```

---

## 🤖 Continuation Point

If this project was built by an AI agent and you need to continue with a new session, see `CONTINUATION.md` for the exact state of progress.
