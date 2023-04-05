import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/repositories/department_repository_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class DepartmentsListController
    extends StateNotifier<AsyncValue<List<DepartmentEntity>>> {
  ///
  DepartmentsListController(this._repository)
      : super(const AsyncValue.loading()) {
    getDepartments();
  }

  final DepartmentRepositoryInterface _repository;

  ///
  Future<void> getDepartments() async {
    final res = await _repository.getDepartments();
    state = res.fold(
      (l) => AsyncValue.error(l.error, l.stackTrace),
      AsyncValue.data,
    );
  }

  /// Add an entity to list
  void addDepartment(DepartmentEntity entity) {
    final items = state.value ?? [];

    state = const AsyncValue.loading();

    items.add(entity);
    state = AsyncValue.data(items);
  }

  ///
  void updateDepartment(DepartmentEntity entity) {
    final items = state.value ?? [];

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
    final items = state.value!;

    state = const AsyncValue.loading();

    items.remove(entity);
    state = AsyncValue.data(items);
  }
}
