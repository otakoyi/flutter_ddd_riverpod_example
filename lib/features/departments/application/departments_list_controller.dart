import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'departments_list_controller.g.dart';

///
@riverpod
class DepartmentsListController extends _$DepartmentsListController {
  @override
  FutureOr<List<DepartmentEntity>> build() async {
    final res = await ref.watch(departmentsRepositoryProvider).getDepartments();
    return res.fold((l) => throw l, (r) => r);
  }

  /// Add an entity to list
  void addDepartment(DepartmentEntity entity) {
    final items = state.valueOrNull ?? [];

    state = const AsyncValue.loading();

    items.add(entity);
    state = AsyncValue.data(items);
  }

  ///
  void updateDepartment(DepartmentEntity entity) {
    final items = state.valueOrNull ?? [];

    state = const AsyncValue.loading();

    final i = items.indexWhere((element) => element.id == entity.id);
    if (i != -1) {
      items
        ..removeAt(i)
        ..insert(i, entity);
    }
    state = AsyncValue.data(items);
  }

  ///
  void deleteDepartment(DepartmentEntity entity) {
    final items = state.valueOrNull ?? [];

    state = const AsyncValue.loading();

    items.remove(entity);
    state = AsyncValue.data(items);
  }
}
