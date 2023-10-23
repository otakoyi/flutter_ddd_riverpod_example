import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/values/department_name.dart';
import 'package:example/features/departments/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'departments_edit_controller.g.dart';

///
@riverpod
class DepartmentsEditController extends _$DepartmentsEditController {
  @override
  FutureOr<DepartmentEntity> build(String id) async {
    final res = await ref.watch(departmentsRepositoryProvider).getDepartmentById(id);

    return res.fold((l) => throw l, (r) => r);
  }

  /// save updated department
  Future<void> handle(DepartmentName name) async {
    state = const AsyncValue.loading();
    final res = await ref.read(departmentsRepositoryProvider).updateDepartment(id, name);
    state = res.fold((l) => AsyncValue.error(l.error, StackTrace.current), AsyncValue.data);
  }
}
