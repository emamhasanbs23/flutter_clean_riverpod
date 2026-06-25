// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Plantilla Flutter';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginEmailLabel => 'Correo';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginSubmit => 'Entrar';

  @override
  String get loginInvalidCredentials => 'Correo o contraseña inválidos';

  @override
  String get loginEmailRequired => 'Ingresa tu correo';

  @override
  String get loginEmailInvalid => 'Ingresa un correo válido';

  @override
  String get loginPasswordRequired => 'Ingresa tu contraseña';

  @override
  String get loginPasswordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get loginDemoHint =>
      'Demo: cualquier correo y contraseña de 6+ caracteres';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get todoListTitle => 'Tareas';

  @override
  String get todoListEmpty => 'Aún no hay tareas';

  @override
  String get todoListAdd => 'Agregar';

  @override
  String get todoListNewTitle => 'Nueva tarea';

  @override
  String get todoListNewDescription => '¿Qué hay que hacer?';

  @override
  String get todoListCreate => 'Crear';

  @override
  String get todoListCancel => 'Cancelar';

  @override
  String get todoListDelete => 'Eliminar';

  @override
  String get todoListDeleteConfirm => '¿Eliminar esta tarea?';

  @override
  String get connectivityOffline => 'Sin conexión';

  @override
  String get connectivityRetry => 'Reintentar';

  @override
  String get errorUnexpected => 'Algo salió mal';

  @override
  String get errorNetwork => 'Error de red. Verifica tu conexión.';

  @override
  String get errorUnauthorized => 'La sesión expiró. Inicia sesión de nuevo.';

  @override
  String get errorNotFound => 'No encontrado';

  @override
  String get commonRetry => 'Reintentar';
}
