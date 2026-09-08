import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String phone;
  final String name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
  });

  @override
  List<Object?> get props => [id, email, phone, name];
}
