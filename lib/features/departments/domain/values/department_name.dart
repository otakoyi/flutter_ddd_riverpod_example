import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/common/domain/values/value_abstract.dart';
import 'package:fpdart/fpdart.dart';

/// Department Name value
class DepartmentName extends ValueAbstract<String> {
  ///
  factory DepartmentName(String input) {
    return DepartmentName._(
      _validate(input),
    );
  }

  const DepartmentName._(this._value);
  @override
  Either<Failure, String> get value => _value;

  final Either<Failure, String> _value;
}

Either<Failure, String> _validate(String input) {
  if (input.length >= 2) {
    return right(input);
  }
  return left(
    const Failure.unprocessableEntity(
      message: 'The name must be at least 2 characters in length',
    ),
  );
}
