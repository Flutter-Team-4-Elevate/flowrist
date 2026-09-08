import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

abstract class AppConfig {
  String get mapTilerApiKey;
}

@LazySingleton(as: AppConfig)
class AppConfigImpl implements AppConfig {
  @override
  String get mapTilerApiKey => dotenv.env['MAPTILER_API_KEY'] ?? '';
}
