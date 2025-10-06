# ARCHITECTURE.md

## **Flutter Application Architecture**

This document outlines the **inquebrantable rules** for structuring and developing Flutter applications. It enforces **Clean Architecture**, modular design, and best practices to ensure scalability, maintainability, and testability. All projects must adhere to this architecture, and deviations are not allowed.

---

### **1. Project Structure**

The project follows a **modular directory structure** based on **Clean Architecture**. Each module (feature) is self-contained and adheres to the following layers:

```
lib/
├── core/                # Core utilities and dependency injection
├── features/            # Modular feature-based directories
│   ├── <feature_name>/  # Example: auth, profile, settings
│   │   ├── domain/      # Business logic and use cases
│   │   ├── data/        # Data layer implementation
│   │   ├── presentation/# UI and state management
│   │   └── ...
├── localization/        # Localization using Easy Localization
├── routes/              # Route management using GoRouter
└── main.dart            # Entry point of the application
```

---

### **2. Layers in Detail**

#### **Domain Layer**
- **Purpose:** Contains the business logic and abstract definitions of repositories and use cases.
- **Components:**
  - **Entities:** Plain Dart objects representing core business models.
  - **Repositories:** Abstract interfaces defining contracts for data access.
  - **Use Cases:** Classes implementing specific business logic (e.g., `GetUserUseCase`, `LoginUseCase`).

**Example Directory Structure:**
```
domain/
├── entities/
│   └── user_entity.dart
├── repositories/
│   └── user_repository.dart
└── usecases/
    └── get_user_usecase.dart
```

---

#### **Data Layer**
- **Purpose:** Implements the data access logic and provides concrete implementations of repositories.
- **Components:**
  - **Repositories Implementation (`Impl`):** Concrete classes implementing the repository interfaces.
  - **Models:** Data models used for serialization/deserialization.
  - **Data Sources:** Interfaces and implementations for local and remote data sources (e.g., API calls, database queries).
  - **Data Sources Implementation (`Impl`):** Concrete implementations of data sources.

**Example Directory Structure:**
```
data/
├── datasources/
│   ├── user_datasource.dart
│   └── user_datasource_impl.dart
├── models/
│   └── user_model.dart
├── repositories/
│   └── user_repository_impl.dart
└── ...
```

---

#### **Presentation Layer**
- **Purpose:** Handles the UI and state management.
- **Components:**
  - **Blocs/Cubits:** State management using the BLoC pattern (via `flutter_bloc` or `bloc` package).
  - **UI:**
    - **Screens:** Full-page widgets representing individual screens.
    - **Widgets:** Reusable components specific to a feature.
    - **Shared Widgets:** Globally reusable components (e.g., buttons, dialogs).
  - **State Management:** Use BLoC for complex state management and Cubit for simpler cases.

**Example Directory Structure:**
```
presentation/
├── blocs/
│   ├── user_bloc.dart
│   └── user_event.dart
├── screens/
│   └── user_profile_screen.dart
├── widgets/
│   └── custom_button.dart
└── shared_widgets/
    └── app_dialog.dart
```

---

#### **Core Layer**
- **Purpose:** Centralized utilities, configurations, and dependency injection.
- **Components:**
  - **Dependency Injection:** Use `get_it` or `injectable` for managing dependencies.
  - **Utilities:** Helper functions, constants, and extensions.
  - **Configurations:** Environment-specific configurations (e.g., API endpoints, app settings).

**Example Directory Structure:**
```
core/
├── di/
│   └── service_locator.dart
├── utils/
│   └── constants.dart
├── config/
│   └── environment_config.dart
└── ...
```

---

### **3. Localization**

- Use **Easy Localization** for managing translations.
- Store all translation files in the `localization/` directory.
- Translation files should be in JSON format and follow the naming convention `<language_code>.json` (e.g., `en.json`, `es.json`).

**Example Directory Structure:**
```
localization/
├── assets/
│   ├── translations/
│   │   ├── en.json
│   │   └── es.json
└── localization.dart
```

**Key Rules:**
- Always use `context.tr()` for accessing translations in the UI.
- Ensure translations are tested for all supported languages.

---

### **8. Technologies and Integrations**

