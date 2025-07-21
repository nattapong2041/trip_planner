// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Activity {
  String get id;
  String get tripId;
  String get place;
  String get activityType;
  String? get price;
  String? get notes;
  String? get assignedDay; // null if in activity pool
  int? get dayOrder;
  String get createdBy;
  DateTime get createdAt;
  List<BrainstormIdea> get brainstormIdeas;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityCopyWith<Activity> get copyWith =>
      _$ActivityCopyWithImpl<Activity>(this as Activity, _$identity);

  /// Serializes this Activity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Activity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.assignedDay, assignedDay) ||
                other.assignedDay == assignedDay) &&
            (identical(other.dayOrder, dayOrder) ||
                other.dayOrder == dayOrder) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other.brainstormIdeas, brainstormIdeas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tripId,
      place,
      activityType,
      price,
      notes,
      assignedDay,
      dayOrder,
      createdBy,
      createdAt,
      const DeepCollectionEquality().hash(brainstormIdeas));

  @override
  String toString() {
    return 'Activity(id: $id, tripId: $tripId, place: $place, activityType: $activityType, price: $price, notes: $notes, assignedDay: $assignedDay, dayOrder: $dayOrder, createdBy: $createdBy, createdAt: $createdAt, brainstormIdeas: $brainstormIdeas)';
  }
}

/// @nodoc
abstract mixin class $ActivityCopyWith<$Res> {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) _then) =
      _$ActivityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String tripId,
      String place,
      String activityType,
      String? price,
      String? notes,
      String? assignedDay,
      int? dayOrder,
      String createdBy,
      DateTime createdAt,
      List<BrainstormIdea> brainstormIdeas});
}

/// @nodoc
class _$ActivityCopyWithImpl<$Res> implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._self, this._then);

  final Activity _self;
  final $Res Function(Activity) _then;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? place = null,
    Object? activityType = null,
    Object? price = freezed,
    Object? notes = freezed,
    Object? assignedDay = freezed,
    Object? dayOrder = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? brainstormIdeas = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _self.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      place: null == place
          ? _self.place
          : place // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _self.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedDay: freezed == assignedDay
          ? _self.assignedDay
          : assignedDay // ignore: cast_nullable_to_non_nullable
              as String?,
      dayOrder: freezed == dayOrder
          ? _self.dayOrder
          : dayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      brainstormIdeas: null == brainstormIdeas
          ? _self.brainstormIdeas
          : brainstormIdeas // ignore: cast_nullable_to_non_nullable
              as List<BrainstormIdea>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Activity].
