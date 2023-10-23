import 'package:example/features/departments/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'departments_delete_controller.g.dart';

///
@riverpod
class DepartmentsDeleteController extends _$DepartmentsDeleteController {
  @override
  FutureOr<bool> build(String id) {
    return false;
  }

  ///
  Future<void> handle() async {
    final res = await ref.read(departmentsRepositoryProvider).deleteDepartment(id);
    state = res.fold((l) => AsyncValue.error(l.toString(), StackTrace.current), AsyncValue.data);
  }
}
