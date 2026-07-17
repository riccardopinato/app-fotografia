import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

enum AppDestination {
  home('/home', 'home', Icons.home_outlined, Icons.home),
  explore('/explore', 'explore', Icons.explore_outlined, Icons.explore),
  ideas('/ideas', 'ideas', Icons.lightbulb_outline, Icons.lightbulb),
  library('/library', 'library', Icons.bookmark_outline, Icons.bookmark),
  profile('/profile', 'profile', Icons.person_outline, Icons.person);

  const AppDestination(this.path, this.routeName, this.icon, this.selectedIcon);

  final String path;
  final String routeName;
  final IconData icon;
  final IconData selectedIcon;

  String label(AppLocalizations l10n) => switch (this) {
    AppDestination.home => l10n.navHome,
    AppDestination.explore => l10n.navExplore,
    AppDestination.ideas => l10n.navIdeas,
    AppDestination.library => l10n.navLibrary,
    AppDestination.profile => l10n.navProfile,
  };
}

abstract final class AppRoutes {
  static const home = AppDestination.home;
}
