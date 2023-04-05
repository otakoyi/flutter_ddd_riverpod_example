import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/repositories/department_repository_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class DepartmentsViewController
    extends StateNotifier<AsyncValue<DepartmentEntity>> {
  ///
  DepartmentsViewController(this._repository, this._id)
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
}
