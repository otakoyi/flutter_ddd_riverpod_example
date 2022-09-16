import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/infrastructure/repositories/organization_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class OrganizationListController
    extends StateNotifier<AsyncValue<List<OrganizationEntity>>> {
  ///
  OrganizationListController(OrganizationRepository? repository)
      : super(const AsyncValue.loading()) {
    if (repository == null) {
      state = const AsyncValue.error(Failure.unauthorized());
      return;
    }
    _repository = repository;
    _getOrganizations();
  }

  late final OrganizationRepository _repository;

  Future<void> _getOrganizations() async {
    state = const AsyncValue.loading();
    final res = await _repository.getOrganizations();
    state = res.fold((l) => AsyncValue.error(l.toString()), AsyncValue.data);
  }

  /// Add organization to the list after creating it
  void addOrganization(OrganizationEntity organization) {
    state = state.whenData((value) => value..add(organization));
  }

  /// Set current organization
  // void choose(OrganizationEntity entity) {
  //   _read(currentOrganizationProvider.state).update((state) => entity);
  // }
}
