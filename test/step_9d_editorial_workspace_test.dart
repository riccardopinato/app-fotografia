import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/features/editorial/domain/editorial_package.dart';
import 'package:framelab/features/editorial/domain/editorial_validation.dart';
import 'package:framelab/features/editorial_workspace/data/editorial_workspace.dart';
import 'package:framelab/features/editorial_workspace/domain/editorial_workspace_models.dart';

void main() {
  late Directory temporaryDirectory;
  late EditorialWorkspace workspace;

  setUp(() {
    temporaryDirectory = Directory.systemTemp.createTempSync(
      'framelab-step-9d-',
    );
    workspace = EditorialWorkspace.open(
      File('${temporaryDirectory.path}/workspace.sqlite'),
    );
  });

  tearDown(() {
    workspace.close();
    temporaryDirectory.deleteSync(recursive: true);
  });

  test('ingestion and draft writes are idempotent and versioned', () async {
    final manifest = await _manifest();
    final firstIngest = workspace.ingest(manifest);
    final secondIngest = workspace.ingest(manifest);

    expect(firstIngest.documentInserted, isTrue);
    expect(firstIngest.fragmentsInserted, 2);
    expect(secondIngest.documentInserted, isFalse);
    expect(workspace.counts()['fragments'], 2);
    final searchResults = workspace.searchFragments('exposure compensation');
    expect(searchResults, hasLength(1));
    expect(searchResults.single.id, 'document-workspace-exposure#0002');
    expect(searchResults.single.excerpt, contains('[Exposure]'));

    final draft = await _draft();
    final firstDraft = workspace.saveDraft(draft);
    final sameDraft = workspace.saveDraft(draft);

    expect(firstDraft.inserted, isTrue);
    expect(firstDraft.reviewTasks, 6);
    expect(sameDraft.inserted, isFalse);

    final upgraded = _draftAtVersion(draft, 2);
    expect(workspace.saveDraft(upgraded).version, 2);
    expect(workspace.reviewQueue(), hasLength(6));
    expect(() => workspace.saveDraft(draft), throwsA(isA<StateError>()));
  });

  test('only fully reviewed content can be exported and validated', () async {
    workspace.ingest(await _manifest());
    workspace.saveDraft(await _draft());
    final output = File('${temporaryDirectory.path}/it-package.json');

    expect(
      () => workspace.exportLocale(locale: 'it', output: output),
      throwsA(isA<StateError>()),
    );

    final tasks = workspace.reviewQueue();
    expect(tasks, hasLength(6));
    for (final task in tasks) {
      workspace.review(
        WorkspaceReviewDecision(
          taskId: task.id,
          reviewer: 'Step 9D test reviewer',
          decision: 'approved',
          note: 'Fixture reviewed.',
        ),
      );
    }

    expect(workspace.counts()['approvedDrafts'], 1);
    final first = workspace.exportLocale(locale: 'it', output: output);
    final package = await EditorialPackage.load(output);
    final report = await EditorialValidator().validate(package);
    final root =
        jsonDecode(await output.readAsString()) as Map<String, Object?>;

    expect(first.packageVersion, 1);
    expect(first.contents, 1);
    expect(report.isValid, isTrue, reason: report.render());
    expect(root['locales'], ['en', 'it']);
    expect((root['contents']! as List<Object?>), hasLength(1));
    final exportedSource =
        (root['sources']! as List<Object?>).first as Map<String, Object?>;
    expect(exportedSource.containsKey('rightsEvidence'), isFalse);

    final second = workspace.exportLocale(locale: 'it', output: output);
    expect(second.packageVersion, 2);
  });

  test('rights metadata blocks publication even after review', () async {
    final original = await _manifest();
    final source = original.source;
    workspace.ingest(
      WorkspaceIngestManifest(
        source: WorkspaceSourceInput(
          id: source.id,
          title: source.title,
          author: source.author,
          publisher: source.publisher,
          issue: source.issue,
          publicationDate: source.publicationDate,
          originalLocale: source.originalLocale,
          sourceType: source.sourceType,
          licenseType: source.licenseType,
          licenseUrl: source.licenseUrl,
          rightsStatus: 'reviewRequired',
          verificationStatus: source.verificationStatus,
          attributionRequired: source.attributionRequired,
          attributionText: source.attributionText,
          rightsEvidence: source.rightsEvidence,
          restrictions: source.restrictions,
          tdmReserved: source.tdmReserved,
        ),
        document: original.document,
        extractedText: original.extractedText,
      ),
    );
    workspace.saveDraft(await _draft());
    for (final task in workspace.reviewQueue()) {
      workspace.review(
        WorkspaceReviewDecision(
          taskId: task.id,
          reviewer: 'Step 9D test reviewer',
          decision: 'approved',
        ),
      );
    }

    expect(
      () => workspace.exportLocale(
        locale: 'it',
        output: File('${temporaryDirectory.path}/blocked.json'),
      ),
      throwsA(isA<StateError>()),
    );
  });
}

Future<WorkspaceIngestManifest> _manifest() => WorkspaceIngestManifest.load(
  File('editorial/workspace/example_ingest.json'),
);

Future<WorkspaceDraftInput> _draft() =>
    WorkspaceDraftInput.load(File('editorial/workspace/example_draft.json'));

WorkspaceDraftInput _draftAtVersion(WorkspaceDraftInput input, int version) =>
    WorkspaceDraftInput(
      id: input.id,
      version: version,
      type: input.type,
      category: input.category,
      difficulty: input.difficulty,
      canonicalLocale: input.canonicalLocale,
      premium: input.premium,
      tags: input.tags,
      sourceIds: input.sourceIds,
      fragmentIds: input.fragmentIds,
      translations: input.translations,
    );
