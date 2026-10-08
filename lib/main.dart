import 'package:dose_tracker/app/routes/app.dart';
import 'package:flutter/widgets.dart';

/// App entry point. Services that must be ready before the first frame
/// (database, saved language, session) are initialized here in later steps.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DoseTrackerApp());
}
