import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/departments/domain/entities/department_entity.dart';
import 'package:example/features/departments/domain/values/department_name.dart';
import 'package:fpdart/fpdart.dart';

/// Departments Repository Interface
abstract class DepartmentRepositoryInterface {
  /// Get departments list
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments();

  /// Get department by id
  Future<Either<Failure, DepartmentEntity>> getDepartmentById(String id);

  /// Create department
  Future<Either<Failure, DepartmentEntity>> createDepartment(
    DepartmentName name,
  );

  /// Update department
  Future<Either<Failure, DepartmentEntity>> updateDepartment(
    String id,
    DepartmentName name,
  );

  /// Delete department by id
  Future<Either<Failure, bool>> deleteDepartment(String id);
}
