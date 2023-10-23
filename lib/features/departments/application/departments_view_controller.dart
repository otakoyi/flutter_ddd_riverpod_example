import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'departments_view_controller.g.dart';

///
@riverpod
class DepartmentsViewController extends _$DepartmentsViewController {
  @override
  FutureOr<DepartmentEntity> build(String id) async {
    final res = await ref.watch(departmentsRepositoryProvider).getDepartmentById(id);
    return res.fold((l) => throw l, (r) => r);
  }
}
