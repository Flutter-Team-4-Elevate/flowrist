import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class UuidGenerator {
  String generate();
}

@LazySingleton(as: UuidGenerator)
class UuidGeneratorImpl implements UuidGenerator {
  const UuidGeneratorImpl();

  @override
  String generate() => const Uuid().v4();
}