import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_entity.freezed.dart';
part 'department_entity.g.dart';

/// [DepartmentEntity] model
@freezed
class DepartmentEntity with _$DepartmentEntity {
  /// Factory constructor
  /// [id] - [DepartmentEntity] id
  /// [name] - [DepartmentEntity] name
  /// [createdAt] - [DepartmentEntity] create timestamp
  /// [organizationId] - [DepartmentEntity] organization id
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DepartmentEntity({
    required String organizationId,
    @JsonKey(includeIfNull: false) String? id,
    @Default('') String name,
    @JsonKey(includeIfNull: false) String? createdAt,
    @JsonKey(includeIfNull: false) String? updatedAt,
  }) = _DepartmentEntity;

  /// Serialization
  factory DepartmentEntity.fromJson(Map<String, dynamic> json) => _$DepartmentEntityFromJson(json);
}
