import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/core/failures.dart';

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  // Maybe not the most robust way of email validation but it's good enough
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  }
  return left(ValueFailure.invalidEmail(failedValue: input));
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 6) {
    return right(input);
  }
  return left(ValueFailure.shortPassword(failedValue: input));
}

Either<ValueFailure<String>, String> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return right(input);
  }
  return left(ValueFailure.exceedingLength(
    failedValue: input,
    max: maxLength,
  ));
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isNotEmpty) {
    return right(input);
  }
  return left(ValueFailure.empty(failedValue: input));
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (input.contains('\n')) {
    return left(ValueFailure.multiline(failedValue: input));
  }
  return right(input);
}

Either<ValueFailure<IList<T>>, IList<T>> validateMaxListLength<T>(
  IList<T> input,
  int max,
) {
  if (input.length() <= max) {
    right(input);
  }
  return left(ValueFailure.listTooLong(failedValue: input, max: max));
}
