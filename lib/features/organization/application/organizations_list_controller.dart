import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'organizations_list_controller.g.dart';

///
@riverpod
class OrganizationListController extends _$OrganizationListController {
  @override
  FutureOr<List<OrganizationEntity>> build() async {
    final res = await ref.watch(organizationRepositoryProvider).getOrganizations();
    return res.fold((l) => throw l, (r) => r);
  }

  /// Add organization to the list after creating it
  void addOrganization(OrganizationEntity organization) {
    state = state.whenData((value) => value..add(organization));
  }
}
