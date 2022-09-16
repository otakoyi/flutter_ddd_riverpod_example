import 'package:example/features/departments/presentation/widgets/department_create_form.dart';
import 'package:example/features/organization/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class DepartmentsCreateScreen extends ConsumerWidget {
  ///
  const DepartmentsCreateScreen({super.key});

  /// route name
  static const routeName = 'department_create';

  /// http://localhost:8686/organization/c10300b6-61d2-4bf9-9b67-70610ba75b95
  static const routePath = 'department/create';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${ref.read(currentOrganizationProvider)?.name} / Departments / Create',
        ),
      ),
      body: const DepartmentCreateForm(),
    );
  }
}
