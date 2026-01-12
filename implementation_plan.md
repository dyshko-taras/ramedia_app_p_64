# Implementation Plan — Home Credit (Flutter)

Цей план базується на вимогах з `info/` (`prd.md`, `technical_spec.md`, `visual_style.md`, `guidelines.md`, `assets_list.md`).
Під час реалізації я буду відмічати чекбокси як виконані.

## Constraints (узгоджені правила)

- `main()` у `lib/main.dart` не змінюю (можу лише доповнювати його за потреби).
- Папку `assets/` не редагую — вважаю, що всі потрібні файли вже додані тобою; я лише використовую їх через `AppIcons` / `AppImages` і прописую реєстрацію в `pubspec.yaml`.

> Примітка про дизайн: коли дійдемо до точного UI, ти будеш надсилати скріни — я буду звіряти відступи/розміри/розташування з ними, але все одно триматимуся токенів і контрактів з `info/guidelines.md`.

---

## Phase 0 — Baseline / Setup

- [x] Перевірити поточний стан репозиторію (що вже є в `lib/`, `pubspec.yaml`).
- [x] Узгодити мінімальний набір пакетів під вимоги (додано в `pubspec.yaml`: `flutter_bloc`, `equatable`, `shared_preferences`, `flutter_svg`, `lottie`, `url_launcher`, `share_plus`, `permission_handler`, `drift`, `sqlite3_flutter_libs`, `path_provider`).
- [x] Налаштувати `pubspec.yaml`: реєстрація assets (`assets/icons/`, `assets/images/`) + fonts (Montserrat) згідно `info/visual_style.md` та `info/assets_list.md`.

## Phase 1 — Project Skeleton (структура `lib/` + контракти)

- [x] Додати `lib/app.dart` (MaterialApp, theme, initialRoute, routes).
- [x] Підключити `App` з `lib/app.dart` у `lib/main.dart` без зміни `main()` (лише доповнення, якщо потрібно).
- [x] Створити `lib/constants/`:
  - [x] `app_routes.dart` (маршрути з `info/prd.md`)
  - [x] `app_strings.dart` (усі тексти з PRD/tech spec)
  - [x] `app_icons.dart` / `app_images.dart` (лише константи, без “raw paths” у UI)
  - [x] `app_spacing.dart`, `app_durations.dart`, `app_radius.dart`, `app_sizes.dart` (токени/хелпери для відступів/таймінгів/радіусів/розмірів)
- [x] Створити `lib/ui/theme/`: `app_colors.dart`, `app_fonts.dart`, `app_theme.dart` (single theme, Material 3, Montserrat; палітра з `info/visual_style.md`).

## Phase 2 — Navigation & Shell

- [ ] Реалізувати `MainShellPage` з Bottom Navigation (Home/Credit/Settings) згідно `info/prd.md` + правила з `info/guidelines.md` (IndexedStack).
- [ ] Додати `MainShellCubit` + `MainShellState` (керування активною вкладкою та навігаційними подіями).
- [ ] Підключити routes так, щоб `/home`, `/credit`, `/settings` відкривали `MainShellPage(initialIndex: ...)`.
- [ ] Додати “non-tab” routes (Splash, Onboarding step 1/2, Participants Balance, No Internet) як окремі сторінки.
- [ ] Впровадити “back button rules” (ігнорувати Android system back там, де потрібно за `info/technical_spec.md`).

## Phase 3 — Assets & UI Building Blocks

- [ ] Описати всі SVG іконки через `AppIcons` (без редагування `assets/`).
- [ ] Описати всі зображення/фони через `AppImages` (без редагування `assets/`).
- [ ] Додати базові reusable widgets (мінімально необхідні):
  - [ ] Primary/Secondary button стилі під theme
  - [ ] Common dialogs/bottom sheets (confirm, form sheets)
  - [ ] Common text fields + валідації (за правилами “Input & Validation”)

## Phase 4 — Splash / Preloader

- [ ] `SplashPage`: background image + Lottie loader (loop).
- [ ] `SplashCubit` + `SplashState` (ініціалізація та рішення куди навігувати).
- [ ] Мінімальна ініціалізація локальних даних (без мережі) + редірект:
  - [ ] новий користувач → Onboarding Step 1
  - [ ] існуючий → `/home` (через shell)
