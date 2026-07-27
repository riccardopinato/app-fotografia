import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/design/frame_lab_tokens.dart';
import '../../../core/widgets/frame_lab_empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/catalog_scope.dart';
import '../domain/library_models.dart';
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
  final _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!mounted) return;
    setState(() {});
    if (_controller?.mutationError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _controller?.mutationError == null) return;
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.libraryMutationError)));
        _controller?.clearMutationError();
      });
    }
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
          : CustomScrollView(
              key: const ValueKey('library-list'),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(FrameLabSpacing.medium),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            l10n.navLibrary,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: FrameLabSpacing.medium),
                        _LibraryControls(
                          controller: controller,
                          searchController: _searchController,
                          onManageCollections: () =>
                              _showCollectionManager(context, controller),
                        ),
                      ],
                    ),
                  ),
                ),
                if (controller.entries.isEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 360,
                      child: Padding(
                        padding: const EdgeInsets.all(FrameLabSpacing.medium),
                        child: FrameLabEmptyState(
                          icon: controller.hasSavedItems
                              ? Icons.search_off
                              : Icons.bookmark_outline,
                          title: controller.hasSavedItems
                              ? l10n.libraryNoResultsTitle
                              : l10n.libraryEmptyTitle,
                          description: controller.hasSavedItems
                              ? l10n.libraryNoResultsDescription
                              : l10n.libraryEmptyDescription,
                          action: controller.hasActiveFilters
                              ? TextButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    controller.clearFilters();
                                  },
                                  child: Text(l10n.libraryClearFilters),
                                )
                              : null,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      FrameLabSpacing.medium,
                      0,
                      FrameLabSpacing.medium,
                      FrameLabSpacing.large,
                    ),
                    sliver: SliverList.separated(
                      itemCount: controller.entries.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: FrameLabSpacing.small),
                      itemBuilder: (context, index) => _LibraryCard(
                        entry: controller.entries[index],
                        collectionName: controller.collections
                            .where(
                              (value) =>
                                  value.collection.id ==
                                  controller
                                      .entries[index]
                                      .savedItem
                                      .collectionId,
                            )
                            .firstOrNull
                            ?.collection
                            .name,
                        busy: controller.isBusy(
                          controller.entries[index].savedItem.contentId,
                        ),
                        onEdit: () => _showItemEditor(
                          context,
                          controller,
                          controller.entries[index],
                        ),
                      ),
                    ),
                  ),
              ],
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

class _LibraryControls extends StatelessWidget {
  const _LibraryControls({
    required this.controller,
    required this.searchController,
    required this.onManageCollections,
  });

  final LibraryController controller;
  final TextEditingController searchController;
  final VoidCallback onManageCollections;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: l10n.librarySearchHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: controller.query.isEmpty
                ? null
                : IconButton(
                    tooltip: l10n.librarySearchClear,
                    onPressed: () {
                      searchController.clear();
                      controller.setQuery('');
                    },
                    icon: const Icon(Icons.clear),
                  ),
          ),
          onChanged: controller.setQuery,
        ),
        const SizedBox(height: FrameLabSpacing.small),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<SavedItemStatus?>(
              isExpanded: true,
              value: controller.statusFilter,
              hint: Text(l10n.libraryAllStatuses),
              onChanged: controller.setStatusFilter,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.libraryAllStatuses),
                ),
                for (final status in SavedItemStatus.values)
                  DropdownMenuItem(
                    value: status,
                    child: Text(_statusLabel(l10n, status)),
                  ),
              ],
            ),
            DropdownButton<String?>(
              isExpanded: true,
              value: controller.collectionFilter,
              hint: Text(l10n.libraryAllCollections),
              onChanged: controller.setCollectionFilter,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.libraryAllCollections),
                ),
                for (final entry in controller.collections)
                  DropdownMenuItem(
                    value: entry.collection.id,
                    child: Text(entry.collection.name),
                  ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: onManageCollections,
              icon: const Icon(Icons.folder_outlined),
              label: Text(l10n.libraryManageCollections),
            ),
          ],
        ),
      ],
    );
  }
}

class _LibraryCard extends StatelessWidget {
  const _LibraryCard({
    required this.entry,
    required this.collectionName,
    required this.busy,
    required this.onEdit,
  });

