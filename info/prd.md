```yaml
app:
  name: Home Credit
  package_id: com.example.app
  platforms: [android], [IOS]
  routes_file: constants/app_routes.dart
  spacing_tokens: constants/app_spacing.dart
  durations_tokens: constants/app_durations.dart
  assets_constants:
    icons: constants/app_icons.dart
    images: constants/app_images.dart
  strings: app_strings
  codegen:
    strict: true
    unknown_prop: error
    enum_unknown: error
    forbid_inline_numbers: true
  theme:
    single_theme: true
    typography_source: ui/theme/app_fonts.dart
    colors_source: ui/theme/app_colors.dart
  conventions:
    state_suffix: State
    cubit_suffix: Cubit

screens:
  - page_file: lib/ui/pages/main_shell_page.dart
    route: /
    page_class: MainShellPage
  - page_file: lib/ui/pages/splash_page.dart
    route: /splash
    page_class: SplashPage
  - page_file: lib/ui/pages/onboarding_step_1_page.dart
    route: /onboarding/step-1
    page_class: OnboardingStep1Page
  - page_file: lib/ui/pages/onboarding_step_2_page.dart
    route: /onboarding/step-2
    page_class: OnboardingStep2Page
  - page_file: lib/ui/pages/home_page.dart
    route: /home
    page_class: HomePage
  - page_file: lib/ui/pages/credit_shell_page.dart
    route: /credit
    page_class: CreditPage
  - page_file: lib/ui/pages/settings_page.dart
    route: /settings
    page_class: SettingsPage
  - page_file: lib/ui/pages/participants_balance_page.dart
    route: /participants-balance
    page_class: ParticipantsBalancePage
  - page_file: lib/ui/pages/no_internet_page.dart
    route: /no-internet
    page_class: NoInternetPage
```

```yaml
screen:
  page_file: lib/ui/pages/splash_page.dart
  route: /splash
  page_class: SplashPage
  strings: []
  icons: []
  images:
    - AppImages.splashBackground
```

```yaml
screen:
  page_file: lib/ui/pages/onboarding_step_1_page.dart
  strings:
    - "AppStrings.onboardingStep1Title = 'HOME CREDIT: WE MANAGE THE HOME BUDGET TOGETHER'"
    - "AppStrings.onboardingStep1Subtitle = 'Our application will help you split family expenses together!'"
    - "AppStrings.commonContinue = 'Continue'"
  icons: []
  images:
    - AppImages.onboardingStep1Background
    - AppImages.onboardingStep1People
```


```yaml
screen:
  page_file: lib/ui/pages/onboarding_step_2_page.dart
  route: /onboarding/step-2
  page_class: OnboardingStep2Page
  strings:
    - "AppStrings.onboardingStep2Title = 'ADD ALL MEMBERS RIGHT NOW'"
    - "AppStrings.onboardingStep2Intro = 'Enter your name and photo'"
    - "AppStrings.onboardingStep2AddTeamMember = 'Add a team member'"
    - "AppStrings.onboardingStep2Hint = 'Enter the name and photo of the new member. You can add no more than 10 members.'"
    - "AppStrings.onboardingStep2SelectCurrencyLabel = 'Select currency'"
    - "AppStrings.onboardingStep2CurrencyPlaceholder = 'Currency'"
    - "AppStrings.currencyUsd = 'USD'"
    - "AppStrings.currencyEur = 'EUR'"
    - "AppStrings.commonSkip = 'Skip'"
    - "AppStrings.commonContinue = 'Continue'"
    - "AppStrings.addYourNameTitle = 'Add your name'"
    - "AppStrings.addYourNameAddNameLabel = 'Add name'"
    - "AppStrings.addYourNameParticipantNamePlaceholder = 'Participant name'"
    - "AppStrings.addYourNameAddPhotoLabel = 'Add photo'"
    - "AppStrings.commonSave = 'Save'"
    - "AppStrings.commonClearInformation = 'Clear information'"
    - "AppStrings.deleteParticipantTitle = 'Delete Participant'"
    - "AppStrings.deleteParticipantMessage = 'Do you want to delete your data?'"
    - "AppStrings.commonDelete = 'Delete'"
    - "AppStrings.commonCancel = 'Cancel'"
  icons:
    - AppIcons.userAdd
    - AppIcons.chevronDown
    - AppIcons.close
    - AppIcons.plus
  images: []
```


