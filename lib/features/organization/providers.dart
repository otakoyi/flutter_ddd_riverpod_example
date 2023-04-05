import 'package:example/config/providers.dart';
import 'package:example/features/auth/auth_provider.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/infrastructure/repositories/organization_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

///
/// Infrastructure dependencies
///

@riverpod
OrganizationRepository? organizationRepository(OrganizationRepositoryRef ref) {
  final user = ref.watch(authRepositoryProvider.select((v) => v.currentUser));
  if (user == null) return null;
  return OrganizationRepository(
    client: ref.watch(supabaseClientProvider),
    user: user,
  );
}

///
/// Application dependencies
///

/// Keeps selected by user organization
final currentOrganizationProvider = StateProvider<OrganizationEntity?>((ref) {
  return null;
});
