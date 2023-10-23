import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/values/department_name.dart';
import 'package:example/features/departments/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'departments_create_controller.g.dart';

///
@riverpod
class DepartmentsCreateController extends _$DepartmentsCreateController {
  @override
  FutureOr<DepartmentEntity?> build() {
    return null;
  }

  ///
  Future<void> handle(DepartmentName name) async {
    state = const AsyncLoading();
    final res = await ref.read(departmentsRepositoryProvider).createDepartment(name);
    state = res.fold((l) => AsyncValue.error(l.error, StackTrace.current), AsyncValue.data);
  }
}
