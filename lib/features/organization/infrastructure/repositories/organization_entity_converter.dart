import 'package:example/features/organization/domain/entities/organization_entity.dart';

///
class OrganizationEntityConverter {
  /// Converter from json to lists of organization entity
  static List<OrganizationEntity> toList(dynamic data) {
    return (data as List<dynamic>)
        .map((e) => OrganizationEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
