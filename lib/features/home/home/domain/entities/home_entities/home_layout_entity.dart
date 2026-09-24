import 'home_payload_entity.dart';

class HomeLayoutEntity {
  final String id;
  final String type;
  final String title;
  final int order;
  final bool isEnabled;
  final HomePayloadEntity payload;

  const HomeLayoutEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.order,
    required this.isEnabled,
    required this.payload,
  });
}
