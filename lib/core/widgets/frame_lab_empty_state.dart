import 'package:flutter/material.dart';

import '../design/frame_lab_tokens.dart';

class FrameLabEmptyState extends StatelessWidget {
  const FrameLabEmptyState({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: FrameLabLayout.contentMaxWidth,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(FrameLabSpacing.large),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          icon,
                          color: colors.primary,
                          size: FrameLabSpacing.xxLarge,
                        ),
                      ),
                      const SizedBox(height: FrameLabSpacing.large),
                      Text(
                        title,
                        style: textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: FrameLabSpacing.small),
                      Text(
                        description,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
