enum SavedItemStatus { toTry, tried, completed }

String? normalizeSavedItemNote(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

class Collection {
  Collection({
    required this.id,
    required String name,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
  }) : name = _normalizeName(name),
       createdAtUtc = createdAtUtc.toUtc(),
       updatedAtUtc = updatedAtUtc.toUtc();

  final String id;
  final String name;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  static String _normalizeName(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(value, 'name', 'must not be empty');
    }
    return normalized;
  }
}

class SavedItem {
  SavedItem({
    required this.id,
    required this.contentId,
    this.collectionId,
    String? note,
    this.status = SavedItemStatus.toTry,
    required DateTime savedAtUtc,
    required DateTime updatedAtUtc,
  }) : note = normalizeSavedItemNote(note),
       savedAtUtc = savedAtUtc.toUtc(),
       updatedAtUtc = updatedAtUtc.toUtc();

  final String id;
  final String contentId;
  final String? collectionId;
  final String? note;
  final SavedItemStatus status;
  final DateTime savedAtUtc;
  final DateTime updatedAtUtc;
}

class CollectionWithCount {
  const CollectionWithCount({
    required this.collection,
    required this.savedItemCount,
  });

  final Collection collection;
  final int savedItemCount;
}
