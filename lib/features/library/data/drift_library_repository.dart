import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/library_models.dart';
import '../domain/library_repository.dart';
import 'library_mapper.dart';

class DriftLibraryRepository implements LibraryRepository {
  DriftLibraryRepository(this._database, {Uuid? uuid, DateTime Function()? now})
    : _uuid = uuid ?? const Uuid(),
      _now = now ?? DateTime.now;

  final db.AppDatabase _database;
  final Uuid _uuid;
  final DateTime Function() _now;

  DateTime get _utcNow => _now().toUtc();
  int _milliseconds(DateTime value) => value.toUtc().millisecondsSinceEpoch;

  @override
  Stream<List<SavedItem>> watchSavedItems() => _savedItemsQuery().watch().map(
    (rows) => rows.map(savedItemFromRow).toList(growable: false),
  );

  @override
  Stream<SavedItem?> watchSavedItem(String contentId) =>
      (_database.select(_database.savedItems)
            ..where((row) => row.contentId.equals(contentId)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : savedItemFromRow(row));

  @override
  Future<List<SavedItem>> getSavedItems({
    SavedItemStatus? status,
    String? collectionId,
  }) async {
    final query = _savedItemsQuery();
    if (status != null) {
      query.where((row) => row.status.equals(status.name));
    }
    if (collectionId != null) {
      query.where((row) => row.collectionId.equals(collectionId));
    }
    return (await query.get()).map(savedItemFromRow).toList(growable: false);
  }

  SimpleSelectStatement<db.SavedItems, db.SavedItem> _savedItemsQuery() =>
      _database.select(_database.savedItems)..orderBy([
        (row) => OrderingTerm.desc(row.updatedAtUtcMs),
        (row) => OrderingTerm.asc(row.contentId),
        (row) => OrderingTerm.asc(row.id),
      ]);

  @override
  Future<SavedItem> save(String contentId, {String? collectionId}) =>
      _database.transaction(() async {
        final existing = await _byContentId(contentId);
        if (existing != null) return savedItemFromRow(existing);
        final now = _utcNow;
        await _database
            .into(_database.savedItems)
            .insert(
              db.SavedItemsCompanion.insert(
                id: _uuid.v4(),
                contentId: contentId,
                collectionId: Value(collectionId),
                status: SavedItemStatus.toTry.name,
                savedAtUtcMs: _milliseconds(now),
                updatedAtUtcMs: _milliseconds(now),
              ),
            );
        return savedItemFromRow((await _byContentId(contentId))!);
      });

  Future<db.SavedItem?> _byContentId(String contentId) => (_database.select(
    _database.savedItems,
  )..where((row) => row.contentId.equals(contentId))).getSingleOrNull();

  @override
  Future<void> remove(String contentId) => (_database.delete(
    _database.savedItems,
  )..where((row) => row.contentId.equals(contentId))).go().then((_) {});

  Future<void> _update(String contentId, db.SavedItemsCompanion values) =>
      (_database.update(_database.savedItems)
            ..where((row) => row.contentId.equals(contentId)))
          .write(values)
          .then((_) {});

  @override
  Future<void> updateNote(String contentId, String? note) => _update(
    contentId,
    db.SavedItemsCompanion(
      note: Value(normalizeSavedItemNote(note)),
      updatedAtUtcMs: Value(_milliseconds(_utcNow)),
    ),
  );
  @override
  Future<void> updateStatus(String contentId, SavedItemStatus status) =>
      _update(
        contentId,
        db.SavedItemsCompanion(
          status: Value(status.name),
          updatedAtUtcMs: Value(_milliseconds(_utcNow)),
        ),
      );
  @override
  Future<void> assignCollection(String contentId, String? collectionId) =>
      _update(
        contentId,
        db.SavedItemsCompanion(
          collectionId: Value(collectionId),
          updatedAtUtcMs: Value(_milliseconds(_utcNow)),
        ),
      );

  @override
  Future<void> updateDetails(
    String contentId, {
    required String? note,
    required SavedItemStatus status,
    required String? collectionId,
  }) => _update(
    contentId,
    db.SavedItemsCompanion(
      note: Value(normalizeSavedItemNote(note)),
      status: Value(status.name),
      collectionId: Value(collectionId),
      updatedAtUtcMs: Value(_milliseconds(_utcNow)),
    ),
  );

  @override
  Stream<List<CollectionWithCount>> watchCollections() => _database
      .customSelect(
        'SELECT c.id, c.name, c.created_at_utc_ms, c.updated_at_utc_ms, count(s.id) AS saved_item_count FROM collections c LEFT JOIN saved_items s ON s.collection_id = c.id GROUP BY c.id ORDER BY c.updated_at_utc_ms DESC, c.id ASC',
        readsFrom: {_database.collections, _database.savedItems},
      )
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => CollectionWithCount(
                collection: collectionFromRow(
                  db.Collection(
                    id: row.read<String>('id'),
                    name: row.read<String>('name'),
                    createdAtUtcMs: row.read<int>('created_at_utc_ms'),
                    updatedAtUtcMs: row.read<int>('updated_at_utc_ms'),
                  ),
                ),
                savedItemCount: row.read<int>('saved_item_count'),
              ),
            )
            .toList(growable: false),
      );

  @override
  Future<Collection> createCollection(String name) async {
    final now = _utcNow;
    final collection = Collection(
      id: _uuid.v4(),
      name: name,
      createdAtUtc: now,
      updatedAtUtc: now,
    );
    await _database
        .into(_database.collections)
        .insert(
          db.CollectionsCompanion.insert(
            id: collection.id,
            name: collection.name,
            createdAtUtcMs: _milliseconds(now),
            updatedAtUtcMs: _milliseconds(now),
          ),
        );
    return collection;
  }

  @override
  Future<void> renameCollection(String id, String name) async {
    final normalized = Collection(
      id: id,
      name: name,
      createdAtUtc: _utcNow,
      updatedAtUtc: _utcNow,
    ).name;
    await (_database.update(
      _database.collections,
    )..where((row) => row.id.equals(id))).write(
      db.CollectionsCompanion(
        name: Value(normalized),
        updatedAtUtcMs: Value(_milliseconds(_utcNow)),
      ),
    );
  }

  @override
  Future<void> deleteCollection(String id) => (_database.delete(
    _database.collections,
  )..where((row) => row.id.equals(id))).go().then((_) {});
}
