import 'package:go_router/go_router.dart';

import '../../features/catalog/presentation/catalog_detail_page.dart';
import '../../features/catalog/presentation/catalog_page.dart';
import '../../features/home/presentation/destination_placeholder_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import 'app_routes.dart';
import 'frame_lab_shell.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home.path,
  errorBuilder: (context, state) =>
      const DestinationPlaceholderPage(destination: AppDestination.home),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          FrameLabShell(navigationShell: navigationShell),
      branches: [
        for (final destination in AppDestination.values)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: destination.path,
                name: destination.routeName,
                builder: (context, state) =>
                    destination == AppDestination.profile
                    ? const ProfilePage()
                    : destination == AppDestination.explore
                    ? const CatalogPage()
                    : DestinationPlaceholderPage(destination: destination),
                routes: destination == AppDestination.explore
                    ? [
                        GoRoute(
                          path: 'content/:contentId',
                          name: AppRoutes.exploreContentName,
                          builder: (context, state) => CatalogDetailPage(
                            contentId: state.pathParameters['contentId'],
                          ),
                        ),
                      ]
                    : const [],
              ),
            ],
          ),
      ],
    ),
  ],
);
