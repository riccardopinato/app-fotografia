import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/core/database/app_database.dart'
    hide Collection, SavedItem;
import 'package:framelab/core/database/app_database.dart'
    as database
    show SavedItem;
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/library/data/drift_library_repository.dart';
import 'package:framelab/features/library/data/library_mapper.dart';
import 'package:framelab/features/library/domain/library_models.dart';

const _now = 1704067200000;

AppDatabase _db(QueryExecutor? executor) =>
    AppDatabase(executor ?? NativeDatabase.memory());

Future<void> _content(AppDatabase db, String id) => db
    .into(db.contentItems)
    .insert(
      ContentItemsCompanion.insert(
        id: id,
        type: ContentType.tip.name,
        primaryCategory: 'light',
        difficulty: Difficulty.beginner.name,
        premium: false,
        canonicalLocale: 'en',
        editorialStatus: EditorialStatus.published.name,
        version: 1,
        createdAtUtcMs: _now,
        updatedAtUtcMs: _now,
      ),
    );

void main() {
  group('Step 7A library domain', () {
    test('uses toTry by default and normalizes notes and UTC timestamps', () {
      final item = SavedItem(
        id: 'saved',
        contentId: 'content',
        note: '  note  ',
        savedAtUtc: DateTime(2024),
        updatedAtUtc: DateTime(2024),
      );
      expect(item.status, SavedItemStatus.toTry);
      expect(item.note, 'note');
      expect(
        SavedItem(
          id: 'saved',
          contentId: 'content',
          note: '  ',
          savedAtUtc: DateTime(2024),
          updatedAtUtc: DateTime(2024),
        ).note,
        isNull,
      );
      expect(item.savedAtUtc.isUtc, isTrue);
    });
    test('trims collection names and rejects blank names', () {
      expect(
        Collection(
          id: 'c',
          name: '  Practice  ',
          createdAtUtc: DateTime.utc(2024),
          updatedAtUtc: DateTime.utc(2024),
        ).name,
        'Practice',
      );
      expect(
        () => Collection(
          id: 'c',
          name: '  ',
          createdAtUtc: DateTime.utc(2024),
          updatedAtUtc: DateTime.utc(2024),
        ),
        throwsArgumentError,
      );
    });
    test('maps database rows to domain values', () {
      final item = savedItemFromRow(
        database.SavedItem(
          id: 's',
          contentId: 'content',
          collectionId: null,
          note: ' note ',
          status: 'tried',
          savedAtUtcMs: _now,
          updatedAtUtcMs: _now + 1,
        ),
      );
      expect(item.status, SavedItemStatus.tried);
      expect(item.note, 'note');
      expect(item.updatedAtUtc.millisecondsSinceEpoch, _now + 1);
    });
  });

  group('Step 7A library repository and schema', () {
    test(
      'enforces current foreign keys, uniqueness, filters, updates and SET NULL',
      () async {
        final db = _db(null);
        addTearDown(db.close);
        expect(db.schemaVersion, 5);
        expect(
          (await db.customSelect('PRAGMA foreign_keys').getSingle()).read<int>(
            'foreign_keys',
          ),
          1,
        );
        await _content(db, 'one');
        await _content(db, 'two');
        var tick = DateTime.utc(2024);
        final repo = DriftLibraryRepository(
          db,
          now: () => tick = tick.add(const Duration(seconds: 1)),
        );
        final collection = await repo.createCollection('  Exercises ');
        final first = await repo.save('one', collectionId: collection.id);
        expect((await repo.save('one')).id, first.id);
        await repo.updateDetails(
          'one',
          note: '  remember exposure  ',
          status: SavedItemStatus.completed,
          collectionId: collection.id,
        );
        await repo.save('two');
        expect(
          (await repo.getSavedItems(
            status: SavedItemStatus.completed,
          )).single.note,
          'remember exposure',
        );
        expect(
          (await repo.getSavedItems(
            collectionId: collection.id,
          )).single.contentId,
          'one',
        );
        await repo.assignCollection('one', null);
        await repo.assignCollection('one', collection.id);
        await repo.deleteCollection(collection.id);
        expect((await repo.getSavedItems()).first.collectionId, isNull);
        await expectLater(repo.save('missing'), throwsA(isA<Exception>()));
        await repo.remove('two');
        expect(await repo.getSavedItems(), hasLength(1));
      },
    );

    test('persists saved records after reopening a database', () async {
      final file = File(
        '${Directory.systemTemp.path}/framelab-library-${DateTime.now().microsecondsSinceEpoch}.sqlite',
      );
      final first = _db(NativeDatabase(file));
      await _content(first, 'persist');
      await DriftLibraryRepository(first).save('persist');
      await first.close();
      final reopened = _db(NativeDatabase(file));
      expect(
        (await DriftLibraryRepository(
          reopened,
        ).getSavedItems()).single.contentId,
        'persist',
      );
      await reopened.close();
      await file.delete();
    });
  });
}
