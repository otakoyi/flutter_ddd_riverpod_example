import 'package:example/config/app_layout.dart';
import 'package:example/features/common/presentation/utils/extensions/ui_extension.dart';
import 'package:example/features/departments/application/departments_create_controller.dart';
import 'package:example/features/departments/application/departments_list_controller.dart';
import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/values/department_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

///
class DepartmentCreateForm extends ConsumerStatefulWidget {
  ///
  const DepartmentCreateForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DepartmentCreateFormState();
}

class _DepartmentCreateFormState extends ConsumerState<DepartmentCreateForm> {
  final _formKey = GlobalKey<FormState>();
  DepartmentName? _name;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<DepartmentEntity?>>(departmentsCreateControllerProvider,
        (previous, next) {
      next.maybeWhen(
        data: (data) {
          if (data == null) return;
          ref.read(departmentsListControllerProvider.notifier).addDepartment(data);
          context.pop();
        },
        orElse: () {},
      );
    });

    final res = ref.watch(departmentsCreateControllerProvider);
    final errorText = res.maybeWhen(
      error: (error, stackTrace) => error.toString(),
      orElse: () => null,
    );

    final isLoading = res.maybeWhen(
      data: (_) => res.isRefreshing,
      loading: () => true,
      orElse: () => false,
    );

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onChanged: (value) => _name = DepartmentName(value),
              decoration: InputDecoration(
                hintText: context.tr.departmentCreateFormFieldHintText,
                errorText: errorText,
              ),
              validator: (value) => _name?.validate,
              readOnly: isLoading,
            ),
            const SizedBox(
              height: AppLayout.defaultPadding,
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      if (_name == null) return;

                      ref.read(departmentsCreateControllerProvider.notifier).handle(_name!);
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(context.tr.departmentCreateBtn),
            ),
          ],
        ),
      ),
    );
  }
}
