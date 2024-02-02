import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/common/presentation/utils/extensions/date_time_extension.dart';
import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/repositories/department_repository_interface.dart';
import 'package:example/features/departments/domain/values/department_name.dart';
import 'package:example/features/departments/infrastructure/repositories/department_entity_converter.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

///
class DepartmentRepository implements DepartmentRepositoryInterface {
  ///
  DepartmentRepository({required this.client, required this.organization});

  /// Exposes Supabase auth client to allow Auth Controller to subscribe to auth changes
  final supabase.SupabaseClient client;

  /// Authorized User entity
  final OrganizationEntity organization;

  static const String _table = 'department';

  @override
  Future<Either<Failure, DepartmentEntity>> createDepartment(
    DepartmentName name,
  ) async {
    try {
      final now = DateTimeX.current.toIso8601String();
      final n = name.value.getOrElse((_) => '');
      final entity = DepartmentEntity(
        name: n,
        createdAt: now,
        organizationId: organization.id!,
      );
      final res = await client
          .from(_table)
          .insert(
            entity.toJson(),
          )
          .withConverter(DepartmentEntityConverter.toSingle);

      return right(res);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteDepartment(String id) async {
    try {
      await client
          .from(_table)
          .delete()
          .eq('$_table.organization_id', organization.id ?? '')
          .eq('$_table.id', id);

      return right(true);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }

  @override
  Future<Either<Failure, DepartmentEntity>> getDepartmentById(String id) async {
    try {
      final res = await client
          .from(_table)
          .select()
          .eq('organization_id', organization.id ?? '')
          .eq('id', id)
          .withConverter(DepartmentEntityConverter.toSingle);

      return right(res);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }

  @override
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments() async {
    try {
      final res = await client
          .from(_table)
          .select()
          .eq('organization_id', organization.id ?? '')
          .withConverter(DepartmentEntityConverter.toList);

      return right(res);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }

  @override
  Future<Either<Failure, DepartmentEntity>> updateDepartment(
    String id,
    DepartmentName name,
  ) async {
    try {
      final now = DateTimeX.current.toIso8601String();
      final n = name.value.getOrElse((_) => '');
      final entity = DepartmentEntity(
        name: n,
        updatedAt: now,
        organizationId: organization.id!,
      );
      final res = await client
          .from(_table)
          .update(entity.toJson())
          .eq('organization_id', organization.id ?? '')
          .eq('id', id)
          .withConverter(DepartmentEntityConverter.toSingle);

      return right(res);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }
}
