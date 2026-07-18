import 'package:flutter/material.dart';

import '../../../core/design/frame_lab_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/catalog_models.dart';
import 'catalog_controller.dart';
import 'catalog_scope.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final CatalogController _controller;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = _localeOf(context);
    if (!mounted || !(_initialized)) {
      _controller = CatalogController(CatalogScope.of(context), locale)
        ..loadInitial();
      _controller.addListener(_onControllerChanged);
      _initialized = true;
    } else {
      _controller.setLocale(locale);
    }
  }

  bool _initialized = false;

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: _controller.refresh,
        child: CustomScrollView(
          key: const ValueKey('catalog-scroll'),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(FrameLabSpacing.medium),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.catalogTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: FrameLabSpacing.xSmall),
                    Text(l10n.catalogOfflineAvailable),
                    const SizedBox(height: FrameLabSpacing.medium),
                    _SearchAndFilterBar(
                      controller: _controller,
                      searchController: _searchController,
                    ),
                    const SizedBox(height: FrameLabSpacing.small),
                    _ActiveFilterChips(controller: _controller),
                  ],
                ),
              ),
            ),
            if (_controller.isInitialLoading)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _CenteredStatus(
                  label: l10n.catalogLoading,
                  child: const CircularProgressIndicator(),
                ),
              )
            else if (_controller.initialError != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _RetryState(
                  title: l10n.catalogErrorTitle,
                  description: l10n.catalogErrorDescription,
                  onRetry: _controller.retryInitial,
                ),
              )
            else if (_controller.items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyCatalogState(controller: _controller),
              )
            else ...[
              _CatalogGrid(controller: _controller),
              SliverPadding(
                padding: const EdgeInsets.all(FrameLabSpacing.medium),
                sliver: SliverToBoxAdapter(
                  child: _PagingFooter(controller: _controller),
                ),
              ),
            ],
          ],
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

class _SearchAndFilterBar extends StatelessWidget {
  const _SearchAndFilterBar({
    required this.controller,
    required this.searchController,
  });

