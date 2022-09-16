import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/domain/values/organization_name.dart';
import 'package:example/features/organization/infrastructure/repositories/organization_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class OrganizationCreateController
    extends StateNotifier<AsyncValue<OrganizationEntity?>> {
  ///
  OrganizationCreateController(OrganizationRepository? repository)
      : super(const AsyncValue.data(null)) {
    if (repository == null) {
      state = const AsyncValue.error(Failure.unauthorized());
      return;
    }
    _repository = repository;
  }

  late final OrganizationRepository _repository;

  /// Create organization
  Future<void> create(OrganizationName name, String description) async {
    state = const AsyncValue.loading();
    final res = await _repository.createOrganization(name);
    state = res.fold(
      (l) => AsyncValue<OrganizationEntity?>.error(l.toString()),
      AsyncValue<OrganizationEntity?>.data,
    );
  }
}