- Authentication: **Firebase Auth**
- Cloud Storage: **Firebase Storage** (opcional, solo para imágenes/fotos seleccionadas por el usuario)
- Local Persistence: **Hive** (cajas cifradas para datos sensibles; se podrá migrar a Drift si aumentan las necesidades de consultas complejas)
- State Management: **BLoC/Cubit** (flutter_bloc)
- Routing: **GoRouter** con rutas centralizadas en `routes/`
- Dependency Injection: **get_it** con `core/di/service_locator.dart`

**Reglas clave:**
- Inicializar Firebase en `main.dart` usando `DefaultFirebaseOptions.currentPlatform`.
- Inicializar Hive en el arranque usando `Hive.initFlutter()` antes de acceder a cualquier caja.
- No exponer claves ni secretos en el repositorio.
- Las cargas a Firebase Storage deberán aplicar compresión y límites de tamaño.

---

### **9. Feature: Auth (Login/Registro)**

- Presentación: Pantallas `LoginScreen` y `RegisterScreen` en `features/auth/presentation/screens/`.
- Inputs reutilizables en `presentation/shared/widgets/` para Nombre, Correo, DNI, Teléfono y Password.
- Validadores en `core/utils/validators.dart` con TDD en `test/core/utils/validators_test.dart`.
- MVP: interacción directa con `FirebaseAuth` (createUserWithEmailAndPassword, signInWithEmailAndPassword) temporalmente; será reemplazada por `AuthRepository` del dominio y data sources (Firebase + Hive) conforme avance la implementación.

---

### **10. Testing y TDD**

- Las pruebas deben cubrir casos de éxito, fallos y seguridad.
- Estructura de tests debe reflejar la de `lib/`.
- No se mergea código que no pase `flutter analyze` y `flutter test`.

---

### **4. Route Management**

- Use **GoRouter** for navigation and route management.
- Define all routes in a centralized file (`routes/router.dart`) to ensure consistency.
- Use named routes for better readability and maintainability.

**Example Directory Structure:**
```
routes/
├── router.dart
└── route_paths.dart
```

**Key Rules:**
- Avoid hardcoding route paths in the UI; always reference them from `route_paths.dart`.
- Use parameterized routes for dynamic navigation (e.g., `/profile/:userId`).

---

### **5. Dependency Injection**

- Use **get_it** or **injectable** for dependency injection.
- Register all dependencies in the `service_locator.dart` file under the `core/di/` directory.
- Follow these guidelines:
  - Use `lazySingleton` for services that should have a single instance throughout the app lifecycle.
  - Use `factory` for dependencies that need to be recreated each time they are injected.

**Example Setup:**
```dart
final sl = GetIt.instance;

void setupLocator() {
  // Register Use Cases
  sl.registerLazySingleton(() => GetUserUseCase(sl()));

  // Register Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // Register Data Sources
  sl.registerLazySingleton<UserDataSource>(() => UserDataSourceImpl());
}
```

---

### **6. Testing**

- Follow **Test-Driven Development (TDD)** principles.
- Write unit tests, widget tests, and integration tests for all layers.
- Use the following tools:
  - **Unit Tests:** Test business logic and use cases.
  - **Widget Tests:** Test UI components.
  - **Integration Tests:** Test end-to-end flows.

**Key Rules:**
- Place tests in the `test/` directory, mirroring the `lib/` structure.
- Ensure all tests pass before merging code into the main branch.

**Example Directory Structure:**
```
test/
├── domain/
│   └── usecases/
│       └── get_user_usecase_test.dart
├── data/
│   └── repositories/
│       └── user_repository_impl_test.dart
├── presentation/
│   └── blocs/
│       └── user_bloc_test.dart
└── ...
```

---

### **7. Additional Guidelines**

- **Code Quality:**  
  - Follow **Clean Code** principles.
  - Write self-explanatory, readable, and maintainable code.
  - Avoid unnecessary complexity or redundancy.

- **Documentation:**  
  - Document all modules, components, and their interactions in the `README.md` file.
  - Update this `ARCHITECTURE.md` file if new patterns, technologies, or architectural decisions are introduced.

- **Version Control:**  
  - Use Git for version control and follow branching strategies like Git Flow or Trunk-Based Development.
  - Ensure commit messages are descriptive and follow conventional commit standards (e.g., `feat:`, `fix:`, `docs:`).