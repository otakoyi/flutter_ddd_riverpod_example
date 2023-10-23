import 'package:example/features/auth/domain/entities/user_entity.dart';
import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/common/presentation/utils/extensions/date_time_extension.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/domain/repositories/organization_repository_interface.dart';
import 'package:example/features/organization/domain/values/organization_name.dart';
import 'package:example/features/organization/infrastructure/repositories/organization_entity_converter.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///
class OrganizationRepository implements OrganizationRepositoryInterface {
  ///
  OrganizationRepository({required this.client, required this.user});

  /// Exposes Supabase auth client to allow Auth Controller to subscribe to auth changes
  final SupabaseClient client;

  /// Authorized User entity
  final UserEntity user;

  static const String _tableOrganization = 'organization';
  static const String _tableOrganizationUser = 'organization_user';

  ///
  @override
  Future<Either<Failure, List<OrganizationEntity>>> getOrganizations() async {
    try {
      final res = await client
          .from(_tableOrganization)
          .select<PostgrestList>('*,$_tableOrganizationUser!inner(*)')
          .eq('$_tableOrganizationUser.user_id', user.id)
          .withConverter(OrganizationEntityConverter.toList);

      return right(res);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }

  ///
  @override
  Future<Either<Failure, OrganizationEntity>> getOrganizationById(
    String id,
  ) async {
    try {
      final res = await client
          .from(_tableOrganization)
          .select<PostgrestList>('*,$_tableOrganizationUser!inner(*)')
          .eq('$_tableOrganizationUser.user_id', user.id)
          .withConverter(OrganizationEntityConverter.toSingle);

      return right(res);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }

  ///
  @override
  Future<Either<Failure, OrganizationEntity>> createOrganization(
    OrganizationName organizationName,
  ) async {
    try {
      final now = DateTimeX.current.toIso8601String();
      final name = organizationName.value.getOrElse((f) => '');
      final entity = OrganizationEntity(
        ownerId: user.id,
        name: name,
        createdAt: now,
        updatedAt: now,
      );
      final organization = await client
          .from(_tableOrganization)
          .insert(
            entity.toJson(),
          )
          .withConverter(OrganizationEntityConverter.toSingle);

      await client.from(_tableOrganizationUser).insert(
        {'organization_id': organization.id, 'user_id': user.id},
      );
      return right(organization);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }

  ///
  @override
  Future<Either<Failure, OrganizationEntity>> updateOrganization(
    OrganizationName organizationName,
  ) async {
    try {
      final now = DateTimeX.current.toIso8601String();
      final name = organizationName.value.getOrElse((_) => '');
      final entity = OrganizationEntity(
        ownerId: user.id,
        name: name,
        updatedAt: now,
      );
      final res = await client
          .from(_tableOrganization)
          .update(
            entity.toJson(),
          )
          .withConverter(OrganizationEntityConverter.toSingle);

      return right(res);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }

  /// Delete organization
  @override
  Future<Either<Failure, bool>> deleteOrganization(
    OrganizationEntity organizationEntity,
  ) async {
    try {
      await client.from(_tableOrganization).delete().eq('id', organizationEntity.id);
      return right(true);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }
}
