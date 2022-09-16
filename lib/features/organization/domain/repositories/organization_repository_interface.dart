import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/domain/values/organization_name.dart';
import 'package:fpdart/fpdart.dart';

/// Organization repository interface
abstract class OrganizationRepositoryInterface {
  /// Get all organizations
  Future<Either<Failure, List<OrganizationEntity>>> getOrganizations();

  /// Get organization by id
  Future<Either<Failure, OrganizationEntity>> getOrganizationById(
    String id,
  );

  /// Create organization
  Future<Either<Failure, OrganizationEntity>> createOrganization(
    OrganizationName organizationName,
  );

  /// Update organization
  Future<Either<Failure, OrganizationEntity>> updateOrganization(
    OrganizationName organizationName,
  );

  /// Delete organization
  Future<Either<Failure, bool>> deleteOrganization(
    OrganizationEntity organizationEntity,
  );
}
