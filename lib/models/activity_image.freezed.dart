// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityImage {
  String get id;
  String get url; // Firebase Storage download URL
  String get storagePath; // Firebase Storage path for deletion
  String get uploadedBy;
  @TimestampConverter()
  DateTime get uploadedAt;
  String get originalFileName;
  int get fileSizeBytes;
  int? get order; // For custom ordering
  String? get caption;

  /// Create a copy of ActivityImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityImageCopyWith<ActivityImage> get copyWith =>
      _$ActivityImageCopyWithImpl<ActivityImage>(
          this as ActivityImage, _$identity);

  /// Serializes this ActivityImage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityImage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.originalFileName, originalFileName) ||
                other.originalFileName == originalFileName) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.caption, caption) || other.caption == caption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, storagePath, uploadedBy,
      uploadedAt, originalFileName, fileSizeBytes, order, caption);

  @override
  String toString() {
    return 'ActivityImage(id: $id, url: $url, storagePath: $storagePath, uploadedBy: $uploadedBy, uploadedAt: $uploadedAt, originalFileName: $originalFileName, fileSizeBytes: $fileSizeBytes, order: $order, caption: $caption)';
  }
}

/// @nodoc
abstract mixin class $ActivityImageCopyWith<$Res> {
  factory $ActivityImageCopyWith(
          ActivityImage value, $Res Function(ActivityImage) _then) =
      _$ActivityImageCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String url,
      String storagePath,
      String uploadedBy,
      @TimestampConverter() DateTime uploadedAt,
      String originalFileName,
      int fileSizeBytes,
      int? order,
      String? caption});
}

/// @nodoc
class _$ActivityImageCopyWithImpl<$Res>
    implements $ActivityImageCopyWith<$Res> {
  _$ActivityImageCopyWithImpl(this._self, this._then);

  final ActivityImage _self;
  final $Res Function(ActivityImage) _then;

  /// Create a copy of ActivityImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? storagePath = null,
    Object? uploadedBy = null,
    Object? uploadedAt = null,
    Object? originalFileName = null,
    Object? fileSizeBytes = null,
    Object? order = freezed,
    Object? caption = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _self.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedBy: null == uploadedBy
          ? _self.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _self.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      originalFileName: null == originalFileName
          ? _self.originalFileName
          : originalFileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _self.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      order: freezed == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
      caption: freezed == caption
          ? _self.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActivityImage].
extension ActivityImagePatterns on ActivityImage {
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
    TResult Function(_ActivityImage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityImage() when $default != null:
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
    TResult Function(_ActivityImage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityImage():
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
    TResult? Function(_ActivityImage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityImage() when $default != null:
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
            String url,
            String storagePath,
            String uploadedBy,
            @TimestampConverter() DateTime uploadedAt,
            String originalFileName,
            int fileSizeBytes,
            int? order,
            String? caption)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityImage() when $default != null:
        return $default(
            _that.id,
            _that.url,
            _that.storagePath,
            _that.uploadedBy,
            _that.uploadedAt,
            _that.originalFileName,
            _that.fileSizeBytes,
            _that.order,
            _that.caption);
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
            String url,
            String storagePath,
            String uploadedBy,
            @TimestampConverter() DateTime uploadedAt,
            String originalFileName,
            int fileSizeBytes,
            int? order,
            String? caption)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityImage():
        return $default(
            _that.id,
            _that.url,
            _that.storagePath,
            _that.uploadedBy,
            _that.uploadedAt,
            _that.originalFileName,
            _that.fileSizeBytes,
            _that.order,
            _that.caption);
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
            String url,
            String storagePath,
            String uploadedBy,
            @TimestampConverter() DateTime uploadedAt,
            String originalFileName,
            int fileSizeBytes,
            int? order,
            String? caption)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityImage() when $default != null:
        return $default(
            _that.id,
            _that.url,
            _that.storagePath,
            _that.uploadedBy,
            _that.uploadedAt,
            _that.originalFileName,
            _that.fileSizeBytes,
            _that.order,
            _that.caption);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityImage extends ActivityImage {
  const _ActivityImage(
      {required this.id,
      required this.url,
      required this.storagePath,
      required this.uploadedBy,
      @TimestampConverter() required this.uploadedAt,
      required this.originalFileName,
      required this.fileSizeBytes,
      this.order,
      this.caption})
      : super._();
  factory _ActivityImage.fromJson(Map<String, dynamic> json) =>
      _$ActivityImageFromJson(json);

  @override
  final String id;
  @override
  final String url;
// Firebase Storage download URL
  @override
  final String storagePath;
// Firebase Storage path for deletion
  @override
  final String uploadedBy;
  @override
  @TimestampConverter()
  final DateTime uploadedAt;
  @override
  final String originalFileName;
  @override
  final int fileSizeBytes;
  @override
  final int? order;
// For custom ordering
  @override
  final String? caption;

  /// Create a copy of ActivityImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityImageCopyWith<_ActivityImage> get copyWith =>
      __$ActivityImageCopyWithImpl<_ActivityImage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityImageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityImage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.originalFileName, originalFileName) ||
                other.originalFileName == originalFileName) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.caption, caption) || other.caption == caption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, storagePath, uploadedBy,
      uploadedAt, originalFileName, fileSizeBytes, order, caption);

  @override
  String toString() {
    return 'ActivityImage(id: $id, url: $url, storagePath: $storagePath, uploadedBy: $uploadedBy, uploadedAt: $uploadedAt, originalFileName: $originalFileName, fileSizeBytes: $fileSizeBytes, order: $order, caption: $caption)';
  }
}

/// @nodoc
abstract mixin class _$ActivityImageCopyWith<$Res>
    implements $ActivityImageCopyWith<$Res> {
  factory _$ActivityImageCopyWith(
          _ActivityImage value, $Res Function(_ActivityImage) _then) =
      __$ActivityImageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String url,
      String storagePath,
      String uploadedBy,
      @TimestampConverter() DateTime uploadedAt,
      String originalFileName,
      int fileSizeBytes,
      int? order,
      String? caption});
}

/// @nodoc
class __$ActivityImageCopyWithImpl<$Res>
    implements _$ActivityImageCopyWith<$Res> {
  __$ActivityImageCopyWithImpl(this._self, this._then);

  final _ActivityImage _self;
  final $Res Function(_ActivityImage) _then;

  /// Create a copy of ActivityImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? storagePath = null,
    Object? uploadedBy = null,
    Object? uploadedAt = null,
    Object? originalFileName = null,
    Object? fileSizeBytes = null,
    Object? order = freezed,
    Object? caption = freezed,
  }) {
    return _then(_ActivityImage(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _self.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedBy: null == uploadedBy
          ? _self.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _self.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      originalFileName: null == originalFileName
          ? _self.originalFileName
          : originalFileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _self.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      order: freezed == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
      caption: freezed == caption
          ? _self.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
