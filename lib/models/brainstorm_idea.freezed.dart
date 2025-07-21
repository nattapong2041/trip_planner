// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brainstorm_idea.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BrainstormIdea {
  String get id;
  String get description;
  String get createdBy;
  DateTime get createdAt;

  /// Create a copy of BrainstormIdea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BrainstormIdeaCopyWith<BrainstormIdea> get copyWith =>
      _$BrainstormIdeaCopyWithImpl<BrainstormIdea>(
          this as BrainstormIdea, _$identity);

  /// Serializes this BrainstormIdea to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BrainstormIdea &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, description, createdBy, createdAt);

  @override
  String toString() {
    return 'BrainstormIdea(id: $id, description: $description, createdBy: $createdBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $BrainstormIdeaCopyWith<$Res> {
  factory $BrainstormIdeaCopyWith(
          BrainstormIdea value, $Res Function(BrainstormIdea) _then) =
      _$BrainstormIdeaCopyWithImpl;
  @useResult
  $Res call(
      {String id, String description, String createdBy, DateTime createdAt});
}

/// @nodoc
class _$BrainstormIdeaCopyWithImpl<$Res>
    implements $BrainstormIdeaCopyWith<$Res> {
  _$BrainstormIdeaCopyWithImpl(this._self, this._then);

  final BrainstormIdea _self;
  final $Res Function(BrainstormIdea) _then;

  /// Create a copy of BrainstormIdea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [BrainstormIdea].
extension BrainstormIdeaPatterns on BrainstormIdea {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BrainstormIdea value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BrainstormIdea() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_BrainstormIdea value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainstormIdea():
        return $default(_that);
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BrainstormIdea value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainstormIdea() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String description, String createdBy,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BrainstormIdea() when $default != null:
        return $default(
            _that.id, _that.description, _that.createdBy, _that.createdAt);
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
  TResult when<TResult extends Object?>(
    TResult Function(
            String id, String description, String createdBy, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainstormIdea():
        return $default(
            _that.id, _that.description, _that.createdBy, _that.createdAt);
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String description, String createdBy,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainstormIdea() when $default != null:
        return $default(
            _that.id, _that.description, _that.createdBy, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BrainstormIdea implements BrainstormIdea {
  const _BrainstormIdea(
      {required this.id,
      required this.description,
      required this.createdBy,
      required this.createdAt});
  factory _BrainstormIdea.fromJson(Map<String, dynamic> json) =>
      _$BrainstormIdeaFromJson(json);

  @override
  final String id;
  @override
  final String description;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;

  /// Create a copy of BrainstormIdea
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BrainstormIdeaCopyWith<_BrainstormIdea> get copyWith =>
      __$BrainstormIdeaCopyWithImpl<_BrainstormIdea>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BrainstormIdeaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BrainstormIdea &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, description, createdBy, createdAt);

  @override
  String toString() {
    return 'BrainstormIdea(id: $id, description: $description, createdBy: $createdBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$BrainstormIdeaCopyWith<$Res>
    implements $BrainstormIdeaCopyWith<$Res> {
  factory _$BrainstormIdeaCopyWith(
          _BrainstormIdea value, $Res Function(_BrainstormIdea) _then) =
      __$BrainstormIdeaCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String description, String createdBy, DateTime createdAt});
}

/// @nodoc
class __$BrainstormIdeaCopyWithImpl<$Res>
    implements _$BrainstormIdeaCopyWith<$Res> {
  __$BrainstormIdeaCopyWithImpl(this._self, this._then);

  final _BrainstormIdea _self;
  final $Res Function(_BrainstormIdea) _then;

  /// Create a copy of BrainstormIdea
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_BrainstormIdea(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
