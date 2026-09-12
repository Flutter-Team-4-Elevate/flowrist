import 'home_payload_entity.dart';

class BannerPayloadEntity extends HomePayloadEntity {
  final String imageUrl;
  final String clickAction;

  const BannerPayloadEntity({
    required super.type,
    required this.imageUrl,
    required this.clickAction,
  });
}
