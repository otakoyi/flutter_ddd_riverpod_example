import 'package:example/config/providers.dart';
import 'package:example/features/auth/auth_provider.dart';
import 'package:example/features/organization/application/organization_create_controller.dart';
import 'package:example/features/organization/application/organization_view_controller.dart';
import 'package:example/features/organization/application/organizations_list_controller.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/infrastructure/repositories/organization_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// Infrastructure dependencies
///

final organizationRepositoryProvider = Provider<OrganizationRepository?>((ref) {
  final user = ref.watch(authRepositoryProvider.select((v) => v.currentUser));
  if (user == null) return null;
  return OrganizationRepository(
    client: ref.watch(supabaseClientProvider),
    user: user,
  );
});

///
/// Application dependencies
///
final organizationListProvider = StateNotifierProvider<
    OrganizationListController, AsyncValue<List<OrganizationEntity>>>((ref) {
  final repo = ref.watch(organizationRepositoryProvider);
  return OrganizationListController(repo);
});

/// Keeps selected by user organization
final currentOrganizationProvider = StateProvider<OrganizationEntity?>((ref) {
  return null;
});

///
final organizationCreateProvider = StateNotifierProvider<
    OrganizationCreateController, AsyncValue<OrganizationEntity?>>((ref) {
  final repo = ref.watch(organizationRepositoryProvider);

  return OrganizationCreateController(repo);
});

///
final organizationViewProvider = StateNotifierProvider.family<
    OrganizationViewController,
    AsyncValue<OrganizationEntity>,
    String>((ref, id) {
  return OrganizationViewController(
    ref.read(organizationRepositoryProvider)!,
    id,
    ref.read,
  );
});
