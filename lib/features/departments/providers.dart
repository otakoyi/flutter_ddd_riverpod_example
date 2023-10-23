import 'package:example/config/providers.dart';
import 'package:example/features/departments/infrastructure/repositories/department_repository.dart';
import 'package:example/features/organization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

///
/// Infrastructure dependencies
///

@riverpod
DepartmentRepository departmentsRepository(DepartmentsRepositoryRef ref) {
  final organization = ref.watch(currentOrganizationProvider);
  if (organization == null) {
    throw UnimplementedError(
      'OrganizationEntity was not selected',
    );
  }
  return DepartmentRepository(
    client: ref.watch(supabaseClientProvider),
    organization: organization,
  );
}
