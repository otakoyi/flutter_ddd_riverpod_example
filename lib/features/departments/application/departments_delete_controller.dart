import 'package:example/features/departments/domain/repositories/department_repository_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class DepartmentsDeleteController extends StateNotifier<AsyncValue<bool>> {
  ///
  DepartmentsDeleteController(this._repository, this._id)
      : super(const AsyncValue.loading());

  final DepartmentRepositoryInterface _repository;
  final String _id;

  /// Get department by id
  Future<void> handle() async {
    final res = await _repository.deleteDepartment(_id);
    state = res.fold((l) => AsyncValue.error(l.toString()), AsyncValue.data);
  }
}
