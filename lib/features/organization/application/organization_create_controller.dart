import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/domain/values/organization_name.dart';
import 'package:example/features/organization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'organization_create_controller.g.dart';

///
@riverpod
class OrganizationCreateController extends _$OrganizationCreateController {
  @override
  FutureOr<OrganizationEntity?> build() {
    return null;
  }

  ///
  Future<void> create(OrganizationName name, String description) async {
    state = const AsyncValue.loading();
    final res = await ref.read(organizationRepositoryProvider).createOrganization(name);
    state = res.fold(
      (l) => AsyncValue<OrganizationEntity?>.error(l.toString(), StackTrace.current),
      AsyncValue<OrganizationEntity?>.data,
    );
  }
}
