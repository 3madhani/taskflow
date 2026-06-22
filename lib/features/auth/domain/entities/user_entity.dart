import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String username;
  final String phone;
  final String website;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
    required this.website,
  });

  @override
  List<Object?> get props => [id, name, email, username, phone, website];
}
