// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Boilerplate';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginInvalidCredentials => 'Invalid username or password';

  @override
  String get loginUsernameRequired => 'Please enter your username';

  @override
  String get loginPasswordRequired => 'Please enter your password';

  @override
  String get loginPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get loginDemoHint => 'Demo: emilys / emilyspass';

  @override
  String get logout => 'Sign out';

  @override
  String get todoListTitle => 'Todos';

  @override
  String get todoListEmpty => 'No todos yet';

  @override
  String get todoListAdd => 'Add';

  @override
  String get todoListNewTitle => 'New todo';

  @override
  String get todoListNewDescription => 'What needs to be done?';

  @override
  String get todoListCreate => 'Create';

  @override
  String get todoListCancel => 'Cancel';

  @override
  String get todoListDelete => 'Delete';

  @override
  String get todoListDeleteConfirm => 'Delete this todo?';

  @override
  String get todoDetailTitle => 'Todo detail';

  @override
  String get todoDetailStatusCompleted => 'Completed';

  @override
  String get todoDetailStatusPending => 'Pending';

  @override
  String todoDetailIdLabel(String id) {
    return 'Todo #$id';
  }

  @override
  String get connectivityOffline => 'You are offline';

  @override
  String get connectivityRetry => 'Retry';

  @override
  String get errorUnexpected => 'Something went wrong';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorUnauthorized => 'Session expired. Please sign in again.';

  @override
  String get errorNotFound => 'Not found';

  @override
  String get errorNoConnection =>
      'No internet connection. Please check your network.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorValidation => 'Validation failed. Please check your input.';

  @override
  String get errorRateLimit => 'Too many requests. Please wait a moment.';

  @override
  String get errorCancelled => 'Request was cancelled.';

  @override
  String get errorSerialization =>
      'Failed to process response. Please try again.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get themeToggleLight => 'Switch to light mode';

  @override
  String get themeToggleDark => 'Switch to dark mode';

  @override
  String get themeToggleSystem => 'Use system theme';
}
