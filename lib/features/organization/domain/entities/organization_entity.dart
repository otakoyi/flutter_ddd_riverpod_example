import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_entity.freezed.dart';
part 'organization_entity.g.dart';

/// [OrganizationEntity] model
@freezed
class OrganizationEntity with _$OrganizationEntity {
  /// Factory constructor
  /// [id] - [OrganizationEntity] id. Null if organization hasn't been created in the database
  /// [name] - [OrganizationEntity] name
  /// [createdAt] - [OrganizationEntity] create timestamp
  /// [ownerId] - [OrganizationEntity] owner id
  /// [settings] - [OrganizationEntity] settings of type json
  /// [updatedAt] - [OrganizationEntity] update timestamp
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OrganizationEntity({
    required String ownerId,
    @JsonKey(includeIfNull: false) String? id,
    @Default('') String name,
    @JsonKey(includeIfNull: false) String? description,
    @JsonKey(includeIfNull: false) String? createdAt,
    Map<String, dynamic>? settings,
    @JsonKey(includeIfNull: false) String? updatedAt,
  }) = _OrganizationEntity;

  /// Serialization
  factory OrganizationEntity.fromJson(Map<String, dynamic> json) =>
      _$OrganizationEntityFromJson(json);

  // @override
  // Map<String, dynamic> toJson() => _$OrganizationEntityToJson(this);
}
