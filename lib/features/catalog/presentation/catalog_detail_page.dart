import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/design/frame_lab_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../library/domain/library_repository.dart';
import '../../library/presentation/library_scope.dart';
import '../../library/presentation/saved_item_controller.dart';
import '../domain/catalog_models.dart';
import 'catalog_detail_controller.dart';
import 'catalog_scope.dart';

class CatalogDetailPage extends StatefulWidget {
  const CatalogDetailPage({required this.contentId, super.key});

  final String? contentId;

  @override
  State<CatalogDetailPage> createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends State<CatalogDetailPage> {
  CatalogDetailController? _controller;
  SavedItemController? _savedItemController;
  LibraryRepository? _libraryRepository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = _localeOf(context);
    final id = widget.contentId;
    if (id == null || id.trim().isEmpty) {
      _replaceSavedItemController(null, null);
      return;
    }
    final controller = _controller;
    if (controller == null || controller.contentId != id) {
      controller?.removeListener(_onChanged);
      controller?.dispose();
      _controller =
          CatalogDetailController(CatalogScope.of(context), id, locale)
            ..addListener(_onChanged)
            ..load();
    } else {
      controller.setLocale(locale);
    }
    final libraryRepository = LibraryScope.maybeOf(context);
    if (_savedItemController == null ||
        _savedItemController!.contentId != id ||
        _libraryRepository != libraryRepository) {
      _replaceSavedItemController(libraryRepository, id);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onChanged);
    _controller?.dispose();
    _savedItemController?.removeListener(_onChanged);
    _savedItemController?.dispose();
    super.dispose();
  }

  void _replaceSavedItemController(
    LibraryRepository? repository,
    String? contentId,
  ) {
    _savedItemController?.removeListener(_onChanged);
    _savedItemController?.dispose();
    _libraryRepository = repository;
    _savedItemController = repository == null || contentId == null
        ? null
        : (SavedItemController(repository, contentId)
            ..addListener(_onChanged)
            ..start());
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = _controller;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.catalogDetailBack,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppDestination.explore.path);
            }
          },
        ),
        title: Text(l10n.catalogDetailTitle),
      ),
      body: SafeArea(
        child: widget.contentId == null || widget.contentId!.trim().isEmpty
            ? _UnavailableState(onRetry: () {}, showRetry: false)
            : controller == null || controller.isLoading
            ? _CenteredStatus(label: l10n.catalogDetailLoading)
            : controller.error != null
            ? _ErrorState(onRetry: controller.retry)
            : controller.notFound || controller.detail == null
            ? _UnavailableState(onRetry: controller.retry)
            : _DetailContent(
                detail: controller.detail!,
                savedItemController: _savedItemController,
              ),
      ),
    );
  }

  LocaleCode _localeOf(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return LocaleCode(
      locale.countryCode == null
          ? locale.languageCode
          : '${locale.languageCode}-${locale.countryCode}',
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.detail, this.savedItemController});

  final CatalogDetail detail;
  final SavedItemController? savedItemController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = detail.content;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(FrameLabSpacing.medium),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: SelectableText(
                    content.translation.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: FrameLabSpacing.small),
                Text(
                  content.translation.summary,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (savedItemController != null) ...[
                  const SizedBox(height: FrameLabSpacing.medium),
                  _SaveToggle(controller: savedItemController!),
                ],
                const SizedBox(height: FrameLabSpacing.medium),
                Wrap(
                  spacing: FrameLabSpacing.small,
                  runSpacing: FrameLabSpacing.xSmall,
                  children: [
                    _chip(_typeLabel(l10n, content.item.type)),
                    _chip(_categoryLabel(l10n, content.item.primaryCategory)),
                    _chip(_difficultyLabel(l10n, content.item.difficulty)),
                    for (final tag in detail.tags)
                      _chip(tag.label ?? _tagLabel(l10n, tag.code)),
                    if (content.item.premium) _chip(l10n.catalogPremium),
                    _chip(l10n.catalogDetailOffline),
                  ],
                ),
                const SizedBox(height: FrameLabSpacing.large),
                SelectableText(content.translation.body),
                const SizedBox(height: FrameLabSpacing.large),
                Text(
                  l10n.catalogDetailSources,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: FrameLabSpacing.small),
                for (final source in detail.sources)
                  _SourceTile(source: source),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String label) => Chip(label: Text(label));
}

class _SaveToggle extends StatelessWidget {
  const _SaveToggle({required this.controller});

