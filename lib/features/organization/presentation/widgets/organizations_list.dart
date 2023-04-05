import 'package:example/features/common/presentation/widgets/app_error.dart';
import 'package:example/features/organization/application/organizations_list_controller.dart';
import 'package:example/features/organization/presentation/widgets/add_organization_card.dart';
import 'package:example/features/organization/presentation/widgets/organization_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class OrganizationsList extends ConsumerWidget {
  ///
  const OrganizationsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizations = ref.watch(organizationListControllerProvider);
    return organizations.when(
      data: (items) => Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          const AddOrganizationCard(),
          ...items.map(
            (e) => OrganizationCard(
              organization: e,
              selected: false,
            ),
          )
        ],
      ),
      error: (o, e) => AppError(
        title: o.toString(),
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