```yaml
screen:
  - page_file: lib/ui/pages/home_page.dart
    route: /home
    page_class: HomePage
    strings:
      - "AppStrings.navHome = 'Home'"
      - "AppStrings.navCredit = 'Credit'"
      - "AppStrings.navSettings = 'Settings'"
      - "AppStrings.homeWelcome = 'Welcome!'"
      - "AppStrings.homeUserNamePlaceholder = 'Name'"
      - "AppStrings.homeTotalBudgetLabel = 'Total budget amount'"
      - "AppStrings.homeDetails = 'Details'"
      - "AppStrings.homeQuickAddIncome = 'Add income'"
      - "AppStrings.homeQuickAddExpenses = 'Add expenses'"
      - "AppStrings.homeQuickAddParticipant = 'Add participant'"
      - "AppStrings.homeEmptyState = 'No new records have been entered yet, you can create a new record.'"
      - "AppStrings.addIncomeTitle = 'Add Income'"
      - "AppStrings.addIncomeWhoIsToppingUp = 'Who is topping up'"
      - "AppStrings.addIncomeAddParticipant = 'Add participant'"
      - "AppStrings.addIncomeAmountPlaceholder = 'Amount'"
      - "AppStrings.commonCurrency = 'Currency'"
      - "AppStrings.addIncomePaymentScheduleLabel = 'Payment schedule, date'"
      - "AppStrings.commonToday = 'Today'"
      - "AppStrings.commonSave = 'Save'"
      - "AppStrings.addExpensesTitle = 'Add Expenses'"
      - "AppStrings.addExpensesWhoIsSpending = 'Who is spending'"
      - "AppStrings.addExpensesAddParticipant = 'Add participant'"
      - "AppStrings.addExpensesAmountPlaceholder = 'Amount'"
      - "AppStrings.addExpensesSplitTransactionLabel = 'Split transaction?'"
      - "AppStrings.commonYes = 'Yes'"
      - "AppStrings.commonNo = 'No'"
      - "AppStrings.addExpensesEnterPercentagePlaceholder = 'Enter percentage'"
      - "AppStrings.addExpensesPaymentScheduleLabel = 'Payment schedule, date'"
      - "AppStrings.transactionExceedsBalance = 'You have exceeded your balance by {amount}'"
      - "AppStrings.transactionBorrowMissingAmount = 'Borrow the missing amount:'"
      - "AppStrings.enterDifferentAmountTitle = 'Enter a different amount'"
      - "AppStrings.enterDifferentAmountMessage = 'Unfortunately, none of the participants have this amount.'"
      - "AppStrings.commonClose = 'Close'"
      - "AppStrings.commonEdit = 'Edit'"
      - "AppStrings.commonDelete = 'Delete'"
      - "AppStrings.deleteEntryTitle = 'Delete this entry?'"
      - "AppStrings.deleteEntryMessage = 'All your data will be lost, without the possibility of recovery.'"
    icons:
      - AppIcons.navHome
      - AppIcons.navCredit
      - AppIcons.navSettings
      - AppIcons.userAvatarPlaceholder
      - AppIcons.quickAddIncome
      - AppIcons.quickAddExpenses
      - AppIcons.userAdd
      - AppIcons.close
      - AppIcons.chevronDown
      - AppIcons.calendar
      - AppIcons.edit
      - AppIcons.delete
      - AppIcons.radioOn
      - AppIcons.radioOff
    images: []
```

```yaml
  - page_file: lib/ui/pages/participants_balance_page.dart
    route: /participants-balance
    page_class: ParticipantsBalancePage
    strings:
      - "AppStrings.participantsBalanceTitle = 'Participants'' Balance'"
      - "AppStrings.participantsBalanceAddParticipant = 'Add participant'"
      - "AppStrings.participantsBalanceEmptyState = 'Participants do not have any debts yet.'"
      - "AppStrings.participantsBalanceOwes = 'owes'"
    icons:
      - AppIcons.back
      - AppIcons.userAvatarPlaceholder
    images: []
```

```yaml
screen:
  page_file: lib/ui/pages/credit_page.dart
  route: /credit
  page_class: CreditPage
  strings:
    - "AppStrings.creditCalculatorAppBarTitle = 'Credit calculator'"
    - "AppStrings.creditCalculatorTitle = 'Credit Calculator'"
    - "AppStrings.creditCalculatorCreditAmountLabel = 'Credit Amount'"
    - "AppStrings.creditCalculatorInterestLabel = 'Interest'"
    - "AppStrings.creditCalculatorRepaymentAmountLabel = 'Repayment Amount'"
    - "AppStrings.creditCalculatorLoanAmountLabel = 'Loan Amount, USD'"
    - "AppStrings.creditCalculatorLoanTermLabel = 'Loan Term, months'"
    - "AppStrings.creditCalculatorInterestRateLabel = 'Interest Rate, %'"
    - "AppStrings.creditCalculatorCalculate = 'Calculate'"
  icons:
    - AppIcons.navHome
    - AppIcons.navCredit
    - AppIcons.navSettings
  images: []
```

```yaml
screen:
  - page_file: lib/ui/pages/settings_page.dart
    route: /settings
    page_class: SettingsPage
    strings:
      - "AppStrings.settingsTitle = 'Settings'"
      - "AppStrings.settingsUserNamePlaceholder = 'User Name'"
      - "AppStrings.settingsSinceDate = 'Since {date}'"
      - "AppStrings.settingsNotifications = 'Notifications'"
      - "AppStrings.settingsPrivacyPolicy = 'Privacy Policy'"
      - "AppStrings.settingsShareApplication = 'Share Application'"
      - "AppStrings.settingsClearData = 'Clear Data'"
      - "AppStrings.clearDataTitle = 'Clear data'"
      - "AppStrings.clearDataMessage = 'Do you want to clear your data?'"
      - "AppStrings.commonAccept = 'Accept'"
      - "AppStrings.commonCancel = 'Cancel'"
    icons:
      - AppIcons.navHome
      - AppIcons.navCredit
      - AppIcons.navSettings
      - AppIcons.userAdd
      - AppIcons.edit
      - AppIcons.chevronRight
    images: []
```

```yaml
  - page_file: lib/ui/pages/no_internet_page.dart
    route: /no-internet
    page_class: NoInternetPage
    strings:
      - "AppStrings.noInternetTitle = 'It seems you have lost your Internet connection.'"
      - "AppStrings.noInternetSubtitle = 'Try again later'"
      - "AppStrings.noInternetCheckConnection = 'Check connection'"
    icons:
      - AppIcons.noInternet
    images:
      - AppImages.noInternetBackground
```