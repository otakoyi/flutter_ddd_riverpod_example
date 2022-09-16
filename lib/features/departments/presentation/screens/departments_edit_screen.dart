import 'package:example/features/departments/presentation/widgets/department_edit_form.dart';
import 'package:example/features/departments/providers.dart';
import 'package:example/features/organization/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Departments list
class DepartmentsEditScreen extends ConsumerWidget {
  /// Departments list constructor
  const DepartmentsEditScreen({
    super.key,
    required this.id,
  });

  /// Department id
  final String id;

  /// route name
  static const routeName = 'department_edit';

  ///
  static const routePath = 'department/:did/edit';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final department = ref.watch(departmentsEditControllerProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: department.when(
          data: (d) => Text(
            '${ref.read(currentOrganizationProvider)?.name} / Departments / ${d.name}',
          ),
          error: (error, stackTrace) => const Text('Error'),
          loading: () => const Text('Loading...'),
        ),
      ),
      body: DepartmentEditForm(
        id: id,
      ),
    );
  }
}
