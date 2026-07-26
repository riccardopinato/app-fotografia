import 'package:flutter/widgets.dart';

import '../domain/library_repository.dart';

class LibraryScope extends InheritedWidget {
  const LibraryScope({
    required this.repository,
    required super.child,
    super.key,
  });

  final LibraryRepository repository;

  static LibraryRepository of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LibraryScope>()!.repository;

  static LibraryRepository? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LibraryScope>()?.repository;

  @override
  bool updateShouldNotify(LibraryScope oldWidget) =>
      repository != oldWidget.repository;
}
