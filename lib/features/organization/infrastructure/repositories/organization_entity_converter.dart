import 'package:example/features/organization/domain/entities/organization_entity.dart';

///
class OrganizationEntityConverter {
  /// Converter from json to lists of organization entity
  static List<OrganizationEntity> toList(dynamic data) {
    return (data as List<dynamic>)
        .map((e) => OrganizationEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  ///
  static OrganizationEntity toSingle(dynamic data) {
    return OrganizationEntity.fromJson(
      (data as List).first as Map<String, dynamic>,
    );
  }
}
