import 'package:example/features/auth/application/auth_controller.dart';
import 'package:example/features/departments/presentation/widgets/departments_list.dart';
import 'package:example/features/organization/application/organization_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main page for authorized users
class DashboardScreen extends ConsumerWidget {
  /// Default constructor for [DashboardScreen] widget
  const DashboardScreen({
    required this.title,
    required this.organizationId,
    super.key,
  });

  /// Application title displayed in the app bar
  final String title;

  /// Path for the [DashboardScreen] route
  static const routePath = 'organization';

  /// Named route for the [DashboardScreen]
  static const routeName = 'organization-view';

  /// Id of the selected organization
  final String organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organization =
        ref.watch(organizationViewControllerProvider(organizationId));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: const [],
      ),
      body: organization.when(
        data: (data) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('Organization: $organizationId')),
              const SizedBox(height: 30),
              const Center(child: Text('Settings / Departments')),
              Expanded(child: DepartmentsList(organization: data)),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  child: const Text('Logout'),
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).signOut(),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }
}
