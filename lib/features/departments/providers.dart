import 'package:example/config/providers.dart';
import 'package:example/features/departments/application/departments_create_controller.dart';
import 'package:example/features/departments/application/departments_delete_controller.dart';
import 'package:example/features/departments/application/departments_edit_controller.dart';
import 'package:example/features/departments/application/departments_list_controller.dart';
import 'package:example/features/departments/application/departments_view_controller.dart';
import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/repositories/department_repository_interface.dart';
import 'package:example/features/departments/infrastructure/repositories/department_repository.dart';
import 'package:example/features/organization/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// Infrastructure dependencies
///

final departmentsRepositoryProvider =
    Provider<DepartmentRepositoryInterface>((ref) {
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
});

///
/// Application dependencies
///
final departmentsListControllerProvider = StateNotifierProvider<
    DepartmentsListController, AsyncValue<List<DepartmentEntity>>>((ref) {
  final repo = ref.watch(departmentsRepositoryProvider);

  return DepartmentsListController(repo);
});

///

final departmentsCreateControllerProvider = StateNotifierProvider.autoDispose<
    DepartmentsCreateController, AsyncValue<DepartmentEntity?>>((ref) {
  final repo = ref.watch(departmentsRepositoryProvider);

  return DepartmentsCreateController(repo);
});

///
final departmentsViewControllerProvider = StateNotifierProvider.family
    .autoDispose<DepartmentsViewController, AsyncValue<DepartmentEntity>,
        String>((ref, id) {
  final repo = ref.watch(departmentsRepositoryProvider);
  return DepartmentsViewController(repo, id);
});

///
final departmentsEditControllerProvider = StateNotifierProvider.family
    .autoDispose<DepartmentsEditController, AsyncValue<DepartmentEntity>,
        String>((ref, id) {
  final repo = ref.watch(departmentsRepositoryProvider);
  return DepartmentsEditController(repo, id);
});

///
final departmentsDeleteControllerProvider = StateNotifierProvider.family
    .autoDispose<DepartmentsDeleteController, AsyncValue<bool>, String>(
        (ref, id) {
  final repo = ref.watch(departmentsRepositoryProvider);

  return DepartmentsDeleteController(repo, id);
});
