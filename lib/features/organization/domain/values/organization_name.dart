import 'package:example/features/common/domain/failures/failure.dart';
import 'package:example/features/common/domain/values/value_abstract.dart';
import 'package:fpdart/fpdart.dart';

/// Organization Name value
class OrganizationName extends ValueAbstract<String> {
  ///
  factory OrganizationName(String? input) {
    return OrganizationName._(
      _validate(input),
    );
  }

  const OrganizationName._(this._value);
  @override
  Either<Failure, String> get value => _value;

  final Either<Failure, String> _value;
}

Either<Failure, String> _validate(String? input) {
  if (input != null && input.length >= 2) {
    return right(input);
  }
  return left(
    Failure.unprocessableEntity(
      StackTrace.current,
      message: 'The company name must be at least 21 characters in length',
    ),
  );
}
