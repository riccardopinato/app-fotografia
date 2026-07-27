import 'dart:io';

import 'package:drift/native.dart';
import 'package:framelab/core/database/app_database.dart';
import 'package:framelab/features/editorial/data/editorial_importer.dart';
import 'package:framelab/features/editorial/domain/editorial_package.dart';
import 'package:framelab/features/editorial/domain/editorial_validation.dart';
import 'package:framelab/features/editorial/domain/catalog_quality_validation.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length < 2 ||
      !{'validate', 'quality', 'import'}.contains(arguments.first)) {
    stderr.writeln(
      'Usage: dart run bin/framelab_editorial.dart <validate|quality|import> <package.json> [database.sqlite]',
    );
    exitCode = 64;
    return;
  }
  try {
    final package = await EditorialPackage.load(File(arguments[1]));
    final report = arguments.first == 'quality'
        ? await CatalogQualityValidator().validate(package)
        : await EditorialValidator().validate(package);
    stdout.write(report.render());
    if (!report.isValid) {
      exitCode = 1;
      return;
    }
    if (arguments.first == 'import') {
      if (arguments.length != 3) {
        stderr.writeln('Import requires a database path.');
        exitCode = 64;
        return;
      }
      final database = AppDatabase(NativeDatabase(File(arguments[2])));
      try {
        final result = await EditorialImporter(database).import(package);
        stdout.writeln(
          'Import committed: inserted=${result.inserted}, updated=${result.updated}, unchanged=${result.unchanged}',
        );
      } on EditorialImportException catch (error) {
        stderr.write(error.report.render());
        exitCode = 1;
      } finally {
        await database.close();
      }
    }
  } on FormatException catch (error) {
    stderr.writeln('Invalid package JSON: ${error.message}');
    exitCode = 1;
  } on FileSystemException catch (error) {
    stderr.writeln('Cannot read package: ${error.message}');
    exitCode = 1;
  }
}