- [ ] Дотриматися UX вимог (не мигати при resume, мін. час показу — за потреби).

## Phase 5 — Onboarding Flow

- [ ] `OnboardingStep1Page` + `OnboardingStep1Cubit` + `OnboardingStep1State` (екран + логіка permission для push як в tech spec).
- [ ] `OnboardingStep2Page` + `OnboardingStep2Cubit` + `OnboardingStep2State` (“add your name” / додавання учасників (≤10), вибір валюти, модалки/діалоги (delete/clear info)).
- [ ] Збереження онбордингу в локальне сховище.
- [ ] Навігація далі в основний flow.

## Phase 6 — Local Data (моделі + сховище)

- [ ] Описати доменні моделі (мінімальні) для:
  - [ ] User/Profile
  - [ ] Participant
  - [ ] Transactions (income/expenses)
  - [ ] Currency
- [ ] Реалізувати локальне збереження (на старті — `SharedPreferences`, якщо вимоги не потребують складнішого).
- [ ] Реалізувати “Clear Data” (повне очищення) як окрему дію, яку можна викликати з Settings.

## Phase 7 — Database & Repositories

- [ ] Додати базу даних (за потреби: Drift/SQLite) для транзакцій/учасників/налаштувань та описати схему.
- [ ] Додати DAO/Store рівень для читання/запису.
- [ ] Додати repositories як єдину точку доступу до даних для UI/Cubit (Cubit не ходить напряму в DB/SharedPreferences).
- [ ] Узгодити стратегічно: що живе в DB, а що в SharedPreferences (напр. lightweight flags/onboarding).

## Phase 8 — Home (Family Bank)

- [ ] `HomePage` + `HomeCubit` + `HomeState` (UI + логіка) згідно `info/technical_spec.md` + PRD strings/icons.
- [ ] “Quick add” дії:
  - [ ] Add income (modal)
  - [ ] Add expenses (modal + split transaction логіка)
  - [ ] Add participant (modal)
- [ ] Empty state + list/деталі (мінімально до вимог).
- [ ] Обробка edge cases з tech spec (перевищення балансу, enter different amount, тощо).

## Phase 9 — Participants Balance

- [ ] `ParticipantsBalancePage` + `ParticipantsBalanceCubit` + `ParticipantsBalanceState` (UI + логіка) + empty state.
- [ ] Розрахунок “хто кому винен” на базі локальних транзакцій.

## Phase 10 — Credit Calculator

- [ ] `CreditPage` + `CreditCubit` + `CreditState` (pure UI + calculation logic, без впливу на Home/participants).
- [ ] Валідації та edge cases (0% rate, нульові/великі значення, округлення до 2 знаків).

## Phase 11 — Settings

- [ ] `SettingsPage` + `SettingsCubit` + `SettingsState` (UI + логіка).
- [ ] Notifications: перший тап → permission, наступні → системні налаштування (як в tech spec).
- [ ] Privacy Policy: `url_launcher`.
- [ ] Share Application: `share_plus`.
- [ ] Clear Data: confirm dialog → повне очищення → редірект в Onboarding.
- [ ] Винести Privacy+Share в “shared logic file” і створити `settings-path.txt` з шляхом до цього файлу (як в tech spec).

## Phase 12 — No Internet Screen + Connectivity

- [ ] `NoInternetPage` + `NoInternetCubit` + `NoInternetState` (full-screen) з кнопкою “Check connection”.
- [ ] Мінімальна перевірка підключення (за потреби додамо пакет) і повернення в попередній flow.

## Phase 13 — Polish & Consistency Pass

- [ ] Уніфікувати анімації тапів (scale/color change), haptics, поведінку клавіатури/контекстних меню/шитів.
- [ ] Перевірити, що немає “raw strings” та “magic numbers” (усе через `AppStrings` і токени).
- [ ] Візуальний review з твоїми дизайн-скрінами та точкові правки UI.

## Phase 14 — QA / Smoke Tests

- [ ] Прогнати `flutter analyze`.
- [ ] Прогнати збірку/запуск на Android (мінімальний smoke).
- [ ] Перевірити основні флоу: first launch → onboarding → home; додавання доходів/витрат; settings actions; clear data.
