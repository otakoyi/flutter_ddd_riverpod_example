import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'organization_view_controller.g.dart';

///
@riverpod
class OrganizationViewController extends _$OrganizationViewController {
  @override
  FutureOr<OrganizationEntity> build(String id) async {
    final res = await ref.watch(organizationRepositoryProvider).getOrganizationById(id);
    return res.fold((l) => throw l, (r) {
      // !Incorrect implementation, needs to be redone
      ref.read(currentOrganizationProvider.notifier).org = r;
      return r;
    });
  }
}
