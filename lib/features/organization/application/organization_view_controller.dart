import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'organization_view_controller.g.dart';

///
@riverpod
class OrganizationViewController extends _$OrganizationViewController {
  @override
  FutureOr<OrganizationEntity> build(String id) async {
    final repository = ref.watch(organizationRepositoryProvider);
    if (repository == null) {
      throw Failure.unauthorized(StackTrace.current);
    }

    final res = await repository.getOrganizationById(id);
    ref.read(currentOrganizationProvider.notifier).state =
        res.fold((l) => null, (r) => r);
    return res.fold(
      (l) => throw l,
      (r) => r,
    );
  }
}
