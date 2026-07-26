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
  String get libraryLoading => 'Cargando contenido guardado';

  @override
  String get libraryEmptyTitle => 'Aún no hay contenido guardado';

  @override
  String get libraryEmptyDescription =>
      'Guarda contenido del catálogo para encontrarlo aquí.';

  @override
  String get libraryErrorTitle => 'Archivo no disponible';

  @override
  String get libraryErrorDescription =>
      'Intenta cargar de nuevo el contenido guardado.';

  @override
  String libraryCardSemantics(String title) {
    return 'Abrir contenido guardado: $title';
  }

  @override
  String get profilePlaceholderTitle => 'Tu perfil llegará pronto';

  @override
  String get profilePlaceholderDescription =>
      'Aquí aparecerán tus preferencias y recorrido fotográfico.';

  @override
  String get navigationLabel => 'Navegación principal';

  @override
  String get onboardingTitle => 'Configura tu perfil fotográfico';

  @override
  String get onboardingDescription =>
      'Elige preferencias que puedes cambiar cuando quieras.';

  @override
  String get onboardingContinue => 'Guardar preferencias';

  @override
  String get profileTitle => 'Tu perfil';

  @override
  String get profileDescription =>
      'Estas preferencias influirán en futuras sugerencias.';

  @override
  String get profileSave => 'Guardar cambios';

  @override
  String get profileSkillLevel => 'Nivel de experiencia';

  @override
  String get skillBeginner => 'Principiante';

  @override
  String get skillIntermediate => 'Intermedio';

  @override
  String get skillAdvanced => 'Avanzado';

  @override
  String get profileTopics => 'Intereses fotográficos';

  @override
  String get topicPortrait => 'Retrato';

  @override
  String get topicLandscape => 'Paisaje';

  @override
  String get topicStreet => 'Street';

  @override
  String get topicMacro => 'Macro';

  @override
  String get topicNight => 'Fotografía nocturna';

  @override
  String get topicSmartphone => 'Smartphone';

  @override
  String get profileLearningGoals => 'Objetivos de aprendizaje';

  @override
  String get goalComposition => 'Composición';

  @override
  String get goalLight => 'Luz';

  @override
  String get goalTechnique => 'Técnica de cámara';

  @override
  String get goalEditing => 'Edición';

  @override
  String get profileLanguage => 'Idioma de la aplicación';

  @override
  String get languageDevice => 'Usar el idioma del dispositivo';

  @override
  String get languageManual => 'Elegir un idioma';

  @override
  String get languageSelectionLabel => 'Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Francés';

  @override
  String get languageGerman => 'Alemán';

  @override
  String get languageBrazilianPortuguese => 'Portugués brasileño';

  @override
  String get profileSaveError =>
      'No se pudieron guardar tus preferencias. Inténtalo de nuevo.';

  @override
  String get catalogTitle => 'Explorar catálogo';

  @override
  String get catalogOfflineAvailable => 'Available offline';

  @override
  String get catalogSearchHint => 'Buscar técnicas, consejos y etiquetas';

  @override
  String get catalogSearchSemantics => 'Catalog search field';

  @override
  String get catalogSearchClear => 'Clear search';

  @override
  String get catalogFiltersTitle => 'Filtros';

  @override
  String catalogFiltersButton(int count) {
    return 'Filters ($count)';
  }

  @override
  String get catalogApplyFilters => 'Aplicar';

  @override
  String get catalogCancel => 'Cancelar';

  @override
  String get catalogClearFilters => 'Borrar filtros';

  @override
  String catalogRemoveFilter(String label) {
    return 'Remove $label filter';
  }

  @override
  String get catalogType => 'Type';

  @override
  String get catalogCategory => 'Category';

  @override
  String get catalogDifficulty => 'Difficulty';

  @override
  String get catalogTag => 'Tag';

  @override
  String catalogTypeLabel(String value) {
    return 'Type: $value';
  }

  @override
  String catalogCategoryLabel(String value) {
    return 'Category: $value';
  }

  @override
  String catalogDifficultyLabel(String value) {
    return 'Difficulty: $value';
  }

  @override
  String catalogPremiumLabel(String value) {
    return 'Premium: $value';
  }

  @override
  String catalogTagLabel(String value) {
    return 'Tag: $value';
  }

  @override
  String get catalogPremium => 'Premium';

  @override
  String get catalogPremiumOnly => 'Premium only';

  @override
  String get catalogFreeOnly => 'Free only';

  @override
  String get catalogLoading => 'Loading catalog';

  @override
  String get catalogLoadingMore => 'Loading more';

  @override
  String get catalogLoadMore => 'Cargar más';

  @override
  String get catalogRetry => 'Reintentar';

  @override
  String get catalogRefresh => 'Refresh';

  @override
  String get catalogNextPageError => 'The next page could not be loaded.';

  @override
  String get catalogEndOfResults => 'End of results';

  @override
  String get catalogEmptyTitle => 'No catalog items yet';

  @override
  String get catalogEmptyDescription => 'Install the local seed or try again.';

  @override
  String get catalogNoSearchResultsTitle => 'No search results';

  @override
  String get catalogNoSearchResultsDescription =>
      'Try a different term or clear the search.';

  @override
  String get catalogNoFilterResultsTitle => 'No filtered results';

  @override
  String get catalogNoFilterResultsDescription =>
      'Remove one or more filters to broaden the catalog.';

  @override
  String get catalogErrorTitle => 'Catalog unavailable';

  @override
  String get catalogErrorDescription =>
      'The local catalog could not be loaded.';

  @override
  String catalogCardSemantics(String title) {
    return 'Open $title';
  }

  @override
  String get catalogTypeTip => 'Tip';

  @override
  String get catalogTypeTechnique => 'Technique';

  @override
  String get catalogTypeCuriosity => 'Curiosity';

  @override
  String get catalogTypeIdea => 'Idea';

  @override
  String get catalogTypeCommonMistake => 'Common mistake';

  @override
  String get catalogTypeGuide => 'Guide';

  @override
  String get catalogTypeChecklist => 'Checklist';

  @override
  String get catalogTypeChallenge => 'Challenge';

  @override
  String get catalogTypeGlossary => 'Glossary';

  @override
  String get catalogTypeHistory => 'Photo history';

  @override
  String get catalogCategoryExposure => 'Exposure';

  @override
  String get catalogCategoryPortrait => 'Portrait';

  @override
  String get catalogCategoryComposition => 'Composition';

  @override
  String get catalogCategoryLowLight => 'Low light';

  @override
  String get catalogCategoryColor => 'Color';

  @override
  String get catalogCategoryMotion => 'Motion';

  @override
  String get catalogCategoryGear => 'Gear';

  @override
  String get catalogTagExposure => 'Exposure';

  @override
  String get catalogTagLight => 'Light';

  @override
  String get catalogTagComposition => 'Composition';

  @override
  String get catalogTagStability => 'Stability';

  @override
  String get catalogTagColor => 'Color';

  @override
  String get catalogTagFocus => 'Focus';

  @override
  String get catalogTagMetering => 'Metering';

  @override
  String get catalogTagPractice => 'Practice';

  @override
  String get catalogTagMotion => 'Motion';

  @override
  String get catalogTagMaintenance => 'Maintenance';

  @override
  String get catalogDetailTitle => 'Detalle del contenido';

  @override
  String get catalogDetailBack => 'Volver al catálogo';

  @override
  String get catalogDetailLoading => 'Cargando contenido';

  @override
  String get catalogDetailUnavailableTitle => 'Contenido no disponible';

  @override
  String get catalogDetailUnavailableDescription =>
      'Este contenido no está disponible sin conexión o no se puede publicar.';

  @override
  String get catalogDetailErrorTitle => 'No se puede cargar el detalle';

  @override
  String get catalogDetailErrorDescription =>
      'Intenta leer este contenido de nuevo desde el catálogo sin conexión.';

  @override
  String get catalogDetailSave => 'Guardar';

  @override
  String get catalogDetailSaved => 'Guardado';

  @override
  String get catalogDetailSaveError =>
      'No se pudo actualizar el guardado. Inténtalo de nuevo.';

  @override
  String get catalogDetailOffline => 'Disponible sin conexión';

  @override
  String get catalogDetailSources => 'Fuentes';

  @override
  String catalogDetailAttribution(String value) {
    return 'Atribución: $value';
  }

  @override
  String catalogDetailLicense(String value) {
    return 'Licencia: $value';
  }

  @override
  String catalogDetailRights(String value) {
    return 'Derechos: $value';
  }

  @override
  String get catalogDetailRightsPublishable => 'publicable';

  @override
  String get catalogDetailRightsRestricted => 'restringido';

  @override
  String get catalogDetailRightsUnknown => 'desconocido';

  @override
  String get profileEquipment => 'Equipo fotográfico';

  @override
  String get profileCameraBodies => 'Cuerpos de cámara';

  @override
  String get profileLenses => 'Objetivos';

  @override
  String get profileSmartphones => 'Teléfonos inteligentes';

  @override
  String get equipmentMirrorless => 'Cámara sin espejo';

  @override
  String get equipmentDslr => 'Cámara DSLR';

  @override
  String get equipmentFilm => 'Cámara analógica';

  @override
  String get equipmentPrimeLens => 'Objetivo fijo';

  @override
  String get equipmentZoomLens => 'Objetivo zoom';

  @override
  String get equipmentTelephotoLens => 'Teleobjetivo';

  @override
  String get equipmentIPhone => 'iPhone';

  @override
  String get equipmentAndroid => 'Teléfono Android';

  @override
  String get homeGreeting => 'Your photography, at your pace';

  @override
  String get homeLoading => 'Loading personalised suggestions';

  @override
  String get homeError => 'Something went wrong. Please try again.';

  @override
  String get homeIncompleteProfile =>
      'Complete your profile to refine these suggestions.';

  @override
  String get homeChosenForYou => 'Chosen for you';

  @override
  String get homeImproveIdeas => 'Ideas to improve';

  @override
  String get homeForYourLevel => 'Right for your level';

  @override
  String get homeOpenCatalog => 'Open the full catalog';

  @override
  String get homeEmptyCatalog => 'The offline catalog is currently empty.';

  @override
  String get homeEditorialFallback => 'A useful editorial selection for you';

  @override
  String get homeReasonInterest => 'Chosen for your photography interest';

  @override
  String get homeReasonGoal => 'Can help you reach your learning goal';

  @override
  String get homeReasonLevel => 'Right for your level';

  @override
  String get homeReasonEquipment => 'Compatible with your equipment';

  @override
  String get libraryNoResultsTitle => 'No se encontró contenido';

  @override
  String get libraryNoResultsDescription =>
      'Prueba a cambiar la búsqueda o los filtros.';

  @override
  String get libraryClearFilters => 'Borrar búsqueda y filtros';

  @override
  String get librarySearchHint => 'Buscar contenido y notas';

  @override
  String get librarySearchClear => 'Borrar búsqueda';

  @override
  String get libraryAllStatuses => 'Todos los estados';

  @override
  String get libraryAllCollections => 'Todas las colecciones';

  @override
  String get libraryManageCollections => 'Gestionar colecciones';

  @override
  String get libraryStatusToTry => 'Por probar';

  @override
  String get libraryStatusTried => 'Probado';

  @override
  String get libraryStatusCompleted => 'Completado';

  @override
  String libraryEditItem(String title) {
    return 'Editar $title';
  }

  @override
  String get libraryStatusLabel => 'Estado';

  @override
  String get libraryCollectionLabel => 'Colección';

  @override
  String get libraryNoCollection => 'Sin colección';

  @override
  String get libraryNoteLabel => 'Nota personal';

  @override
  String get libraryRemoveTitle => '¿Quitar contenido guardado?';

  @override
  String get libraryRemoveMessage =>
      'Se eliminarán la nota, el estado y la colección.';

  @override
  String get libraryRemoveAction => 'Quitar';

  @override
  String get libraryCancel => 'Cancelar';

  @override
  String get librarySaveChanges => 'Guardar';

  @override
  String get libraryMutationError =>
      'No se pudo guardar el cambio. Inténtalo de nuevo.';

  @override
  String get libraryNoCollections => 'Aún no hay colecciones.';

  @override
  String libraryCollectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }

  @override
  String get libraryRenameCollection => 'Renombrar colección';

  @override
  String get libraryDeleteCollection => 'Eliminar colección';

  @override
  String get libraryDeleteCollectionMessage =>
      'El contenido guardado seguirá en el archivo sin colección.';

  @override
  String get libraryCreateCollection => 'Nueva colección';

  @override
  String get libraryDone => 'Listo';

  @override
  String get libraryCollectionName => 'Nombre de la colección';

  @override
  String get libraryConfirm => 'Confirmar';

  @override
  String get libraryNoNote => 'Sin nota';
}
