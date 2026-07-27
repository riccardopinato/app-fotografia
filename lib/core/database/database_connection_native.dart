import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// The CLI always supplies its file-backed executor explicitly. This fallback
/// keeps the shared generated database library usable on the standalone VM.
QueryExecutor driftDatabase({required String name}) => NativeDatabase.memory();
