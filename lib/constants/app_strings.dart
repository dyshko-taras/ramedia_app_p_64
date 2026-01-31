import 'package:flutter/foundation.dart';

@immutable
abstract final class AppStrings {
  // Navigation
  static const navHome = 'Home';
  static const navCredit = 'Credit';
  static const navSettings = 'Settings';

  // Common
  static const commonContinue = 'Continue';
  static const commonSkip = 'Skip';
  static const commonSave = 'Save';
  static const commonClearInformation = 'Clear information';
  static const commonDelete = 'Delete';
  static const commonCancel = 'Cancel';
  static const commonCurrency = 'Currency';
  static const commonToday = 'Today';
  static const commonYes = 'Yes';
  static const commonNo = 'No';
  static const commonClose = 'Close';
  static const commonEdit = 'Edit';
  static const commonAccept = 'Accept';

  // Splash
  static const splashTitle = 'Splash';

  // Onboarding step 1
  static const onboardingStep1Title =
      'HOME CREDIT: WE MANAGE THE HOME BUDGET TOGETHER';
  static const onboardingStep1Subtitle =
      'Our application will help you split family expenses together!';

  // Onboarding step 2
  static const onboardingStep2Title = 'ADD ALL MEMBERS RIGHT NOW';
  static const onboardingStep2Intro = 'Enter your name and photo';
  static const onboardingStep2AddTeamMember = 'Add a team member';
  static const onboardingStep2Hint =
      'Enter the name and photo of the new member. You can add no more than 10 members.';
  static const onboardingStep2SelectCurrencyLabel = 'Select currency';
  static const onboardingStep2CurrencyPlaceholder = 'Currency';
  static const currencyUsd = 'USD';
  static const currencyEur = 'EUR';

  static const addYourNameTitle = 'Add your name';
  static const addYourNameAddNameLabel = 'Add name';
  static const addYourNameParticipantNamePlaceholder = 'Participant name';
  static const addYourNameAddPhotoLabel = 'Add photo';

  static const deleteParticipantTitle = 'Delete Participant';
  static const deleteParticipantMessage = 'Do you want to delete your data?';

  // Home
  static const homeWelcome = 'Welcome!';
  static const homeUserNamePlaceholder = 'Name';
  static const homeTotalBudgetLabel = 'Total budget amount';
  static const homeDetails = 'Details';
  static const homeQuickAddIncome = 'Add\nincome';
  static const homeQuickAddExpenses = 'Add\nexpenses';
  static const homeQuickAddParticipant = 'Add\nparticipant';
  static const homeEmptyState =
      'No new records have been entered yet, you can create a new record.';

  static const addIncomeTitle = 'Add Income';
  static const addIncomeWhoIsToppingUp = 'Who is topping up';
  static const addIncomeAddParticipant = 'Add participant';
  static const addIncomeAmountPlaceholder = 'Amount';
  static const addIncomePaymentScheduleLabel = 'Payment schedule, date';

  static const addExpensesTitle = 'Add Expenses';
  static const addExpensesWhoIsSpending = 'Who is spending';
  static const addExpensesAddParticipant = 'Add participant';
  static const addExpensesAmountPlaceholder = 'Amount';
  static const addExpensesSplitTransactionLabel = 'Split transaction?';
  static const addExpensesEnterPercentagePlaceholder = 'Enter percentage';
  static const addExpensesRemainingPercent = 'Remaining: {percent}%';
  static const addExpensesPayerPercent = 'Payer: {percent}%';
  static const addExpensesPaymentScheduleLabel = 'Payment schedule, date';

  static const transactionExceedsBalance =
      'You have exceeded your balance by {amount}';
  static const transactionBorrowMissingAmount = 'Borrow the missing amount:';
  static const enterDifferentAmountTitle = 'Enter a different amount';
  static const enterDifferentAmountMessage =
      'Unfortunately, none of the participants have this amount.';

  static const deleteEntryTitle = 'Delete this entry?';
  static const deleteEntryMessage =
      'All your data will be lost, without the possibility of recovery.';

  // Participants balance
  static const participantsBalanceTitle = "Participants' Balance";
  static const participantsBalanceAddParticipant = 'Add participant';
  static const participantsBalanceEmptyState =
      'Participants do not have any debts yet.';
  static const participantsBalanceOwes = 'owes';

  // Credit calculator
  static const creditCalculatorAppBarTitle = 'Credit calculator';
  static const creditCalculatorTitle = 'Credit Calculator';
  static const creditCalculatorCreditAmountLabel = 'Credit Amount';
  static const creditCalculatorInterestLabel = 'Interest';
  static const creditCalculatorRepaymentAmountLabel = 'Repayment Amount';
  static const creditCalculatorLoanAmountLabel = 'Loan Amount, USD';
  static const creditCalculatorLoanTermLabel = 'Loan Term, months';
  static const creditCalculatorInterestRateLabel = 'Interest Rate, %';
  static const creditCalculatorCalculate = 'Calculate';

  // Settings
  static const settingsTitle = 'Settings';
  static const settingsUserNamePlaceholder = 'User Name';
  static const settingsSinceDate = 'Since {date}';
  static const settingsNotifications = 'Notifications';
  static const settingsPrivacyPolicy = 'Privacy Policy';
  static const settingsShareApplication = 'Share Application';
  static const settingsClearData = 'Clear Data';
  static const clearDataTitle = 'Clear data';
  static const clearDataMessage = 'Do you want to clear your data?';

  // No internet
  static const noInternetTitle =
      'It seems you have lost your Internet connection.';
  static const noInternetSubtitle = 'Try again later';
  static const noInternetCheckConnection = 'Check connection';
}
