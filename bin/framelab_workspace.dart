import 'dart:convert';
import 'dart:io';

import 'package:framelab/features/editorial/domain/editorial_package.dart';
import 'package:framelab/features/editorial/domain/editorial_validation.dart';
import 'package:framelab/features/editorial_workspace/data/editorial_workspace.dart';
import 'package:framelab/features/editorial_workspace/domain/editorial_workspace_models.dart';
import 'package:sqlite3/sqlite3.dart';

const _usage =
    'Usage:\n'
    '  dart run bin/framelab_workspace.dart init <workspace.sqlite>\n'
    '  dart run bin/framelab_workspace.dart ingest <workspace.sqlite> <manifest.json>\n'
    '  dart run bin/framelab_workspace.dart draft <workspace.sqlite> <draft.json>\n'
    '  dart run bin/framelab_workspace.dart search <workspace.sqlite> <query> [limit]\n'
    '  dart run bin/framelab_workspace.dart queue <workspace.sqlite> [status]\n'
    '  dart run bin/framelab_workspace.dart review <workspace.sqlite> <decision.json>\n'
    '  dart run bin/framelab_workspace.dart export <workspace.sqlite> <locale> <package.json>\n'
    '  dart run bin/framelab_workspace.dart status <workspace.sqlite>';

Future<void> main(List<String> arguments) async {
  if (!_validArguments(arguments)) {
    stderr.writeln(_usage);
    exitCode = 64;
    return;
  }

  EditorialWorkspace? workspace;
  try {
    final command = arguments.first;
    workspace = EditorialWorkspace.open(File(arguments[1]));
    switch (command) {
      case 'init':
        _writeJson({'schemaVersion': EditorialWorkspace.schemaVersion});
        break;
      case 'ingest':
        final manifest = await WorkspaceIngestManifest.load(File(arguments[2]));
        final result = workspace.ingest(manifest);
        _writeJson({
          'documentInserted': result.documentInserted,
          'fragmentsInserted': result.fragmentsInserted,
          'duplicatesDetected': result.duplicatesDetected,
        });
        break;
      case 'draft':
        final input = await WorkspaceDraftInput.load(File(arguments[2]));
        final result = workspace.saveDraft(input);
        _writeJson({
          'inserted': result.inserted,
          'version': result.version,
          'reviewTasks': result.reviewTasks,
        });
        break;
      case 'search':
        final limit = arguments.length == 4 ? int.tryParse(arguments[3]) : 20;
        if (limit == null) {
          throw const FormatException('Search limit must be an integer.');
        }
        _writeJson([
          for (final hit in workspace.searchFragments(
            arguments[2],
            limit: limit,
          ))
            hit.toJson(),
        ]);
        break;
      case 'queue':
        final status = arguments.length == 3 ? arguments[2] : 'pending';
        _writeJson([
          for (final task in workspace.reviewQueue(status: status))
            task.toJson(),
        ]);
        break;
      case 'review':
        final decision = await WorkspaceReviewDecision.load(File(arguments[2]));
        workspace.review(decision);
        _writeJson({'reviewed': decision.taskId, 'status': decision.decision});
        break;
      case 'export':
        final result = workspace.exportLocale(
          locale: arguments[2],
          output: File(arguments[3]),
        );
        final package = await EditorialPackage.load(result.file);
        final report = await EditorialValidator().validate(package);
        if (!report.isValid) {
          stderr.write(report.render());
          exitCode = 1;
          return;
        }
        _writeJson({
          'packageVersion': result.packageVersion,
          'contents': result.contents,
          'checksum': result.checksum,
          'file': result.file.absolute.path,
        });
        break;
      case 'status':
        _writeJson(workspace.counts());
        break;
    }
  } on FormatException catch (error) {
    stderr.writeln('Invalid input: ${error.message}');
    exitCode = 1;
  } on StateError catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  } on SqliteException catch (error) {
    stderr.writeln('Editorial workspace database error: ${error.message}');
    exitCode = 1;
  } on FileSystemException catch (error) {
    stderr.writeln('Editorial workspace file error: ${error.message}');
    exitCode = 1;
  } finally {
    workspace?.close();
  }
}

bool _validArguments(List<String> arguments) {
  if (arguments.length < 2) return false;
  return switch (arguments.first) {
    'init' || 'status' => arguments.length == 2,
    'ingest' || 'draft' || 'review' => arguments.length == 3,
    'search' => arguments.length == 3 || arguments.length == 4,
    'queue' => arguments.length == 2 || arguments.length == 3,
    'export' => arguments.length == 4,
    _ => false,
  };
}

void _writeJson(Object value) {
  const encoder = JsonEncoder.withIndent('  ');
  stdout.writeln(encoder.convert(value));
}
