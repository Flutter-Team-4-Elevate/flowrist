# Flowery — Technical Agreements

This document tracks the technical decisions agreed on for the Flowery project. New sections will be
added as more agreements are made.

## 1. Architecture & Folder Structure

**Pattern:** Clean Architecture (data / domain / presentation layers) applied in a feature-first
structure, using MVI (Model-View-Intent) for the presentation layer's state handling.

**Top-level layout:** 3 root directories under `lib/` — `core/` (UI-related), `config/` (
logic/infrastructure), and `features/` (feature modules).

```
lib/
├── core/
│   ├── ui/
│   │   ├── theme/
│   │   └── widgets/          # cross-feature shared widgets
│   └── constants/
├── config/
│   ├── di/
│   ├── dio/
│   ├── error_handler/
│   ├── l10n/
│   └── ...                   # other cross-cutting logic dirs
├── features/
│   ├── cart/
│   │   ├── data/
│   │   │   ├── api_client/
│   │   │   ├── data_sources/
│   │   │   │   ├── local/
│   │   │   │   └── remote/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── use_cases/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── view/
│   │       │   └── widgets/   # view-specific custom widgets
│   │       └── view_model/
│   │           ├── intent
│   │           ├── state
│   │           └── view_model
│   ├── checkout/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── ...
└── main.dart
```

**Rules of agreement:**

- Every feature — regardless of size or complexity — gets the full `data/domain/presentation` split.
  No shortcuts for "small" features.
- `core/` holds UI-related shared code (`ui/theme`, `ui/widgets`) and `constants/`.
- `config/` holds cross-cutting logic/infrastructure: dependency injection (`di`), networking (
  `dio`), error handling, localization (`l10n`), etc.
- Each feature's `data/` layer is split into `api_client/`, `data_sources/` (further split into
  `local/` and `remote/`), `models/`, and `repositories/`.
- Each feature's `domain/` layer holds `use_cases/`, `entities/`, and `repositories/`.
- Each feature's `presentation/` layer follows MVI: `view/` (renders state, dispatches intents —
  with its own `widgets/` for view-specific components) and `view_model/` (holding the `intent`,
  `state`, and `view_model` classes).
- Cross-feature shared widgets live under `core/ui/widgets/` — never duplicated across features.
  View-specific widgets live inside that feature's own `presentation/view/widgets/`.
- Data flows strictly in one direction: `data → domain → presentation`, and within presentation:
  `intent → view_model → state → view`.

---

## 2. State Management

**Solution:** Bloc/Cubit (`flutter_bloc`).

**Default per feature:** `Cubit`, not `Bloc`. Each feature's `view_model` exposes a single
`doIntent(Intent intent)` or (`doEvent(Event event)`) method that routes incoming intents
internally, rather than using Bloc's formal event-stream mapping.

**State modeling:** Every feature's state extends a shared base state class with:

- `isLoading` — `bool` flag
- `errorMessage` — nullable error string
- `data` — generic `T` payload holding the feature-specific state data

```dart
class BaseState<T> {
  final bool isLoading;
  final String? errorMessage;
  final T? data;

  const BaseState({
    this.isLoading = false,
    this.errorMessage,
    this.data,
  });
}
```

**Rules of agreement:**

- Feature Cubits live in `presentation/view_model/` alongside their `intent` and `state` classes.
- All intents for a feature are routed through the single `doIntent` entry point on the Cubit — no
  separate public methods per action.
- All feature states extend the shared `BaseState<T>`, keeping loading/error/data handling
  consistent across the app.

---

## 3. Networking & Error Handling

**Networking:** A `dio` module (`config/dio/`) configured with **Retrofit** for declarative API
service definitions. Request and response models are generated with **json_serializable**, keeping
serialization boilerplate out of hand-written code.

```dart
@RestApi()
abstract class FlowerApiClient {
  factory FlowerApiClient(Dio dio) = _FlowerApiClient;

  @GET("/flowers")
  Future<FlowerListResponse> getFlowers();
}

@JsonSerializable()
class FlowerListResponse {
  final List<FlowerModel> flowers;

  // ...
  factory FlowerListResponse.fromJson(Map<String, dynamic> json) =>
      _$FlowerListResponseFromJson(json);
}
```

**Error handling:** A general error handler (`config/error_handler/`) centralizes failure
interpretation. It inspects the exception type (e.g. `DioException`, timeout, parsing failure) and
HTTP status code, then maps them to a user-facing error message.

**Rules of agreement:**

- Retrofit-generated API clients live under each feature's `data/api_client/`.
- Generated request/response models live under `data/models/`, using `json_serializable`.
- All network-layer exceptions are funneled through the shared error handler in
  `config/error_handler/` — features don't write their own exception-to-message mapping.
- The error handler's output message is what populates `BaseState.errorMessage`.

---

## 4. Dependency Injection

