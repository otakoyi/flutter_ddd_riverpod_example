import 'package:example/config/app_layout.dart';
import 'package:example/features/common/presentation/utils/extensions/ui_extension.dart';
import 'package:example/features/common/presentation/utils/validators.dart';
import 'package:example/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/domain/values/organization_name.dart';
import 'package:example/features/organization/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Form that allows user to enter the name of a new organization and create it
class CreateOrganizationForm extends ConsumerStatefulWidget {
  /// Default constructor for [CreateOrganizationForm]
  const CreateOrganizationForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateOrganizationFormState();
}

class _CreateOrganizationFormState extends ConsumerState<CreateOrganizationForm>
    with FormValidator {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<OrganizationEntity?>>(organizationCreateProvider,
        (previous, next) {
      next.maybeWhen(
        data: (data) {
          if (data != null) {
            ref.read(organizationListProvider.notifier).addOrganization(data);
            context
              ..pop()
              ..push(
                '/${DashboardScreen.routePath}/${data.id}',
              );
          }
        },
        orElse: () {},
      );
    });

    final createResult = ref.watch(organizationCreateProvider);
    final errorText = createResult.maybeWhen(
      error: (error, stackTrace) => error.toString(),
      orElse: () => null,
    );

    final isLoading = createResult.maybeWhen(
      data: (_) => createResult.isRefreshing,
      loading: () => true,
      orElse: () => false,
    );
    return SizedBox(
      width: 600,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppLayout.defaultPadding),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: context.tr.organizationName,
                    border: const OutlineInputBorder(),
                    errorText: errorText,
                  ),
                  validator: organizationNameValidator,
                  readOnly: isLoading,
                ),
                const SizedBox(
                  height: AppLayout.defaultPadding * 2,
                ),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: context.tr.description,
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 128,
                  maxLines: null,
                ),
                const SizedBox(
                  height: 52,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: context.colorScheme.onSecondary,
                        backgroundColor: context.colorScheme.secondary,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(context.tr.cancel),
                    ),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!(formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              ref
                                  .read(organizationCreateProvider.notifier)
                                  .create(
                                    OrganizationName(
                                      nameController.text.trim(),
                                    ),
                                    descriptionController.text.trim(),
                                  );
                            },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(context.tr.create),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
