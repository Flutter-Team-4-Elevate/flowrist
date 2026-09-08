import '../../../domain/entities/home_entities/home_payload_entity.dart';

abstract class HomePayloadModel {
  final String type;

  const HomePayloadModel({required this.type});

  HomePayloadEntity toEntity();
}
