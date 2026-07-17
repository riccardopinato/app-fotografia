import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/frame_lab_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'app_routes.dart';

class FrameLabShell extends StatelessWidget {
  const FrameLabShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destination = AppDestination.values[navigationShell.currentIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= FrameLabLayout.railBreakpoint;

        return Scaffold(
          appBar: AppBar(title: Text(destination.label(l10n))),
          body: useRail
              ? Row(
                  children: [
                    _NavigationRail(
                      currentIndex: navigationShell.currentIndex,
                      l10n: l10n,
                      onDestinationSelected: _goBranch,
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: navigationShell),
                  ],
                )
              : navigationShell,
          bottomNavigationBar: useRail
              ? null
              : _NavigationBar(
                  currentIndex: navigationShell.currentIndex,
                  l10n: l10n,
                  onDestinationSelected: _goBranch,
                ),
        );
      },
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.currentIndex,
    required this.l10n,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final AppLocalizations l10n;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: l10n.navigationLabel,
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          for (final destination in AppDestination.values)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label(l10n),
            ),
        ],
      ),
    );
  }
}

class _NavigationRail extends StatelessWidget {
  const _NavigationRail({
    required this.currentIndex,
    required this.l10n,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final AppLocalizations l10n;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: l10n.navigationLabel,
      child: NavigationRail(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        destinations: [
          for (final destination in AppDestination.values)
            NavigationRailDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: Text(destination.label(l10n)),
            ),
        ],
      ),
    );
  }
}