**Solution:** [`injectable`](https://pub.dev/packages/injectable) (built on `get_it`), configured in
a dedicated `config/di/` module.

```dart
@injectable
class FlowerRepositoryImpl implements FlowerRepository {
  FlowerRepositoryImpl(this._apiClient);

  final FlowerApiClient _apiClient;
// ...
}

@module
abstract class DioModule {
  @lazySingleton
  Dio provideDio() => Dio(/* ... */);
}
```

**Rules of agreement:**

- All injectable classes (Cubits, repositories, use cases, API clients) are annotated (
  `@injectable`, `@lazySingleton`, `@singleton`) rather than manually registered.
- Third-party or non-annotable dependencies (e.g. `Dio`, `SharedPreferences`) are provided via
  `@module` classes inside `config/di/`.
- Code generation (`build_runner`) produces the service locator setup — no hand-written
  registration.

---

## 5. Local Storage (⚠️ Hive Still In Progress)

**Secure storage:** Agreed — `flutter_secure_storage` for sensitive data (e.g. tokens).

**Hive:** Still in progress/discussion, for general local/offline data caching. Not yet implemented.

**Status:** Secure storage is settled; Hive's role (what gets cached, box/key naming conventions,
where local `data_sources/local/` implementations plug in) is still being worked out. Update this
section once Hive is finalized.

---

## 6. Localization (l10n)

**Current scope:** Single locale — English only, for now.

**Location:** `config/l10n/`.

**Rules of agreement:**

- All user-facing strings go through the `l10n/` setup rather than being hardcoded inline, even with
  a single locale, so adding languages later doesn't require a rewrite.
- Additional locales are not yet planned/scoped — revisit this section if that changes.

---

## 7. Navigation / Routing

**Solution:** [`go_router`](https://pub.dev/packages/go_router), with routes defined as raw string
path constants (no code generation, no type-safe routes).

**Location:** A central `app_router` defined in `core/constants/`.

```dart
// core/constants/app_router.dart
class AppRoutes {
  static const home = '/home';
  static const flowerDetails = '/flowers/:flowerId';
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: AppRoutes.flowerDetails,
      builder: (context, state) {
        final flowerId = state.pathParameters['flowerId']!;
        return FlowerDetailsView(flowerId: flowerId);
      },
    ),
  ],
);
```

**Rules of agreement:**

- All routes are declared centrally in `core/constants/app_router` — features don't register their
  own routers.
- Route paths are defined as string constants (e.g. in an `AppRoutes` class) rather than hardcoded
  inline strings scattered through the codebase.
- New screens require adding a route constant and a corresponding `GoRoute` entry to the central
  router before wiring navigation to them.

---

## 8. Theming

**Location:** `core/constants/`, alongside routing.

**Structure:** A central `app_theme` file holds the `ThemeData`, seeded by four supporting constant
files:

- `app_colors` — color palette
- `app_styles` — text/other styles
- `app_images` — image asset references
- `app_dimensions` — spacing, sizing, radii, etc.

**Current scope:** Light theme only — no dark theme yet.

**Rules of agreement:**

- Colors, styles, image paths, and dimensions are never hardcoded inline in widgets — they're pulled
  from `app_colors`, `app_styles`, `app_images`, and `app_dimensions` respectively.
- `app_theme` composes these into the single `ThemeData` consumed by `MaterialApp`.
- Dark theme is not yet planned/scoped — revisit this section if that changes.

---

## 9. Testing

**Status:** Not yet discussed — no conventions agreed on. This is planned for a future team meeting.

---

## 10. Naming Convention

**Files:** `snake_case` (e.g. `flower_details_view.dart`, `app_router.dart`) — Dart's default
convention.

**Classes:** `PascalCase` (e.g. `FlowerDetailsView`, `FlowerRepositoryImpl`).

**Rules of agreement:**

- Words in `snake_case` names are always kept separate — never combined. `view_model.dart`, not
  `viewmodel.dart`.
- Value/constant container files (colors, strings, dimensions, styles, images, etc.) always carry an
  `app_` prefix — e.g. `app_colors.dart`, `app_strings.dart`, `app_dimensions.dart`.
- Custom (shared) widget files also carry the `app_` prefix — e.g. `app_button.dart`,
  `app_text_field.dart`.

This follows standard Dart/Flutter conventions — no custom deviations beyond the `app_` prefix rule
above.

---

## 11. Git Commit Convention

**Standard:** [Conventional Commits](https://www.conventionalcommits.org/).

**Common prefixes:**

- `feat:` — a new feature
- `fix:` — a bug fix
- `chore:` — maintenance, tooling, or non-functional changes
- `refactor:` — code change that neither fixes a bug nor adds a feature
- `docs:` — documentation-only changes
- `test:` — adding or fixing tests

**Format:** `<type>(<scope>): <short description>` — scope is optional.

**Rules of agreement:**

- The short description is always lowercase.
- Scope (in parentheses) is optional and names the affected area, e.g.
  `feat(cart): add quantity stepper`.
- A body can be added when more detail is needed, with each point on its own line starting with `-`:

```
feat(checkout): add promo code field

- validates code against the promo use case
- shows inline error on invalid code
- clears field on successful order submission
```

---

*Next agreement to add: TBD*
