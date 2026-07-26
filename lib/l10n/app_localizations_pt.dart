// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'FrameLab';

  @override
  String get navHome => 'Início';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navIdeas => 'Ideias';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navProfile => 'Perfil';

  @override
  String get homePlaceholderTitle =>
      'Seu espaço fotográfico está tomando forma';

  @override
  String get homePlaceholderDescription =>
      'A experiência inicial chegará em uma atualização futura.';

  @override
  String get explorePlaceholderTitle => 'Explorar em breve';

  @override
  String get explorePlaceholderDescription =>
      'Conteúdo fotográfico para descobrir aparecerá aqui.';

  @override
  String get ideasPlaceholderTitle => 'Ideias em breve';

  @override
  String get ideasPlaceholderDescription =>
      'Sugestões fotográficas personalizadas aparecerão aqui.';

  @override
  String get libraryPlaceholderTitle => 'Sua biblioteca em breve';

  @override
  String get libraryPlaceholderDescription =>
      'Inspirações e notas salvas aparecerão aqui.';

  @override
  String get libraryLoading => 'A carregar conteúdo guardado';

  @override
  String get libraryEmptyTitle => 'Ainda não há conteúdo guardado';

  @override
  String get libraryEmptyDescription =>
      'Guarde conteúdo do catálogo para o encontrar aqui.';

  @override
  String get libraryErrorTitle => 'Arquivo indisponível';

  @override
  String get libraryErrorDescription =>
      'Tente carregar novamente o conteúdo guardado.';

  @override
  String libraryCardSemantics(String title) {
    return 'Abrir conteúdo guardado: $title';
  }

  @override
  String get profilePlaceholderTitle => 'Seu perfil em breve';

  @override
  String get profilePlaceholderDescription =>
      'Suas preferências e jornada fotográfica aparecerão aqui.';

  @override
  String get navigationLabel => 'Navegação principal';

  @override
  String get onboardingTitle => 'Configure o seu perfil de fotografia';

  @override
  String get onboardingDescription =>
      'Escolha preferências que pode alterar a qualquer momento.';

  @override
  String get onboardingContinue => 'Guardar preferências';

  @override
  String get profileTitle => 'O seu perfil';

  @override
  String get profileDescription =>
      'Estas preferências orientarão sugestões futuras.';

  @override
  String get profileSave => 'Guardar alterações';

  @override
  String get profileSkillLevel => 'Nível de experiência';

  @override
  String get skillBeginner => 'Iniciante';

  @override
  String get skillIntermediate => 'Intermédio';

  @override
  String get skillAdvanced => 'Avançado';

  @override
  String get profileTopics => 'Interesses fotográficos';

  @override
  String get topicPortrait => 'Retrato';

  @override
  String get topicLandscape => 'Paisagem';

  @override
  String get topicStreet => 'Street';

  @override
  String get topicMacro => 'Macro';

  @override
  String get topicNight => 'Fotografia noturna';

  @override
  String get topicSmartphone => 'Smartphone';

  @override
  String get profileLearningGoals => 'Objetivos de aprendizagem';

  @override
  String get goalComposition => 'Composição';

  @override
  String get goalLight => 'Luz';

  @override
  String get goalTechnique => 'Técnica de câmara';

  @override
  String get goalEditing => 'Edição';

  @override
  String get profileLanguage => 'Idioma da aplicação';

  @override
  String get languageDevice => 'Usar o idioma do dispositivo';

  @override
  String get languageManual => 'Escolher um idioma';

  @override
  String get languageSelectionLabel => 'Idioma';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageSpanish => 'Espanhol';

  @override
  String get languageFrench => 'Francês';

  @override
  String get languageGerman => 'Alemão';

  @override
  String get languageBrazilianPortuguese => 'Português brasileiro';

  @override
  String get profileSaveError =>
      'Não foi possível guardar as suas preferências. Tente novamente.';

  @override
  String get catalogTitle => 'Explorar catálogo';

  @override
  String get catalogOfflineAvailable => 'Available offline';

  @override
  String get catalogSearchHint => 'Pesquisar técnicas, dicas e etiquetas';

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
  String get catalogClearFilters => 'Limpar filtros';

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
  String get catalogLoadMore => 'Carregar mais';

  @override
  String get catalogRetry => 'Tentar novamente';

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
  String get catalogDetailTitle => 'Detalhe do conteúdo';

  @override
  String get catalogDetailBack => 'Voltar ao catálogo';

  @override
  String get catalogDetailLoading => 'A carregar conteúdo';

  @override
  String get catalogDetailUnavailableTitle => 'Conteúdo indisponível';

  @override
  String get catalogDetailUnavailableDescription =>
      'Este conteúdo não está disponível offline ou não é publicável.';

  @override
  String get catalogDetailErrorTitle => 'Não foi possível carregar o detalhe';

  @override
  String get catalogDetailErrorDescription =>
      'Tenta ler novamente este conteúdo a partir do catálogo offline.';

  @override
  String get catalogDetailSave => 'Guardar';

  @override
  String get catalogDetailSaved => 'Guardado';

  @override
  String get catalogDetailSaveError =>
      'Não foi possível atualizar o estado guardado. Tente novamente.';

  @override
  String get catalogDetailOffline => 'Disponível offline';

  @override
  String get catalogDetailSources => 'Fontes';

  @override
  String catalogDetailAttribution(String value) {
    return 'Atribuição: $value';
  }

  @override
  String catalogDetailLicense(String value) {
    return 'Licença: $value';
  }

  @override
  String catalogDetailRights(String value) {
    return 'Direitos: $value';
  }

  @override
  String get catalogDetailRightsPublishable => 'publicável';

  @override
  String get catalogDetailRightsRestricted => 'restrito';

  @override
  String get catalogDetailRightsUnknown => 'desconhecido';

  @override
  String get profileEquipment => 'Equipamento fotográfico';

  @override
  String get profileCameraBodies => 'Corpos de câmara';

  @override
  String get profileLenses => 'Objetivas';

  @override
  String get profileSmartphones => 'Smartphones';

  @override
  String get equipmentMirrorless => 'Câmara mirrorless';

  @override
  String get equipmentDslr => 'Câmara DSLR';

  @override
  String get equipmentFilm => 'Câmara analógica';

  @override
  String get equipmentPrimeLens => 'Objetiva fixa';

  @override
  String get equipmentZoomLens => 'Objetiva zoom';

  @override
  String get equipmentTelephotoLens => 'Teleobjetiva';

  @override
  String get equipmentIPhone => 'iPhone';

  @override
  String get equipmentAndroid => 'Telemóvel Android';

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
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'FrameLab';

  @override
  String get navHome => 'Início';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navIdeas => 'Ideias';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navProfile => 'Perfil';

  @override
  String get homePlaceholderTitle =>
      'Seu espaço fotográfico está tomando forma';

  @override
  String get homePlaceholderDescription =>
      'A experiência inicial chegará em uma atualização futura.';

  @override
  String get explorePlaceholderTitle => 'Explorar em breve';

  @override
  String get explorePlaceholderDescription =>
      'Conteúdo fotográfico para descobrir aparecerá aqui.';

  @override
  String get ideasPlaceholderTitle => 'Ideias em breve';

  @override
  String get ideasPlaceholderDescription =>
      'Sugestões fotográficas personalizadas aparecerão aqui.';

  @override
  String get libraryPlaceholderTitle => 'Sua biblioteca em breve';

  @override
  String get libraryPlaceholderDescription =>
      'Inspirações e notas salvas aparecerão aqui.';

  @override
  String get libraryLoading => 'Carregando conteúdo salvo';

  @override
  String get libraryEmptyTitle => 'Nenhum conteúdo salvo';

  @override
  String get libraryEmptyDescription =>
      'Salve conteúdo do catálogo para encontrá-lo aqui.';

  @override
  String get libraryErrorTitle => 'Arquivo indisponível';

  @override
  String get libraryErrorDescription =>
      'Tente carregar novamente o conteúdo salvo.';

  @override
  String libraryCardSemantics(String title) {
    return 'Abrir conteúdo salvo: $title';
  }

  @override
  String get profilePlaceholderTitle => 'Seu perfil em breve';

  @override
  String get profilePlaceholderDescription =>
      'Suas preferências e jornada fotográfica aparecerão aqui.';

  @override
  String get navigationLabel => 'Navegação principal';

  @override
  String get onboardingTitle => 'Configure seu perfil de fotografia';

  @override
  String get onboardingDescription =>
      'Escolha preferências que você pode mudar a qualquer momento.';

  @override
  String get onboardingContinue => 'Salvar preferências';

  @override
  String get profileTitle => 'Seu perfil';

  @override
  String get profileDescription =>
      'Estas preferências orientarão sugestões futuras.';

  @override
  String get profileSave => 'Salvar alterações';

  @override
  String get profileSkillLevel => 'Nível de experiência';

  @override
  String get skillBeginner => 'Iniciante';

  @override
  String get skillIntermediate => 'Intermediário';

  @override
  String get skillAdvanced => 'Avançado';

  @override
  String get profileTopics => 'Interesses fotográficos';

  @override
  String get topicPortrait => 'Retrato';

  @override
  String get topicLandscape => 'Paisagem';

  @override
  String get topicStreet => 'Street';

  @override
  String get topicMacro => 'Macro';

  @override
  String get topicNight => 'Fotografia noturna';

  @override
  String get topicSmartphone => 'Smartphone';

  @override
  String get profileLearningGoals => 'Objetivos de aprendizagem';

  @override
  String get goalComposition => 'Composição';

  @override
  String get goalLight => 'Luz';

  @override
  String get goalTechnique => 'Técnica de câmera';

  @override
  String get goalEditing => 'Edição';

  @override
  String get profileLanguage => 'Idioma do aplicativo';

  @override
  String get languageDevice => 'Usar o idioma do dispositivo';

  @override
  String get languageManual => 'Escolher um idioma';

  @override
  String get languageSelectionLabel => 'Idioma';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageSpanish => 'Espanhol';

  @override
  String get languageFrench => 'Francês';

  @override
  String get languageGerman => 'Alemão';

  @override
  String get languageBrazilianPortuguese => 'Português brasileiro';

  @override
  String get profileSaveError =>
      'Não foi possível salvar suas preferências. Tente novamente.';

  @override
  String get catalogTitle => 'Explorar catálogo';

  @override
  String get catalogOfflineAvailable => 'Available offline';

  @override
  String get catalogSearchHint => 'Pesquisar técnicas, dicas e tags';

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
  String get catalogClearFilters => 'Limpar filtros';

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
  String get catalogLoadMore => 'Carregar mais';

  @override
  String get catalogRetry => 'Tentar novamente';

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
  String get catalogDetailTitle => 'Detalhe do conteúdo';

  @override
  String get catalogDetailBack => 'Voltar ao catálogo';

  @override
  String get catalogDetailLoading => 'Carregando conteúdo';

  @override
  String get catalogDetailUnavailableTitle => 'Conteúdo indisponível';

  @override
  String get catalogDetailUnavailableDescription =>
      'Este conteúdo não está disponível offline ou não pode ser publicado.';

  @override
  String get catalogDetailErrorTitle => 'Não foi possível carregar o detalhe';

  @override
  String get catalogDetailErrorDescription =>
      'Tente abrir este conteúdo novamente pelo catálogo offline.';

  @override
  String get catalogDetailSave => 'Salvar';

  @override
  String get catalogDetailSaved => 'Salvo';

  @override
  String get catalogDetailSaveError =>
      'Não foi possível atualizar o estado salvo. Tente novamente.';

  @override
  String get catalogDetailOffline => 'Disponível offline';

  @override
  String get catalogDetailSources => 'Fontes';

  @override
  String catalogDetailAttribution(String value) {
    return 'Atribuição: $value';
  }

  @override
  String catalogDetailLicense(String value) {
    return 'Licença: $value';
  }

  @override
  String catalogDetailRights(String value) {
    return 'Direitos: $value';
  }

  @override
  String get catalogDetailRightsPublishable => 'publicável';

  @override
  String get catalogDetailRightsRestricted => 'restrito';

  @override
  String get catalogDetailRightsUnknown => 'desconhecido';

  @override
  String get profileEquipment => 'Equipamento fotográfico';

  @override
  String get profileCameraBodies => 'Corpos de câmera';

  @override
  String get profileLenses => 'Lentes';

  @override
  String get profileSmartphones => 'Smartphones';

  @override
  String get equipmentMirrorless => 'Câmera mirrorless';

  @override
  String get equipmentDslr => 'Câmera DSLR';

  @override
  String get equipmentFilm => 'Câmera analógica';

  @override
  String get equipmentPrimeLens => 'Lente fixa';

  @override
  String get equipmentZoomLens => 'Lente zoom';

  @override
  String get equipmentTelephotoLens => 'Teleobjetiva';

  @override
  String get equipmentIPhone => 'iPhone';

  @override
  String get equipmentAndroid => 'Telefone Android';

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
}