  final SavedItemController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = controller.isSaved
        ? l10n.catalogDetailSaved
        : l10n.catalogDetailSave;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: label,
          button: true,
          enabled: controller.canToggle,
          excludeSemantics: true,
          child: Tooltip(
            message: label,
            child: OutlinedButton.icon(
              key: const ValueKey('catalog-detail-save-toggle'),
              onPressed: controller.canToggle ? controller.toggle : null,
              icon: Icon(
                controller.isSaved ? Icons.bookmark : Icons.bookmark_outline,
              ),
              label: Text(label),
            ),
          ),
        ),
        if (controller.error != null) ...[
          const SizedBox(height: FrameLabSpacing.xSmall),
          Text(
            l10n.catalogDetailSaveError,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.source});
  final ContentSource source;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(FrameLabSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(source.title, style: Theme.of(context).textTheme.titleMedium),
            if (source.author != null)
              Text(l10n.catalogDetailAttribution(source.author!)),
            if (source.attributionText != null)
              Text(l10n.catalogDetailAttribution(source.attributionText!)),
            Text(l10n.catalogDetailLicense(source.licenseType)),
            Text(
              l10n.catalogDetailRights(_rightsLabel(l10n, source.rightsStatus)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenteredStatus extends StatelessWidget {
  const _CenteredStatus({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Center(
    child: Semantics(
      label: label,
      liveRegion: true,
      child: const CircularProgressIndicator(),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StateMessage(
      title: l10n.catalogDetailErrorTitle,
      description: l10n.catalogDetailErrorDescription,
      onRetry: onRetry,
    );
  }
}

class _UnavailableState extends StatelessWidget {
  const _UnavailableState({required this.onRetry, this.showRetry = true});
  final VoidCallback onRetry;
  final bool showRetry;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StateMessage(
      title: l10n.catalogDetailUnavailableTitle,
      description: l10n.catalogDetailUnavailableDescription,
      onRetry: onRetry,
      showRetry: showRetry,
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.title,
    required this.description,
    required this.onRetry,
    this.showRetry = true,
  });
  final String title;
  final String description;
  final VoidCallback onRetry;
  final bool showRetry;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FrameLabSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: FrameLabSpacing.small),
            Text(description, textAlign: TextAlign.center),
            if (showRetry) ...[
              const SizedBox(height: FrameLabSpacing.medium),
              FilledButton(onPressed: onRetry, child: Text(l10n.catalogRetry)),
            ],
          ],
        ),
      ),
    );
  }
}

String _typeLabel(AppLocalizations l10n, ContentType type) => switch (type) {
  ContentType.tip => l10n.catalogTypeTip,
  ContentType.technique => l10n.catalogTypeTechnique,
  ContentType.curiosity => l10n.catalogTypeCuriosity,
  ContentType.idea => l10n.catalogTypeIdea,
  ContentType.commonMistake => l10n.catalogTypeCommonMistake,
  ContentType.guide => l10n.catalogTypeGuide,
  ContentType.checklist => l10n.catalogTypeChecklist,
  ContentType.challenge => l10n.catalogTypeChallenge,
  ContentType.glossary => l10n.catalogTypeGlossary,
  ContentType.photographicHistory => l10n.catalogTypeHistory,
};
String _difficultyLabel(AppLocalizations l10n, Difficulty difficulty) =>
    switch (difficulty) {
      Difficulty.beginner => l10n.skillBeginner,
      Difficulty.intermediate => l10n.skillIntermediate,
      Difficulty.advanced => l10n.skillAdvanced,
    };
String _categoryLabel(AppLocalizations l10n, String category) =>
    switch (category) {
      'exposure' => l10n.catalogCategoryExposure,
      'portrait' => l10n.catalogCategoryPortrait,
      'composition' => l10n.catalogCategoryComposition,
      'low-light' => l10n.catalogCategoryLowLight,
      'color' => l10n.catalogCategoryColor,
      'motion' => l10n.catalogCategoryMotion,
      'gear' => l10n.catalogCategoryGear,
      _ => category,
    };
String _tagLabel(AppLocalizations l10n, String tag) => switch (tag) {
  'exposure' => l10n.catalogTagExposure,
  'light' => l10n.catalogTagLight,
  'composition' => l10n.catalogTagComposition,
  'stability' => l10n.catalogTagStability,
  'color' => l10n.catalogTagColor,
  'focus' => l10n.catalogTagFocus,
  'metering' => l10n.catalogTagMetering,
  'practice' => l10n.catalogTagPractice,
  'motion' => l10n.catalogTagMotion,
  'maintenance' => l10n.catalogTagMaintenance,
  _ => tag,
};
String _rightsLabel(AppLocalizations l10n, RightsStatus status) =>
    switch (status) {
      RightsStatus.publishable => l10n.catalogDetailRightsPublishable,
      RightsStatus.restricted => l10n.catalogDetailRightsRestricted,
      RightsStatus.unknown => l10n.catalogDetailRightsUnknown,
    };
