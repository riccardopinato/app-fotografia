import 'dart:convert';
import 'dart:io';

class WorkspaceIngestManifest {
  const WorkspaceIngestManifest({
    required this.source,
    required this.document,
    required this.extractedText,
  });

  final WorkspaceSourceInput source;
  final WorkspaceDocumentInput document;
  final String extractedText;

  static Future<WorkspaceIngestManifest> load(File manifestFile) async {
    final root = _object(jsonDecode(await manifestFile.readAsString()), r'$');
    if (_string(root, 'formatVersion') != '1.0') {
      throw const FormatException(
        'Workspace ingest formatVersion must be "1.0".',
      );
    }
    final source = WorkspaceSourceInput.fromJson(
      _object(root['source'], r'$.source'),
    );
    final document = WorkspaceDocumentInput.fromJson(
      _object(root['document'], r'$.document'),
    );
    final textFile = File(
      _resolveRelative(manifestFile.parent, document.extractedTextPath),
    );
    if (!await textFile.exists()) {
      throw FormatException('Extracted text does not exist: ${textFile.path}');
    }
    final text = await textFile.readAsString();
    if (text.trim().isEmpty) {
      throw const FormatException('Extracted text is empty.');
    }
    return WorkspaceIngestManifest(
      source: source,
      document: document,
      extractedText: text,
    );
  }
}

class WorkspaceSourceInput {
  const WorkspaceSourceInput({
    required this.id,
    required this.title,
    required this.originalLocale,
    required this.sourceType,
    required this.licenseType,
    required this.rightsStatus,
    required this.verificationStatus,
    required this.attributionRequired,
    required this.tdmReserved,
    this.author,
    this.publisher,
    this.issue,
    this.publicationDate,
    this.licenseUrl,
    this.attributionText,
    this.rightsEvidence,
    this.restrictions,
  });

  final String id;
  final String title;
  final String? author;
  final String? publisher;
  final String? issue;
  final String? publicationDate;
  final String originalLocale;
  final String sourceType;
  final String licenseType;
  final String? licenseUrl;
  final String rightsStatus;
  final String verificationStatus;
  final bool attributionRequired;
  final String? attributionText;
  final String? rightsEvidence;
  final String? restrictions;
  final bool tdmReserved;

  factory WorkspaceSourceInput.fromJson(Map<String, Object?> json) =>
      WorkspaceSourceInput(
        id: _string(json, 'id'),
        title: _string(json, 'title'),
        author: _optionalString(json['author']),
        publisher: _optionalString(json['publisher']),
        issue: _optionalString(json['issue']),
        publicationDate: _optionalString(json['publicationDate']),
        originalLocale: _string(json, 'originalLocale'),
        sourceType: _string(json, 'sourceType'),
        licenseType: _string(json, 'licenseType'),
        licenseUrl: _optionalString(json['licenseUrl']),
        rightsStatus: _string(json, 'rightsStatus'),
        verificationStatus: _string(json, 'verificationStatus'),
        attributionRequired: json['attributionRequired'] == true,
        attributionText: _optionalString(json['attributionText']),
        rightsEvidence: _optionalString(json['rightsEvidence']),
        restrictions: _optionalString(json['restrictions']),
        tdmReserved: json['tdmReserved'] == true,
      );
}

class WorkspaceDocumentInput {
  const WorkspaceDocumentInput({
    required this.id,
    required this.title,
    required this.extractedTextPath,
    required this.extractionMethod,
    this.originalFilePath,
    this.pageStart,
    this.pageEnd,
  });

  final String id;
  final String title;
  final String extractedTextPath;
  final String extractionMethod;
  final String? originalFilePath;
  final int? pageStart;
  final int? pageEnd;

  factory WorkspaceDocumentInput.fromJson(Map<String, Object?> json) {
    final extractionMethod = _string(json, 'extractionMethod');
    if (!{'manual', 'pdftotext', 'ocr'}.contains(extractionMethod)) {
      throw FormatException(
        'Unsupported extractionMethod "$extractionMethod".',
      );
    }
    return WorkspaceDocumentInput(
      id: _string(json, 'id'),
      title: _string(json, 'title'),
      extractedTextPath: _string(json, 'extractedTextPath'),
      extractionMethod: extractionMethod,
      originalFilePath: _optionalString(json['originalFilePath']),
      pageStart: _optionalPositiveInt(json['pageStart'], 'pageStart'),
      pageEnd: _optionalPositiveInt(json['pageEnd'], 'pageEnd'),
    );
  }
}

class WorkspaceDraftInput {
  const WorkspaceDraftInput({
    required this.id,
    required this.version,
    required this.type,
    required this.category,
    required this.difficulty,
    required this.canonicalLocale,
    required this.premium,
    required this.tags,
    required this.sourceIds,
    required this.fragmentIds,
    required this.translations,
  });

  final String id;
  final int version;
  final String type;
  final String category;
  final String difficulty;
  final String canonicalLocale;
  final bool premium;
  final List<String> tags;
  final List<String> sourceIds;
  final List<String> fragmentIds;
  final List<WorkspaceTranslationInput> translations;

