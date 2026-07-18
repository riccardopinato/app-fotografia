import 'package:flutter/material.dart';
import '../../../core/widgets/frame_lab_empty_state.dart';
import '../domain/catalog_models.dart';
import 'catalog_scope.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});
  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final search = TextEditingController();
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = CatalogScope.of(context);
    if (repo == null) {
      return const FrameLabEmptyState(
        icon: Icons.menu_book_outlined,
        title: 'Catalog unavailable',
        description: 'Local editorial content is not ready.',
      );
    }
    final locale = Localizations.localeOf(context);
    final code = LocaleCode(
      locale.countryCode == null
          ? locale.languageCode
          : '${locale.languageCode}-${locale.countryCode}',
    );
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: search,
      builder: (context, value, _) => FutureBuilder<CatalogResultPage>(
        future: repo.getPage(
          locale: code,
          query: CatalogQuery(search: value.text, sort: CatalogSort.relevance),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const FrameLabEmptyState(
              icon: Icons.error_outline,
              title: 'Catalog error',
              description: 'Try opening the local catalog again.',
            );
          }
          final items = snapshot.data!.items;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: search,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search the offline catalog',
                  ),
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const FrameLabEmptyState(
                        icon: Icons.search_off,
                        title: 'No matching content',
                        description: 'Try a different search.',
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            _Card(item: items[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.item});
  final LocalizedContent item;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: item.translation.title,
      child: Card(
        child: InkWell(
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => _Detail(item: item))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.translation.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(item.translation.summary),
                const SizedBox(height: 8),
                Text(
                  '${item.item.type.name} · ${item.item.difficulty.name} · Offline',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.item});
  final LocalizedContent item;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(item.translation.title)),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              item.translation.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(item.translation.summary),
            const SizedBox(height: 24),
            Text(item.translation.body),
            const SizedBox(height: 24),
            Text(
              'Type: ${item.item.type.name}\nCategory: ${item.item.primaryCategory}\nDifficulty: ${item.item.difficulty.name}\nAvailable offline',
            ),
          ],
        ),
      ),
    ),
  );
}
