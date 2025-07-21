// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provider for the AuthRepository instance
@ProviderFor(authRepository)
const authRepositoryProvider = AuthRepositoryProvider._();

/// Provider for the AuthRepository instance
final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Provider for the AuthRepository instance
  const AuthRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'866d07b3c40dd05f83eccba1be13d0f8f6aae65f';

/// Provider that streams authentication state changes
@ProviderFor(authState)
const authStateProvider = AuthStateProvider._();

/// Provider that streams authentication state changes
final class AuthStateProvider
    extends $FunctionalProvider<AsyncValue<User?>, User?, Stream<User?>>
    with $FutureModifier<User?>, $StreamProvider<User?> {
  /// Provider that streams authentication state changes
  const AuthStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<User?> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'c0ad919ebba9ac6c29aec4d522964d02322e0c1c';

/// Notifier for managing authentication state and operations
@ProviderFor(AuthNotifier)
const authNotifierProvider = AuthNotifierProvider._();

/// Notifier for managing authentication state and operations
final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AsyncValue<User?>> {
  /// Notifier for managing authentication state and operations
  const AuthNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<User?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<User?>>(value),
    );
  }
}

String _$authNotifierHash() => r'0898e26c6d420b4abffb7ef2356337e4421fd530';

abstract class _$AuthNotifier extends $Notifier<AsyncValue<User?>> {
  AsyncValue<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<User?>, AsyncValue<User?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<User?>, AsyncValue<User?>>,
        AsyncValue<User?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// Provider for global error handling
@ProviderFor(ErrorNotifier)
const errorNotifierProvider = ErrorNotifierProvider._();

/// Provider for global error handling
final class ErrorNotifierProvider
    extends $NotifierProvider<ErrorNotifier, AppError?> {
  /// Provider for global error handling
  const ErrorNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'errorNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$errorNotifierHash();

  @$internal
  @override
  ErrorNotifier create() => ErrorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppError? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppError?>(value),
    );
  }
}

String _$errorNotifierHash() => r'c35e3408ad2948a6c7411a5f3e2eab76d3b2c05b';

abstract class _$ErrorNotifier extends $Notifier<AppError?> {
  AppError? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppError?, AppError?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AppError?, AppError?>, AppError?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
