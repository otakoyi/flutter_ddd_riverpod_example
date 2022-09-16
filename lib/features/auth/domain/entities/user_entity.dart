import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed

/// Auth user entity
class UserEntity with _$UserEntity {
  @JsonSerializable(fieldRename: FieldRename.snake)

  /// Factory Constructor
  const factory UserEntity({
    required String id,
    required String email,
    required String phone,
    @JsonKey(includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) DateTime? updatedAt,
    @JsonKey(includeIfNull: false) DateTime? emailConfirmedAt,
    @JsonKey(includeIfNull: false) DateTime? phoneConfirmedAt,
    @JsonKey(includeIfNull: false) DateTime? lastSignInAt,
    String? role,
  }) = _UserEntity;

  /// factory method to create entity from JSON
  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