  static Future<WorkspaceDraftInput> load(File file) async {
    final root = _object(jsonDecode(await file.readAsString()), r'$');
    if (_string(root, 'formatVersion') != '1.0') {
      throw const FormatException(
        'Workspace draft formatVersion must be "1.0".',
      );
    }
    final translations = _list(root, 'translations')
        .map((value) => WorkspaceTranslationInput.fromJson(_object(value, '')))
        .toList(growable: false);
    final input = WorkspaceDraftInput(
      id: _string(root, 'id'),
      version: _positiveInt(root['version'], 'version'),
      type: _string(root, 'type'),
      category: _string(root, 'category'),
      difficulty: _string(root, 'difficulty'),
      canonicalLocale: _string(root, 'canonicalLocale'),
      premium: root['premium'] == true,
      tags: _stringList(root, 'tags'),
      sourceIds: _stringList(root, 'sourceIds'),
      fragmentIds: _stringList(root, 'fragmentIds'),
      translations: translations,
    );
    if (input.sourceIds.isEmpty || input.fragmentIds.isEmpty) {
      throw const FormatException(
        'A workspace draft needs at least one source and one fragment.',
      );
    }
    if (!translations.any(
      (translation) => translation.locale == input.canonicalLocale,
    )) {
      throw const FormatException(
        'The canonical translation is missing from the draft.',
      );
    }
    return input;
  }
}

class WorkspaceTranslationInput {
  const WorkspaceTranslationInput({
    required this.locale,
    required this.title,
    required this.summary,
    required this.body,
    required this.method,
    required this.searchTerms,
  });

  final String locale;
  final String title;
  final String summary;
  final String body;
  final String method;
  final List<String> searchTerms;

  factory WorkspaceTranslationInput.fromJson(Map<String, Object?> json) =>
      WorkspaceTranslationInput(
        locale: _string(json, 'locale'),
        title: _string(json, 'title'),
        summary: _string(json, 'summary'),
        body: _string(json, 'body'),
        method: _string(json, 'method'),
        searchTerms: _stringList(json, 'searchTerms'),
      );
}

class WorkspaceReviewDecision {
  const WorkspaceReviewDecision({
    required this.taskId,
    required this.reviewer,
    required this.decision,
    this.note,
  });

  final String taskId;
  final String reviewer;
  final String decision;
  final String? note;

  static Future<WorkspaceReviewDecision> load(File file) async {
    final root = _object(jsonDecode(await file.readAsString()), r'$');
    final decision = _string(root, 'decision');
    if (!{'approved', 'rejected', 'changesRequested'}.contains(decision)) {
      throw FormatException('Unsupported review decision "$decision".');
    }
    return WorkspaceReviewDecision(
      taskId: _string(root, 'taskId'),
      reviewer: _string(root, 'reviewer'),
      decision: decision,
      note: _optionalString(root['note']),
    );
  }
}

class WorkspaceReviewTask {
  const WorkspaceReviewTask({
    required this.id,
    required this.draftId,
    required this.kind,
    required this.status,
    required this.createdAt,
    this.locale,
    this.reviewer,
    this.note,
    this.decidedAt,
  });

  final String id;
  final String draftId;
  final String kind;
  final String? locale;
  final String status;
  final String? reviewer;
  final String? note;
  final String createdAt;
  final String? decidedAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'draftId': draftId,
    'kind': kind,
    if (locale != null) 'locale': locale,
    'status': status,
    if (reviewer != null) 'reviewer': reviewer,
    if (note != null) 'note': note,
    'createdAt': createdAt,
    if (decidedAt != null) 'decidedAt': decidedAt,
  };
}

class WorkspaceFragmentHit {
  const WorkspaceFragmentHit({
    required this.id,
    required this.documentId,
    required this.sourceId,
    required this.documentTitle,
    required this.excerpt,
  });

  final String id;
  final String documentId;
  final String sourceId;
  final String documentTitle;
  final String excerpt;

  Map<String, Object?> toJson() => {
    'id': id,
    'documentId': documentId,
    'sourceId': sourceId,
    'documentTitle': documentTitle,
    'excerpt': excerpt,
  };
}

class WorkspaceIngestResult {
  const WorkspaceIngestResult({
    required this.documentInserted,
    required this.fragmentsInserted,
    required this.duplicatesDetected,
  });

  final bool documentInserted;
  final int fragmentsInserted;
  final int duplicatesDetected;
}

class WorkspaceDraftResult {
  const WorkspaceDraftResult({
    required this.inserted,
    required this.version,
    required this.reviewTasks,
  });

  final bool inserted;
  final int version;
  final int reviewTasks;
}

class WorkspaceExportResult {
  const WorkspaceExportResult({
    required this.packageVersion,
    required this.contents,
    required this.checksum,
    required this.file,
  });

  final int packageVersion;
  final int contents;
  final String checksum;
  final File file;
}

Map<String, Object?> _object(Object? value, String path) {
  if (value is Map<String, Object?>) return value;
  throw FormatException('Expected an object at $path.');
}

List<Object?> _list(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is List<Object?>) return value;
  throw FormatException('Expected an array at $key.');
}

String _string(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) return value.trim();
  throw FormatException('Expected a non-empty string at $key.');
}

String? _optionalString(Object? value) =>
    value is String && value.trim().isNotEmpty ? value.trim() : null;

int _positiveInt(Object? value, String key) {
  if (value is int && value > 0) return value;
  throw FormatException('Expected a positive integer at $key.');
}

int? _optionalPositiveInt(Object? value, String key) =>
    value == null ? null : _positiveInt(value, key);

List<String> _stringList(Map<String, Object?> json, String key) {
  final values = _list(json, key);
  final result = values
      .map((value) {
        if (value is String && value.trim().isNotEmpty) return value.trim();
        throw FormatException('Expected non-empty strings in $key.');
      })
      .toSet()
      .toList(growable: false);
  return result;
}

String _resolveRelative(Directory base, String path) {
  final candidate = File(path);
  if (candidate.isAbsolute) return candidate.path;
  return File('${base.path}${Platform.pathSeparator}$path').path;
}
