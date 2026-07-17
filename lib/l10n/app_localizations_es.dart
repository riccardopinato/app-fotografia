// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'FrameLab';

  @override
  String get navHome => 'Inicio';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navIdeas => 'Ideas';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navProfile => 'Perfil';

  @override
  String get homePlaceholderTitle =>
      'Tu espacio fotográfico está tomando forma';

  @override
  String get homePlaceholderDescription =>
      'La experiencia de inicio llegará en una próxima actualización.';

  @override
  String get explorePlaceholderTitle => 'Explorar llegará pronto';

  @override
  String get explorePlaceholderDescription =>
      'Aquí aparecerá contenido fotográfico para descubrir.';

  @override
  String get ideasPlaceholderTitle => 'Las ideas llegarán pronto';

  @override
  String get ideasPlaceholderDescription =>
      'Aquí aparecerán propuestas fotográficas personalizadas.';

  @override
  String get libraryPlaceholderTitle => 'Tu biblioteca llegará pronto';

  @override
  String get libraryPlaceholderDescription =>
      'Aquí aparecerán inspiración y notas guardadas.';

  @override
  String get profilePlaceholderTitle => 'Tu perfil llegará pronto';

  @override
  String get profilePlaceholderDescription =>
      'Aquí aparecerán tus preferencias y recorrido fotográfico.';

  @override
  String get navigationLabel => 'Navegación principal';
}
