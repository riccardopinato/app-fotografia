import 'package:flutter/widgets.dart';
import '../domain/catalog_repository.dart';

class CatalogScope extends InheritedWidget {
  const CatalogScope({
    required this.repository,
    required super.child,
    super.key,
  });
  final CatalogRepository? repository;
  static CatalogRepository? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CatalogScope>()?.repository;
  @override
  bool updateShouldNotify(CatalogScope oldWidget) =>
      repository != oldWidget.repository;
}
