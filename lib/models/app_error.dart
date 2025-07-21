import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';
part 'app_error.g.dart';

@freezed
abstract class AppError with _$AppError {
  const factory AppError.network(String message) = NetworkError;
  const factory AppError.authentication(String message) = AuthenticationError;
  const factory AppError.permission(String message) = PermissionError;
  const factory AppError.validation(String message) = ValidationError;
  const factory AppError.unknown(String message) = UnknownError;
  
  factory AppError.fromJson(Map<String, dynamic> json) => _$AppErrorFromJson(json);
}