import 'package:example/config/app_layout.dart';
import 'package:example/features/common/presentation/utils/extensions/ui_extension.dart';
import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/values/department_name.dart';
import 'package:example/features/departments/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class DepartmentEditForm extends ConsumerStatefulWidget {
  ///
  const DepartmentEditForm({
    super.key,
    required this.id,
  });

  ///
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DepartmentEditFormState();
}

class _DepartmentEditFormState extends ConsumerState<DepartmentEditForm> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DepartmentName? _name;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ref.listenOnce(departmentsEditControllerProvider(widget.id), (
      AsyncValue<DepartmentEntity>? prev,
      AsyncValue<DepartmentEntity> next,
    ) {
      final v = next.asData!.value.name;
      _nameController.text = v;
      _name = DepartmentName(v);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final department = ref.watch(departmentsEditControllerProvider(widget.id));

    final errorText = department.maybeWhen(
      error: (error, stackTrace) => error.toString(),
      orElse: () => null,
    );

    final isLoading = department.maybeWhen(
      data: (_) => department.isRefreshing,
      loading: () => true,
      orElse: () => false,
    );

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onChanged: (value) => _name = DepartmentName(value),
              controller: _nameController,
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
                      ref
                          .read(
                            departmentsEditControllerProvider(widget.id)
                                .notifier,
                          )
                          .handle(_name!);
                    },
              child: isLoading
                  ? const Text('Loading ...')
                  : Text(context.tr.departmentUpdateBtn),
            ),
          ],
        ),
      ),
    );
  }
}
