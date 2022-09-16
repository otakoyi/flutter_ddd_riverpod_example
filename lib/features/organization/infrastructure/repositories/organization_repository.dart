import 'package:example/features/auth/domain/entities/user_entity.dart';
import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/common/presentation/utils/extensions/date_time_extension.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/domain/repositories/organization_repository_interface.dart';
import 'package:example/features/organization/domain/values/organization_name.dart';
import 'package:example/features/organization/infrastructure/repositories/organization_entity_converter.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

///
class OrganizationRepository implements OrganizationRepositoryInterface {
  ///
  OrganizationRepository({required this.client, required this.user});

  /// Exposes Supabase auth client to allow Auth Controller to subscribe to auth changes
  final supabase.SupabaseClient client;

  /// Authorized User entity
  final UserEntity user;

  static const String _tableOrganization = 'organization';
  static const String _tableOrganizationUser = 'organization_user';

  ///
  @override
  Future<Either<Failure, List<OrganizationEntity>>> getOrganizations() async {
    final res = await client
        .from(_tableOrganization)
        .select('*,$_tableOrganizationUser!inner(*)')
        .eq('$_tableOrganizationUser.user_id', user.id)
        .withConverter(OrganizationEntityConverter.toList)
        .execute();
    if (res.hasError) {
      return left(const Failure.badRequest());
    }
    return right(res.data!);
  }

  ///
  @override
  Future<Either<Failure, OrganizationEntity>> getOrganizationById(
    String id,
  ) async {
    final res = await client
        .from(_tableOrganization)
        .select('*,$_tableOrganizationUser!inner(*)')
        .eq('$_tableOrganizationUser.user_id', user.id)
        .withConverter(OrganizationEntityConverter.toSingle)
        .execute();
    if (res.hasError) {
      return left(const Failure.badRequest());
    }
    return right(res.data!);
  }

  ///
  @override
  Future<Either<Failure, OrganizationEntity>> createOrganization(
    OrganizationName organizationName,
  ) async {
    final now = DateTimeX.current.toIso8601String();
    final name = organizationName.value.getOrElse((f) => '');
    final entity = OrganizationEntity(
      ownerId: user.id,
      name: name,
      createdAt: now,
      updatedAt: now,
    );
    final res = await client
        .from(_tableOrganization)
        .insert(
          entity.toJson(),
        )
        .withConverter(OrganizationEntityConverter.toSingle)
        .execute();
    if (res.hasError) {
      return left(const Failure.badRequest());
    }
    final organization = res.data!;
    final res2 = await client.from(_tableOrganizationUser).insert(
      {'organization_id': organization.id, 'user_id': user.id},
    ).execute();
    if (res2.hasError) {
      return left(const Failure.badRequest());
    }
    return right(organization);
  }

  ///
  @override
  Future<Either<Failure, OrganizationEntity>> updateOrganization(
    OrganizationName organizationName,
  ) async {
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
        .withConverter(OrganizationEntityConverter.toSingle)
        .execute();
    if (res.hasError) {
      return left(const Failure.badRequest());
    }
    return right(res.data!);
  }

  /// Delete organization
  @override
  Future<Either<Failure, bool>> deleteOrganization(
    OrganizationEntity organizationEntity,
  ) async {
    final res = await client
        .from(_tableOrganization)
        .delete()
        .eq('id', organizationEntity.id)
        .execute();
    if (res.hasError) {
      return left(const Failure.badRequest());
    }
    return right(true);
  }
}
