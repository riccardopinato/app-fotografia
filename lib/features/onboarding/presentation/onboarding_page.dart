import 'package:flutter/material.dart';

import '../../profile/domain/profile_repository.dart';
import '../../profile/presentation/profile_editor.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({required this.repository, super.key});

  final ProfileRepository repository;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ProfileEditor(profile: null, onSave: repository.save),
    ),
  );
}
