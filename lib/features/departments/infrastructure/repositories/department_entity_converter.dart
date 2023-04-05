import 'package:example/features/departments/domain/entities/department_entity.dart';

/// Converter from json to entity
class DepartmentEntityConverter {
  /// Converter from json to lists of  entity
  static List<DepartmentEntity> toList(dynamic data) {
    return (data as List<dynamic>)
        .map((e) => DepartmentEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
