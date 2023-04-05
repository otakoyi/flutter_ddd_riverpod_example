import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/repositories/department_repository_interface.dart';
import 'package:example/features/departments/domain/values/department_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class DepartmentsEditController
    extends StateNotifier<AsyncValue<DepartmentEntity>> {
  ///
  DepartmentsEditController(this._repository, this._id)
      : super(const AsyncValue.loading()) {
    _get();
  }

  final DepartmentRepositoryInterface _repository;
  final String _id;

  /// Get department by id
  Future<void> _get() async {
    final res = await _repository.getDepartmentById(_id);
    state = res.fold(
      (l) => AsyncValue.error(l.error, l.stackTrace),
      AsyncValue.data,
    );
  }

  /// save updated department
  Future<void> handle(DepartmentName name) async {
    state = const AsyncValue.loading();
    final res = await _repository.updateDepartment(_id, name);
    state = res.fold(
      (l) => AsyncValue.error(l.error, l.stackTrace),
      AsyncValue.data,
    );
  }
}
