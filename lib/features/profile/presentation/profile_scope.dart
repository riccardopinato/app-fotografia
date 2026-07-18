import 'package:flutter/widgets.dart';

import '../domain/profile_repository.dart';

class ProfileScope extends InheritedWidget {
  const ProfileScope({
    required this.repository,
    required super.child,
    super.key,
  });

  final ProfileRepository repository;

  static ProfileRepository of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ProfileScope>()!.repository;

  @override
  bool updateShouldNotify(ProfileScope oldWidget) =>
      repository != oldWidget.repository;
}
