import 'package:flutter/material.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/design/frame_lab_tokens.dart';
import '../../../core/widgets/frame_lab_empty_state.dart';
import '../../../l10n/app_localizations.dart';

class DestinationPlaceholderPage extends StatelessWidget {
  const DestinationPlaceholderPage({required this.destination, super.key});

  final AppDestination destination;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = _PlaceholderContent.from(destination, l10n);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(FrameLabSpacing.medium),
        child: FrameLabEmptyState(
          icon: destination.selectedIcon,
          title: content.title,
          description: content.description,
        ),
      ),
    );
  }
}

class _PlaceholderContent {
  const _PlaceholderContent({required this.title, required this.description});

  final String title;
  final String description;

  factory _PlaceholderContent.from(
    AppDestination destination,
    AppLocalizations l10n,
  ) => switch (destination) {
    AppDestination.home => _PlaceholderContent(
      title: l10n.homePlaceholderTitle,
      description: l10n.homePlaceholderDescription,
    ),
    AppDestination.explore => _PlaceholderContent(
      title: l10n.explorePlaceholderTitle,
      description: l10n.explorePlaceholderDescription,
    ),
    AppDestination.ideas => _PlaceholderContent(
      title: l10n.ideasPlaceholderTitle,
      description: l10n.ideasPlaceholderDescription,
    ),
    AppDestination.library => _PlaceholderContent(
      title: l10n.libraryPlaceholderTitle,
      description: l10n.libraryPlaceholderDescription,
    ),
    AppDestination.profile => _PlaceholderContent(
      title: l10n.profilePlaceholderTitle,
      description: l10n.profilePlaceholderDescription,
    ),
  };
}