  final LibraryEntry entry;
  final String? collectionName;
  final bool busy;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = entry.content;
    final semanticsParts = <String>[
      l10n.libraryCardSemantics(content.translation.title),
      '${l10n.libraryStatusLabel}: ${_statusLabel(l10n, entry.savedItem.status)}',
      '${l10n.libraryNoteLabel}: ${entry.savedItem.note ?? l10n.libraryNoNote}',
      if (collectionName != null)
        '${l10n.libraryCollectionLabel}: $collectionName',
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(FrameLabSpacing.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => context.goNamed(
                  AppRoutes.exploreContentName,
                  pathParameters: {'contentId': content.item.id},
                ),
                child: Semantics(
                  button: true,
                  label: semanticsParts.join('. '),
                  excludeSemantics: true,
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
                      const SizedBox(height: FrameLabSpacing.small),
                      Chip(
                        label: Text(_statusLabel(l10n, entry.savedItem.status)),
                      ),
                      if (entry.savedItem.note case final note?) ...[
                        const SizedBox(height: FrameLabSpacing.xSmall),
                        Text(
                          note,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: FrameLabSpacing.small),
            busy
                ? const SizedBox.square(
                    dimension: 48,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    tooltip: l10n.libraryEditItem(content.translation.title),
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showItemEditor(
  BuildContext context,
  LibraryController controller,
  LibraryEntry entry,
) async {
  final l10n = AppLocalizations.of(context)!;
  var note = entry.savedItem.note;
  var status = entry.savedItem.status;
  var collectionId = entry.savedItem.collectionId;
  var saving = false;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(l10n.libraryEditItem(entry.content.translation.title)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<SavedItemStatus>(
                initialValue: status,
                decoration: InputDecoration(labelText: l10n.libraryStatusLabel),
                items: [
                  for (final value in SavedItemStatus.values)
                    DropdownMenuItem(
                      value: value,
                      child: Text(_statusLabel(l10n, value)),
                    ),
                ],
                onChanged: (value) =>
                    setDialogState(() => status = value ?? status),
              ),
              const SizedBox(height: FrameLabSpacing.medium),
              DropdownButtonFormField<String?>(
                initialValue: collectionId,
                decoration: InputDecoration(
                  labelText: l10n.libraryCollectionLabel,
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.libraryNoCollection),
                  ),
                  for (final value in controller.collections)
                    DropdownMenuItem(
                      value: value.collection.id,
                      child: Text(value.collection.name),
                    ),
                ],
                onChanged: (value) =>
                    setDialogState(() => collectionId = value),
              ),
              const SizedBox(height: FrameLabSpacing.medium),
              TextFormField(
                initialValue: note,
                maxLines: 4,
                decoration: InputDecoration(labelText: l10n.libraryNoteLabel),
                onChanged: (value) => note = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final confirmed = await _confirm(
                context,
                title: l10n.libraryRemoveTitle,
                message: l10n.libraryRemoveMessage,
              );
              if (confirmed &&
                  await controller.remove(entry.savedItem.contentId) &&
                  dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: Text(l10n.libraryRemoveAction),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.libraryCancel),
          ),
          FilledButton(
            onPressed: saving
                ? null
                : () async {
                    setDialogState(() => saving = true);
                    final contentId = entry.savedItem.contentId;
                    final saved = await controller.updateDetails(
                      contentId,
                      note: note,
                      status: status,
                      collectionId: collectionId,
                    );
                    if (saved && dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    } else if (dialogContext.mounted) {
                      setDialogState(() => saving = false);
                    }
                  },
            child: Text(l10n.librarySaveChanges),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showCollectionManager(
  BuildContext context,
  LibraryController controller,
) => showDialog<void>(
  context: context,
  builder: (dialogContext) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      final l10n = AppLocalizations.of(context)!;
      return AlertDialog(
        title: Text(l10n.libraryManageCollections),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SizedBox(
            width: 420,
            child: controller.collections.isEmpty
                ? Text(l10n.libraryNoCollections)
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.collections.length,
                    itemBuilder: (context, index) {
                      final value = controller.collections[index];
                      return ListTile(
                        title: Text(value.collection.name),
                        subtitle: Text(
                          l10n.libraryCollectionCount(value.savedItemCount),
                        ),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              tooltip: l10n.libraryRenameCollection,
                              onPressed: controller.isCollectionBusy
                                  ? null
                                  : () => _collectionNameDialog(
                                      context,
                                      initialName: value.collection.name,
                                      title: l10n.libraryRenameCollection,
                                      action: (name) =>
                                          controller.renameCollection(
                                            value.collection.id,
                                            name,
                                          ),
                                    ),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              tooltip: l10n.libraryDeleteCollection,
                              onPressed: controller.isCollectionBusy
                                  ? null
                                  : () async {
                                      if (await _confirm(
                                            context,
                                            title: l10n.libraryDeleteCollection,
                                            message: l10n
                                                .libraryDeleteCollectionMessage,
                                          ) &&
                                          context.mounted) {
                                        await controller.deleteCollection(
                                          value.collection.id,
                                        );
                                      }
                                    },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
        actions: [
          if (controller.isCollectionBusy)
            const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          TextButton.icon(
            onPressed: controller.isCollectionBusy
                ? null
                : () => _collectionNameDialog(
                    context,
                    title: l10n.libraryCreateCollection,
                    action: controller.createCollection,
                  ),
            icon: const Icon(Icons.create_new_folder_outlined),
            label: Text(l10n.libraryCreateCollection),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.libraryDone),
          ),
        ],
      );
    },
  ),
);

Future<void> _collectionNameDialog(
  BuildContext context, {
  String initialName = '',
  required String title,
  required Future<bool> Function(String name) action,
}) async {
  final l10n = AppLocalizations.of(context)!;
  var name = initialName;
  var saving = false;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: Text(title),
          content: TextFormField(
            initialValue: initialName,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.libraryCollectionName),
            onChanged: (value) => name = value,
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(dialogContext),
              child: Text(l10n.libraryCancel),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (name.trim().isEmpty) return;
                      setDialogState(() => saving = true);
                      final saved = await action(name);
                      if (saved && dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      } else if (dialogContext.mounted) {
                        setDialogState(() => saving = false);
                      }
                    },
              child: saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.librarySaveChanges),
            ),
          ],
        );
      },
    ),
  );
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final l10n = AppLocalizations.of(context)!;
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.libraryCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.libraryConfirm),
            ),
          ],
        ),
      ) ??
      false;
}

String _statusLabel(AppLocalizations l10n, SavedItemStatus status) =>
    switch (status) {
      SavedItemStatus.toTry => l10n.libraryStatusToTry,
      SavedItemStatus.tried => l10n.libraryStatusTried,
      SavedItemStatus.completed => l10n.libraryStatusCompleted,
    };

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
