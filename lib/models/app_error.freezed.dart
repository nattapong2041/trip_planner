// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AppError _$AppErrorFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'network':
      return NetworkError.fromJson(json);
    case 'authentication':
      return AuthenticationError.fromJson(json);
    case 'permission':
      return PermissionError.fromJson(json);
    case 'validation':
      return ValidationError.fromJson(json);
    case 'unknown':
      return UnknownError.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'AppError',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AppError {
  String get message;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppErrorCopyWith<AppError> get copyWith =>
      _$AppErrorCopyWithImpl<AppError>(this as AppError, _$identity);

  /// Serializes this AppError to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppError &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AppError(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AppErrorCopyWith<$Res> {
  factory $AppErrorCopyWith(AppError value, $Res Function(AppError) _then) =
      _$AppErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AppErrorCopyWithImpl<$Res> implements $AppErrorCopyWith<$Res> {
  _$AppErrorCopyWithImpl(this._self, this._then);

  final AppError _self;
  final $Res Function(AppError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_self.copyWith(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [AppError].
extension AppErrorPatterns on AppError {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(AuthenticationError value)? authentication,
    TResult Function(PermissionError value)? permission,
    TResult Function(ValidationError value)? validation,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case NetworkError() when network != null:
        return network(_that);
      case AuthenticationError() when authentication != null:
        return authentication(_that);
      case PermissionError() when permission != null:
        return permission(_that);
      case ValidationError() when validation != null:
        return validation(_that);
      case UnknownError() when unknown != null:
        return unknown(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(AuthenticationError value) authentication,
    required TResult Function(PermissionError value) permission,
    required TResult Function(ValidationError value) validation,
    required TResult Function(UnknownError value) unknown,
  }) {
    final _that = this;
    switch (_that) {
      case NetworkError():
        return network(_that);
      case AuthenticationError():
        return authentication(_that);
      case PermissionError():
        return permission(_that);
      case ValidationError():
        return validation(_that);
      case UnknownError():
        return unknown(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(AuthenticationError value)? authentication,
    TResult? Function(PermissionError value)? permission,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(UnknownError value)? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case NetworkError() when network != null:
        return network(_that);
      case AuthenticationError() when authentication != null:
        return authentication(_that);
      case PermissionError() when permission != null:
        return permission(_that);
      case ValidationError() when validation != null:
        return validation(_that);
      case UnknownError() when unknown != null:
        return unknown(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message)? authentication,
    TResult Function(String message)? permission,
    TResult Function(String message)? validation,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case NetworkError() when network != null:
        return network(_that.message);
      case AuthenticationError() when authentication != null:
        return authentication(_that.message);
      case PermissionError() when permission != null:
        return permission(_that.message);
      case ValidationError() when validation != null:
        return validation(_that.message);
      case UnknownError() when unknown != null:
        return unknown(_that.message);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message) authentication,
    required TResult Function(String message) permission,
    required TResult Function(String message) validation,
    required TResult Function(String message) unknown,
  }) {
    final _that = this;
    switch (_that) {
      case NetworkError():
        return network(_that.message);
      case AuthenticationError():
        return authentication(_that.message);
      case PermissionError():
        return permission(_that.message);
      case ValidationError():
        return validation(_that.message);
      case UnknownError():
        return unknown(_that.message);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message)? authentication,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case NetworkError() when network != null:
        return network(_that.message);
      case AuthenticationError() when authentication != null:
        return authentication(_that.message);
      case PermissionError() when permission != null:
        return permission(_that.message);
      case ValidationError() when validation != null:
        return validation(_that.message);
      case UnknownError() when unknown != null:
        return unknown(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class NetworkError implements AppError {
  const NetworkError(this.message, {final String? $type})
      : $type = $type ?? 'network';
  factory NetworkError.fromJson(Map<String, dynamic> json) =>
      _$NetworkErrorFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NetworkErrorCopyWith<NetworkError> get copyWith =>
      _$NetworkErrorCopyWithImpl<NetworkError>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NetworkErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NetworkError &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AppError.network(message: $message)';
  }
}

/// @nodoc
abstract mixin class $NetworkErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $NetworkErrorCopyWith(
          NetworkError value, $Res Function(NetworkError) _then) =
      _$NetworkErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$NetworkErrorCopyWithImpl<$Res> implements $NetworkErrorCopyWith<$Res> {
  _$NetworkErrorCopyWithImpl(this._self, this._then);

  final NetworkError _self;
  final $Res Function(NetworkError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(NetworkError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class AuthenticationError implements AppError {
  const AuthenticationError(this.message, {final String? $type})
      : $type = $type ?? 'authentication';
  factory AuthenticationError.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationErrorFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthenticationErrorCopyWith<AuthenticationError> get copyWith =>
      _$AuthenticationErrorCopyWithImpl<AuthenticationError>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthenticationErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthenticationError &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AppError.authentication(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AuthenticationErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $AuthenticationErrorCopyWith(
          AuthenticationError value, $Res Function(AuthenticationError) _then) =
      _$AuthenticationErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AuthenticationErrorCopyWithImpl<$Res>
    implements $AuthenticationErrorCopyWith<$Res> {
  _$AuthenticationErrorCopyWithImpl(this._self, this._then);

  final AuthenticationError _self;
  final $Res Function(AuthenticationError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(AuthenticationError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class PermissionError implements AppError {
  const PermissionError(this.message, {final String? $type})
      : $type = $type ?? 'permission';
  factory PermissionError.fromJson(Map<String, dynamic> json) =>
      _$PermissionErrorFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PermissionErrorCopyWith<PermissionError> get copyWith =>
      _$PermissionErrorCopyWithImpl<PermissionError>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PermissionErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PermissionError &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AppError.permission(message: $message)';
  }
}

/// @nodoc
abstract mixin class $PermissionErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $PermissionErrorCopyWith(
          PermissionError value, $Res Function(PermissionError) _then) =
      _$PermissionErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$PermissionErrorCopyWithImpl<$Res>
    implements $PermissionErrorCopyWith<$Res> {
  _$PermissionErrorCopyWithImpl(this._self, this._then);

  final PermissionError _self;
  final $Res Function(PermissionError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(PermissionError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class ValidationError implements AppError {
  const ValidationError(this.message, {final String? $type})
      : $type = $type ?? 'validation';
  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ValidationErrorCopyWith<ValidationError> get copyWith =>
      _$ValidationErrorCopyWithImpl<ValidationError>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ValidationErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ValidationError &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AppError.validation(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ValidationErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $ValidationErrorCopyWith(
          ValidationError value, $Res Function(ValidationError) _then) =
      _$ValidationErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ValidationErrorCopyWithImpl<$Res>
    implements $ValidationErrorCopyWith<$Res> {
  _$ValidationErrorCopyWithImpl(this._self, this._then);

  final ValidationError _self;
  final $Res Function(ValidationError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ValidationError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class UnknownError implements AppError {
  const UnknownError(this.message, {final String? $type})
      : $type = $type ?? 'unknown';
  factory UnknownError.fromJson(Map<String, dynamic> json) =>
      _$UnknownErrorFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnknownErrorCopyWith<UnknownError> get copyWith =>
      _$UnknownErrorCopyWithImpl<UnknownError>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UnknownErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnknownError &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AppError.unknown(message: $message)';
  }
}

/// @nodoc
abstract mixin class $UnknownErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $UnknownErrorCopyWith(
          UnknownError value, $Res Function(UnknownError) _then) =
      _$UnknownErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$UnknownErrorCopyWithImpl<$Res> implements $UnknownErrorCopyWith<$Res> {
  _$UnknownErrorCopyWithImpl(this._self, this._then);

  final UnknownError _self;
  final $Res Function(UnknownError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(UnknownError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
