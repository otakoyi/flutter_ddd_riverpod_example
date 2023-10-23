import 'package:example/config/app_layout.dart';
import 'package:example/features/common/presentation/utils/extensions/ui_extension.dart';
import 'package:example/features/common/presentation/widgets/app_error.dart';
import 'package:example/features/organization/application/organizations_list_controller.dart';
import 'package:example/features/organization/presentation/widgets/organizations_list.dart';
import 'package:example/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class OrganizationsListScreen extends ConsumerWidget {
  ///
  const OrganizationsListScreen({
    super.key,
  });

  ///
  static const routeName = 'organization';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizations = ref.watch(organizationListControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: organizations.when(
          data: (o) => Text(
            F.title,
          ),
          error: (e, s) => const Text('Error'),
          loading: CircularProgressIndicator.new,
        ),
      ),
      body: organizations.when(
        data: (orgs) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 112, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.yourOrganizations,
                style: context.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppLayout.defaultPadding * 2),
              const OrganizationsList(),
            ],
          ),
        ),
        error: (e, s) => AppError(title: e.toString()),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