  final CatalogController controller;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Semantics(
            label: l10n.catalogSearchSemantics,
            textField: true,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: l10n.catalogSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.catalogSearchClear,
                        onPressed: () {
                          searchController.clear();
                          controller.clearQuery();
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
              textInputAction: TextInputAction.search,
              onChanged: controller.setQuery,
            ),
          ),
        ),
        const SizedBox(width: FrameLabSpacing.small),
        Badge.count(
          count: controller.activeFilterCount,
          isLabelVisible: controller.hasActiveFilters,
          child: OutlinedButton.icon(
            onPressed: () => _openFilters(context, controller),
            icon: const Icon(Icons.tune),
            label: Text(
              l10n.catalogFiltersButton(controller.activeFilterCount),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActiveFilterChips extends StatelessWidget {
  const _ActiveFilterChips({required this.controller});
  final CatalogController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chips = <Widget>[];
    final filter = controller.filter;
    if (filter.type != null) {
      chips.add(
        _chip(
          context,
          l10n.catalogTypeLabel(_contentTypeLabel(l10n, filter.type!)),
          () => controller.removeFilter('type'),
        ),
      );
    }
    if (filter.category != null) {
      chips.add(
        _chip(
          context,
          l10n.catalogCategoryLabel(_categoryLabel(l10n, filter.category!)),
          () => controller.removeFilter('category'),
        ),
      );
    }
    if (filter.difficulty != null) {
      chips.add(
        _chip(
          context,
          l10n.catalogDifficultyLabel(
            _difficultyLabel(l10n, filter.difficulty!),
          ),
          () => controller.removeFilter('difficulty'),
        ),
      );
    }
    if (filter.premium != null) {
      chips.add(
        _chip(
          context,
          l10n.catalogPremiumLabel(
            filter.premium! ? l10n.catalogPremiumOnly : l10n.catalogFreeOnly,
          ),
          () => controller.removeFilter('premium'),
        ),
      );
    }
    if (filter.tagCode != null) {
      chips.add(
        _chip(
          context,
          l10n.catalogTagLabel(_tagLabel(l10n, filter.tagCode!)),
          () => controller.removeFilter('tag'),
        ),
      );
    }
    if (chips.isEmpty) return const SizedBox.shrink();
    chips.add(
      ActionChip(
        label: Text(l10n.catalogClearFilters),
        onPressed: controller.clearFilters,
      ),
    );
    return Wrap(
      spacing: FrameLabSpacing.small,
      runSpacing: FrameLabSpacing.xSmall,
      children: chips,
    );
  }

  Widget _chip(BuildContext context, String label, VoidCallback onDeleted) {
    final l10n = AppLocalizations.of(context)!;
    return InputChip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteButtonTooltipMessage: l10n.catalogRemoveFilter(label),
    );
  }
}

class _CatalogGrid extends StatelessWidget {
  const _CatalogGrid({required this.controller});
  final CatalogController controller;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final columns = width >= 1000
            ? 3
            : width >= FrameLabLayout.railBreakpoint
            ? 2
            : 1;
        return SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: FrameLabSpacing.medium,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: FrameLabSpacing.medium,
              crossAxisSpacing: FrameLabSpacing.medium,
              childAspectRatio: columns == 1 ? 1.25 : 1.1,
            ),
            itemCount: controller.items.length,
            itemBuilder: (context, index) =>
                _CatalogCard(content: controller.items[index]),
          ),
        );
      },
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({required this.content});
  final LocalizedContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final item = content.item;
    return Semantics(
      button: true,
      label: l10n.catalogCardSemantics(content.translation.title),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(FrameLabSpacing.medium),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          content.translation.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.premium)
                        const SizedBox(width: FrameLabSpacing.xSmall),
                      if (item.premium) Chip(label: Text(l10n.catalogPremium)),
                    ],
                  ),
                  const SizedBox(height: FrameLabSpacing.xSmall),
                  Text(
                    content.translation.summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: FrameLabSpacing.small),
                  Wrap(
                    spacing: FrameLabSpacing.xSmall,
                    runSpacing: FrameLabSpacing.xSmall,
                    children: [
                      _meta(context, _contentTypeLabel(l10n, item.type)),
                      _meta(
                        context,
                        _categoryLabel(l10n, item.primaryCategory),
                      ),
                      _meta(context, _difficultyLabel(l10n, item.difficulty)),
                      for (final tag in content.tags.take(2))
                        _meta(context, _tagLabel(l10n, tag.code)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _meta(BuildContext context, String label) =>
      Chip(visualDensity: VisualDensity.compact, label: Text(label));
}

class _PagingFooter extends StatelessWidget {
  const _PagingFooter({required this.controller});
  final CatalogController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (controller.isLoadingMore) {
      return _CenteredStatus(
        label: l10n.catalogLoadingMore,
        child: const CircularProgressIndicator(),
      );
    }
    if (controller.nextPageError != null) {
      return Column(
        children: [
          Text(l10n.catalogNextPageError),
          const SizedBox(height: FrameLabSpacing.small),
          OutlinedButton(
            onPressed: controller.retryNextPage,
            child: Text(l10n.catalogRetry),
          ),
        ],
      );
    }
    if (!controller.hasMore) {
      return Text(l10n.catalogEndOfResults, textAlign: TextAlign.center);
    }
    return Center(
      child: FilledButton(
        onPressed: controller.loadNextPage,
        child: Text(l10n.catalogLoadMore),
      ),
    );
  }
}

class _EmptyCatalogState extends StatelessWidget {
  const _EmptyCatalogState({required this.controller});
  final CatalogController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasQuery = controller.query.trim().isNotEmpty;
    final hasFilters = controller.hasActiveFilters;
    final title = hasQuery
        ? l10n.catalogNoSearchResultsTitle
        : hasFilters
        ? l10n.catalogNoFilterResultsTitle
        : l10n.catalogEmptyTitle;
    final description = hasQuery
        ? l10n.catalogNoSearchResultsDescription
        : hasFilters
        ? l10n.catalogNoFilterResultsDescription
        : l10n.catalogEmptyDescription;
    return _RetryState(
      title: title,
      description: description,
      onRetry: controller.refresh,
      retryLabel: l10n.catalogRefresh,
    );
  }
}

