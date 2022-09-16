import 'package:example/features/organization/presentation/widgets/create_organization_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class OrganizationsCreateScreen extends ConsumerWidget {
  ///
  const OrganizationsCreateScreen({
    super.key,
  });

  /// Create organization route name
  static const routeName = 'organization-create';

  /// Create organization route path
  static const routePath = 'create-organization';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: CreateOrganizationForm()),
    );
  }
}