extension ActivityPatterns on Activity {
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
    TResult Function(_Activity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Activity() when $default != null:
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
    TResult Function(_Activity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Activity():
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
    TResult? Function(_Activity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Activity() when $default != null:
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
    TResult Function(
            String id,
            String tripId,
            String place,
            String activityType,
            String? price,
            String? notes,
            String? assignedDay,
            int? dayOrder,
            String createdBy,
            DateTime createdAt,
            List<BrainstormIdea> brainstormIdeas)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Activity() when $default != null:
        return $default(
            _that.id,
            _that.tripId,
            _that.place,
            _that.activityType,
            _that.price,
            _that.notes,
            _that.assignedDay,
            _that.dayOrder,
            _that.createdBy,
            _that.createdAt,
            _that.brainstormIdeas);
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
            String id,
            String tripId,
            String place,
            String activityType,
            String? price,
            String? notes,
            String? assignedDay,
            int? dayOrder,
            String createdBy,
            DateTime createdAt,
            List<BrainstormIdea> brainstormIdeas)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Activity():
        return $default(
            _that.id,
            _that.tripId,
            _that.place,
            _that.activityType,
            _that.price,
            _that.notes,
            _that.assignedDay,
            _that.dayOrder,
            _that.createdBy,
            _that.createdAt,
            _that.brainstormIdeas);
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
    TResult? Function(
            String id,
            String tripId,
            String place,
            String activityType,
            String? price,
            String? notes,
            String? assignedDay,
            int? dayOrder,
            String createdBy,
            DateTime createdAt,
            List<BrainstormIdea> brainstormIdeas)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Activity() when $default != null:
        return $default(
            _that.id,
            _that.tripId,
            _that.place,
            _that.activityType,
            _that.price,
            _that.notes,
            _that.assignedDay,
            _that.dayOrder,
            _that.createdBy,
            _that.createdAt,
            _that.brainstormIdeas);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Activity implements Activity {
  const _Activity(
      {required this.id,
      required this.tripId,
      required this.place,
      required this.activityType,
      this.price,
      this.notes,
      this.assignedDay,
      this.dayOrder,
      required this.createdBy,
      required this.createdAt,
      final List<BrainstormIdea> brainstormIdeas = const []})
      : _brainstormIdeas = brainstormIdeas;
  factory _Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  @override
  final String id;
  @override
  final String tripId;
  @override
  final String place;
  @override
  final String activityType;
  @override
  final String? price;
  @override
  final String? notes;
  @override
  final String? assignedDay;
// null if in activity pool
  @override
  final int? dayOrder;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  final List<BrainstormIdea> _brainstormIdeas;
  @override
  @JsonKey()
  List<BrainstormIdea> get brainstormIdeas {
    if (_brainstormIdeas is EqualUnmodifiableListView) return _brainstormIdeas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_brainstormIdeas);
  }

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityCopyWith<_Activity> get copyWith =>
      __$ActivityCopyWithImpl<_Activity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Activity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.assignedDay, assignedDay) ||
                other.assignedDay == assignedDay) &&
            (identical(other.dayOrder, dayOrder) ||
                other.dayOrder == dayOrder) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._brainstormIdeas, _brainstormIdeas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tripId,
      place,
      activityType,
      price,
      notes,
      assignedDay,
      dayOrder,
      createdBy,
      createdAt,
      const DeepCollectionEquality().hash(_brainstormIdeas));

  @override
  String toString() {
    return 'Activity(id: $id, tripId: $tripId, place: $place, activityType: $activityType, price: $price, notes: $notes, assignedDay: $assignedDay, dayOrder: $dayOrder, createdBy: $createdBy, createdAt: $createdAt, brainstormIdeas: $brainstormIdeas)';
  }
}

/// @nodoc
abstract mixin class _$ActivityCopyWith<$Res>
    implements $ActivityCopyWith<$Res> {
  factory _$ActivityCopyWith(_Activity value, $Res Function(_Activity) _then) =
      __$ActivityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String tripId,
      String place,
      String activityType,
      String? price,
      String? notes,
      String? assignedDay,
      int? dayOrder,
      String createdBy,
      DateTime createdAt,
      List<BrainstormIdea> brainstormIdeas});
}

/// @nodoc
class __$ActivityCopyWithImpl<$Res> implements _$ActivityCopyWith<$Res> {
  __$ActivityCopyWithImpl(this._self, this._then);

  final _Activity _self;
  final $Res Function(_Activity) _then;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? place = null,
    Object? activityType = null,
    Object? price = freezed,
    Object? notes = freezed,
    Object? assignedDay = freezed,
    Object? dayOrder = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? brainstormIdeas = null,
  }) {
    return _then(_Activity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _self.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      place: null == place
          ? _self.place
          : place // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _self.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedDay: freezed == assignedDay
          ? _self.assignedDay
          : assignedDay // ignore: cast_nullable_to_non_nullable
              as String?,
      dayOrder: freezed == dayOrder
          ? _self.dayOrder
          : dayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      brainstormIdeas: null == brainstormIdeas
          ? _self._brainstormIdeas
          : brainstormIdeas // ignore: cast_nullable_to_non_nullable
              as List<BrainstormIdea>,
    ));
  }
}

// dart format on
