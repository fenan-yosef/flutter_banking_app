import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow graceful fallback if offline or network connection is interrupted
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('Failed to load font') ||
        details.exception.toString().contains('ClientException')) {
      debugPrint('Font network load notice: falling back to system sans-serif.');
      return;
    }
    FlutterError.presentError(details);
  };

  // Set transparent status bar with light icons for the dark top container
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const BankingApp());
}
