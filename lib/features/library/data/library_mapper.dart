import '../../../core/database/app_database.dart' as db;
import '../domain/library_models.dart';

DateTime _utc(int value) =>
    DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);

SavedItemStatus savedItemStatusFromDb(String value) =>
    SavedItemStatus.values.byName(value);

Collection collectionFromRow(db.Collection row) => Collection(
  id: row.id,
  name: row.name,
  createdAtUtc: _utc(row.createdAtUtcMs),
  updatedAtUtc: _utc(row.updatedAtUtcMs),
);

SavedItem savedItemFromRow(db.SavedItem row) => SavedItem(
  id: row.id,
  contentId: row.contentId,
  collectionId: row.collectionId,
  note: row.note,
  status: savedItemStatusFromDb(row.status),
  savedAtUtc: _utc(row.savedAtUtcMs),
  updatedAtUtc: _utc(row.updatedAtUtcMs),
);
