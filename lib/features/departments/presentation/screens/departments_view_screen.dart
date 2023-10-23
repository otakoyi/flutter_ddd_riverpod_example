import 'package:example/features/common/presentation/widgets/app_error.dart';
import 'package:example/features/departments/application/departments_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Departments list
class DepartmentsViewScreen extends ConsumerWidget {
  /// Departments list constructor
  const DepartmentsViewScreen({
    required this.id,
    super.key,
  });

  /// Department id
  final String id;

  /// route name
  static const routeName = 'department_view';

  ///
  static const routePath = 'department/:did';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final department = ref.watch(departmentsViewControllerProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: department.when(
          data: (data) => Text(data.name),
          error: (error, stackTrace) => const Text('Error'),
          loading: () => const Text('Loading ...'),
        ),
      ),
      body: department.when(
        data: (item) => Center(
          child: Text(item.name),
        ),
        error: (o, e) => AppError(
          title: o.toString(),
        ),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
