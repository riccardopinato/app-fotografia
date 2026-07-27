import 'package:flutter_test/flutter_test.dart';

import '../integration_test/step_8b_app_ui_journey_test.dart'
    show registerStep8bAppUiJourney;

void main() {
  LiveTestWidgetsFlutterBinding.ensureInitialized();
  registerStep8bAppUiJourney();
}
