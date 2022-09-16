import 'package:example/features/common/domain/failures/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Provides specification for value objects
abstract class ValueAbstract<T> {
  ///
  const ValueAbstract();

  /// getter for value
  Either<Failure, T> get value;

  @override
  String toString() => value.fold((l) => l.error, (r) => r.toString());

  /// Form validate handler
  String? get validate => value.fold((l) => l.error, (r) => null);
}
