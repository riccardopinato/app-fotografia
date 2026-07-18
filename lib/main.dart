import 'package:flutter/widgets.dart';

import 'app/frame_lab_app.dart';
import 'core/database/app_database.dart';
import 'features/catalog/data/frame_lab_seed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await FrameLabSeed.install(database);
  runApp(FrameLabApp(database: database));
}
