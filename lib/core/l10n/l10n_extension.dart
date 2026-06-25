import 'package:flutter/widgets.dart';

import 'package:flutter_clean_riverpod_boilerplate/l10n/generated/app_localizations.dart';

/// Convenience extension so call sites can write `context.l10n.todoListTitle`
/// instead of the verbose and nullable `AppLocalizations.of(context)!`.
extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
