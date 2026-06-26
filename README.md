# TaskFlow 🗂️

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State-BLoC-8B00FF?logo=bloc&logoColor=white)
![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white)
![Hive](https://img.shields.io/badge/Storage-Hive-FF7043?logo=hive&logoColor=white)

> **TaskFlow** is a production-quality Task Manager app for iOS and Android, built with **Clean Architecture**, **BLoC state management**, **Supabase backend**, **Hive offline caching**, and **GoRouter navigation**.

---

## 🏗️ Tech Stack

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^8.1.5 | BLoC state management |
| `bloc` | ^8.1.4 | Core BLoC library |
| `equatable` | ^2.0.5 | Value equality for states/events |
| `go_router` | ^13.2.1 | Declarative navigation with guards |
| `supabase_flutter` | ^2.3.0 | Real backend Auth, REST API (PostgREST), and JWT management |
| `hive` + `hive_flutter` | ^2.2.3 | Offline-first local caching + theme preferences |
| `get_it` + `injectable` | ^7.7.0 / ^2.4.2 | Dependency injection |
| `google_fonts` | ^6.2.1 | Inter typography |
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
║  → RemoteDatasource (Supabase Client)    ║
║  → LocalDatasource (Hive)                ║
║  Maps Model → Entity (toEntity())        ║
╚══════════════════════════════════════════╝
```

---

## 🗄️ Hive Storage (Offline Caching)

| Box | Key | Value |
|---|---|---|
| `projects_box` | `<projectId>` | `ProjectModel` |
| `tasks_box` | `<projectId>_<taskId>` | `TaskModel` |
| `settings_box` | `theme_mode` | `'light'` or `'dark'` |

> Note: JWT token and active session storage are automatically managed by `supabase_flutter` via `flutter_secure_storage`. No tokens are stored in Hive.

---

## 🌐 Supabase Integration

Using the auto-generated REST API and secure Row Level Security (RLS) policies:

| Feature | Endpoint / SDK Call |
|---|---|
| Register | `auth.signUp(email, password, data)` |
| Login | `auth.signInWithPassword(email, password)` |
| Logout | `auth.signOut()` |
| Projects | `.from('projects').select('*, tasks(*)')` |
| Tasks | `.from('tasks').select()` |

---

## 📁 Project Structure

```
lib/
├── main.dart              # Entry point & SDK init
├── app.dart               # Root widget + BLoC providers
├── core/                  # Shared infrastructure
│   ├── constants/         # Colors, typography, spacing, strings
│   ├── di/                # GetIt/Injectable setup
│   ├── errors/            # AppException + Failure sealed classes
│   ├── network/           # Supabase config
│   ├── responsive/        # ResponsiveLayout, ScreenUtils
│   ├── router/            # GoRouter + auth guard
│   ├── storage/           # Hive storage wrapper
│   └── widgets/           # Reusable UI components
└── features/
    ├── auth/              # Login, Register (data/domain/presentation)
    ├── projects/          # Projects (data/domain/presentation)
    ├── tasks/             # Tasks (data/domain/presentation)
    ├── profile/           # Profile + ThemeBloc
    └── shell/             # Bottom nav shell
```
