import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/repositories/department_repository_interface.dart';
import 'package:example/features/departments/domain/values/department_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class DepartmentsCreateController
    extends StateNotifier<AsyncValue<DepartmentEntity?>> {
  ///
  DepartmentsCreateController(this._repository)
      : super(const AsyncValue.data(null));

  final DepartmentRepositoryInterface _repository;

  /// save department
  Future<void> handle(DepartmentName name) async {
    state = const AsyncLoading();
    final res = await _repository.createDepartment(name);
    state = res.fold(
      (l) => AsyncValue.error(l.error, l.stackTrace),
      AsyncValue.data,
    );
  }
}
