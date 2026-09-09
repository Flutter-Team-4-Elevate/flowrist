import 'package:equatable/equatable.dart';

class GiftRecipientEntity extends Equatable {
  final String recipientName;
  final String recipientPhone;

  const GiftRecipientEntity({
    required this.recipientName,
    required this.recipientPhone,
  });

  @override
  List<Object?> get props => [
        recipientName,
        recipientPhone,
      ];
}