class _RetryState extends StatelessWidget {
  const _RetryState({
    required this.title,
    required this.description,
    required this.onRetry,
    this.retryLabel,
  });
  final String title;
  final String description;
  final VoidCallback onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FrameLabSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: FrameLabSpacing.small),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: FrameLabSpacing.medium),
            FilledButton(
              onPressed: onRetry,
              child: Text(retryLabel ?? l10n.catalogRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenteredStatus extends StatelessWidget {
  const _CenteredStatus({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: Semantics(
      label: label,
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.all(FrameLabSpacing.large),
        child: child,
      ),
    ),
  );
}

Future<void> _openFilters(
  BuildContext context,
  CatalogController controller,
) async {
  final l10n = AppLocalizations.of(context)!;
  var draft = controller.filter;
  final result = await showModalBottomSheet<CatalogFilter>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(FrameLabSpacing.medium),
          shrinkWrap: true,
          children: [
            Text(
              l10n.catalogFiltersTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: FrameLabSpacing.medium),
            _choiceSection<ContentType>(
              context,
              title: l10n.catalogType,
              values: ContentType.values,
              selected: draft.type,
              label: (value) => _contentTypeLabel(l10n, value),
              onSelected: (value) => setState(
                () => draft = CatalogFilter(
                  type: value == draft.type ? null : value,
                  category: draft.category,
                  difficulty: draft.difficulty,
                  premium: draft.premium,
                  tagCode: draft.tagCode,
                ),
              ),
            ),
            _choiceSection<String>(
              context,
              title: l10n.catalogCategory,
              values: _catalogCategories,
              selected: draft.category,
              label: (value) => _categoryLabel(l10n, value),
              onSelected: (value) => setState(
                () => draft = CatalogFilter(
                  type: draft.type,
                  category: value == draft.category ? null : value,
                  difficulty: draft.difficulty,
                  premium: draft.premium,
                  tagCode: draft.tagCode,
                ),
              ),
            ),
            _choiceSection<Difficulty>(
              context,
              title: l10n.catalogDifficulty,
              values: Difficulty.values,
              selected: draft.difficulty,
              label: (value) => _difficultyLabel(l10n, value),
              onSelected: (value) => setState(
                () => draft = CatalogFilter(
                  type: draft.type,
                  category: draft.category,
                  difficulty: value == draft.difficulty ? null : value,
                  premium: draft.premium,
                  tagCode: draft.tagCode,
                ),
              ),
            ),
            _choiceSection<bool>(
              context,
              title: l10n.catalogPremium,
              values: const [false, true],
              selected: draft.premium,
              label: (value) =>
                  value ? l10n.catalogPremiumOnly : l10n.catalogFreeOnly,
              onSelected: (value) => setState(
                () => draft = CatalogFilter(
                  type: draft.type,
                  category: draft.category,
                  difficulty: draft.difficulty,
                  premium: value == draft.premium ? null : value,
                  tagCode: draft.tagCode,
                ),
              ),
            ),
            _choiceSection<String>(
              context,
              title: l10n.catalogTag,
              values: _catalogTags,
              selected: draft.tagCode,
              label: (value) => _tagLabel(l10n, value),
              onSelected: (value) => setState(
                () => draft = CatalogFilter(
                  type: draft.type,
                  category: draft.category,
                  difficulty: draft.difficulty,
                  premium: draft.premium,
                  tagCode: value == draft.tagCode ? null : value,
                ),
              ),
            ),
            const SizedBox(height: FrameLabSpacing.medium),
            Row(
              children: [
                TextButton(
                  onPressed: () =>
                      setState(() => draft = const CatalogFilter()),
                  child: Text(l10n.catalogClearFilters),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.catalogCancel),
                ),
                const SizedBox(width: FrameLabSpacing.small),
                FilledButton(
                  onPressed: () => Navigator.pop(context, draft),
                  child: Text(l10n.catalogApplyFilters),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  if (result != null) controller.setFilter(result);
}

Widget _choiceSection<T>(
  BuildContext context, {
  required String title,
  required List<T> values,
  required T? selected,
  required String Function(T value) label,
  required ValueChanged<T> onSelected,
}) => Padding(
  padding: const EdgeInsets.only(bottom: FrameLabSpacing.medium),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: FrameLabSpacing.small),
      Wrap(
        spacing: FrameLabSpacing.small,
        runSpacing: FrameLabSpacing.xSmall,
        children: [
          for (final value in values)
            FilterChip(
              label: Text(label(value)),
              selected: selected == value,
              onSelected: (_) => onSelected(value),
            ),
        ],
      ),
    ],
  ),
);

const _catalogCategories = <String>[
  'exposure',
  'portrait',
  'composition',
  'low-light',
  'color',
  'motion',
  'gear',
];
const _catalogTags = <String>[
  'exposure',
  'light',
  'composition',
  'stability',
  'color',
  'focus',
  'metering',
  'practice',
  'motion',
  'maintenance',
];

String _contentTypeLabel(AppLocalizations l10n, ContentType type) =>
    switch (type) {
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
