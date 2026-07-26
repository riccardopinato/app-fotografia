import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/design/frame_lab_tokens.dart';
import '../../../core/widgets/frame_lab_empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/catalog_scope.dart';
import 'library_controller.dart';
import 'library_scope.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  LibraryController? _controller;
  Object? _libraryRepository;
  Object? _catalogRepository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final libraryRepository = LibraryScope.of(context);
    final catalogRepository = CatalogScope.of(context);
    final locale = _localeOf(context);
    if (_controller == null ||
        _libraryRepository != libraryRepository ||
        _catalogRepository != catalogRepository) {
      _controller?.removeListener(_onChanged);
      _controller?.dispose();
      _libraryRepository = libraryRepository;
      _catalogRepository = catalogRepository;
      _controller =
          LibraryController(libraryRepository, catalogRepository, locale)
            ..addListener(_onChanged)
            ..start();
    } else {
      _controller!.setLocale(locale);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onChanged);
    _controller?.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = _controller;
    return SafeArea(
      top: false,
      child: controller == null || controller.isLoading
          ? _CenteredStatus(label: l10n.libraryLoading)
          : controller.error != null
          ? _LibraryError(onRetry: controller.retry)
          : controller.entries.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(FrameLabSpacing.medium),
              child: FrameLabEmptyState(
                icon: Icons.bookmark_outline,
                title: l10n.libraryEmptyTitle,
                description: l10n.libraryEmptyDescription,
              ),
            )
          : ListView.separated(
              key: const ValueKey('library-list'),
              padding: const EdgeInsets.all(FrameLabSpacing.medium),
              itemCount: controller.entries.length + 1,
              separatorBuilder: (_, index) => index == 0
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: FrameLabSpacing.medium,
                    ),
                    child: Semantics(
                      header: true,
                      child: Text(
                        l10n.navLibrary,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  );
                }
                return _LibraryCard(entry: controller.entries[index - 1]);
              },
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

class _LibraryCard extends StatelessWidget {
  const _LibraryCard({required this.entry});

  final LibraryEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = entry.content;
    return Semantics(
      button: true,
      label: l10n.libraryCardSemantics(content.translation.title),
      excludeSemantics: true,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(FrameLabRadii.card),
          onTap: () => context.goNamed(
            AppRoutes.exploreContentName,
            pathParameters: {'contentId': content.item.id},
          ),
          child: Padding(
            padding: const EdgeInsets.all(FrameLabSpacing.medium),
            child: Row(
              children: [
                const Icon(Icons.bookmark),
                const SizedBox(width: FrameLabSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.translation.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: FrameLabSpacing.xSmall),
                      Text(
                        content.translation.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: FrameLabSpacing.small),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
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

class _LibraryError extends StatelessWidget {
  const _LibraryError({required this.onRetry});

  final VoidCallback onRetry;

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
              l10n.libraryErrorTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: FrameLabSpacing.small),
            Text(l10n.libraryErrorDescription, textAlign: TextAlign.center),
            const SizedBox(height: FrameLabSpacing.medium),
            FilledButton(onPressed: onRetry, child: Text(l10n.catalogRetry)),
          ],
        ),
      ),
    );
  }
}
