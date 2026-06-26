import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

// Hive typeId: 0 — never reuse this typeId
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? name;

  UserModel({
    required this.id,
    required this.email,
    this.name,
  });

  /// Build a UserModel from a Supabase Auth [User] object.
  /// JWT is managed automatically by the SDK — we only cache the profile data.
  factory UserModel.fromSupabase(User user) => UserModel(
        id: user.id,
        email: user.email ?? '',
        name: user.userMetadata?['name'] as String?,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        name: name,
      );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        email: entity.email,
        name: entity.name,
      );
}
