import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../../features/catalog/domain/catalog_models.dart';
import '../../../features/catalog/presentation/catalog_scope.dart';
import '../../../features/profile/domain/user_profile.dart';
import '../../../features/profile/presentation/profile_scope.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/recommendation_engine.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => FutureBuilder<List<Object?>>(
    future: Future.wait([
      ProfileScope.of(context).get(),
      CatalogScope.of(context).getPublished(locale: _locale(context)),
    ]),
    builder: (context, snapshot) {
      final l = AppLocalizations.of(context)!;
      if (snapshot.connectionState != ConnectionState.done) {
        return Scaffold(
          body: Center(
            child: Semantics(
              label: l.homeLoading,
              child: const CircularProgressIndicator(),
            ),
          ),
        );
      }
      if (snapshot.hasError) {
        return Scaffold(body: Center(child: Text(l.homeError)));
      }
      final profile = snapshot.data![0] as UserProfile?;
      final content = snapshot.data![1] as List<LocalizedContent>;
      final recommendations = const RecommendationEngine().recommend(
        contents: content,
        profile: profile,
        locale: _locale(context),
      );
      return Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) => ListView(
              padding: EdgeInsets.all(c.maxWidth > 700 ? 32 : 16),
              children: [
                Text(
                  l.homeGreeting,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (profile == null || profile.preferredTopics.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(l.homeIncompleteProfile),
                  ),
                const SizedBox(height: 24),
                Text(
                  l.homeChosenForYou,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (recommendations.isEmpty)
                  Text(
                    content.isEmpty
                        ? l.homeEmptyCatalog
                        : l.homeEditorialFallback,
                  )
                else
                  _HeroCard(recommendation: recommendations.first),
                const SizedBox(height: 24),
                Text(
                  l.homeImproveIdeas,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height:
                      204 +
                      100 *
                          (MediaQuery.textScalerOf(context).scale(1) - 1).clamp(
                            0,
                            1,
                          ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendations.skip(1).take(4).length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => SizedBox(
                      width: 250,
                      child: _SmallCard(
                        recommendation: recommendations.skip(1).elementAt(i),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l.homeForYourLevel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ...recommendations
                    .where(
                      (r) => r.reasons.contains(RecommendationReason.level),
                    )
                    .take(3)
                    .map((r) => _SmallCard(recommendation: r)),
                TextButton(
                  onPressed: () => context.go(AppDestination.explore.path),
                  child: Text(l.homeOpenCatalog),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  LocaleCode _locale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return LocaleCode(
      locale.countryCode == null
          ? locale.languageCode
          : '${locale.languageCode}-${locale.countryCode}',
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.recommendation});
  final Recommendation recommendation;
  @override
  Widget build(BuildContext context) =>
      _Card(recommendation: recommendation, hero: true);
}

class _SmallCard extends StatelessWidget {
  const _SmallCard({required this.recommendation});
  final Recommendation recommendation;
  @override
  Widget build(BuildContext context) => _Card(recommendation: recommendation);
}

class _Card extends StatelessWidget {
  const _Card({required this.recommendation, this.hero = false});
  final Recommendation recommendation;
  final bool hero;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final reason = recommendation.reasons.isEmpty
        ? l.homeEditorialFallback
        : switch (recommendation.reasons.first) {
            RecommendationReason.interest => l.homeReasonInterest,
            RecommendationReason.goal => l.homeReasonGoal,
            RecommendationReason.level => l.homeReasonLevel,
            RecommendationReason.equipment => l.homeReasonEquipment,
          };
    return Semantics(
      button: true,
      label: recommendation.content.translation.title,
      child: Card(
        child: InkWell(
          onTap: () =>
              context.go('/explore/content/${recommendation.content.item.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  hero
                      ? Icons.auto_awesome_outlined
                      : Icons.camera_alt_outlined,
                ),
                const SizedBox(height: 8),
                Text(
                  recommendation.content.translation.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(reason),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
