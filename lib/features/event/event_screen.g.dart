// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventControllerHash() => r'ffe40ea9df30dbd8cea10ebee935fff5e8d97952';

/// See also [eventController].
@ProviderFor(eventController)
final eventControllerProvider = AutoDisposeProvider<EventController>.internal(
  eventController,
  name: r'eventControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventControllerRef = AutoDisposeProviderRef<EventController>;
String _$userEventsHash() => r'6109de268127760ebf40183e6ac47dc8ae3a65d9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userEvents].
@ProviderFor(userEvents)
const userEventsProvider = UserEventsFamily();

/// See also [userEvents].
class UserEventsFamily extends Family<AsyncValue<List<EventEntity>>> {
  /// See also [userEvents].
  const UserEventsFamily();

  /// See also [userEvents].
  UserEventsProvider call(
    String userId,
  ) {
    return UserEventsProvider(
      userId,
    );
  }

  @override
  UserEventsProvider getProviderOverride(
    covariant UserEventsProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userEventsProvider';
}

/// See also [userEvents].
class UserEventsProvider extends AutoDisposeStreamProvider<List<EventEntity>> {
  /// See also [userEvents].
  UserEventsProvider(
    String userId,
  ) : this._internal(
          (ref) => userEvents(
            ref as UserEventsRef,
            userId,
          ),
          from: userEventsProvider,
          name: r'userEventsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userEventsHash,
          dependencies: UserEventsFamily._dependencies,
          allTransitiveDependencies:
              UserEventsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserEventsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<EventEntity>> Function(UserEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserEventsProvider._internal(
        (ref) => create(ref as UserEventsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<EventEntity>> createElement() {
    return _UserEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserEventsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserEventsRef on AutoDisposeStreamProviderRef<List<EventEntity>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserEventsProviderElement
    extends AutoDisposeStreamProviderElement<List<EventEntity>>
    with UserEventsRef {
  _UserEventsProviderElement(super.provider);

  @override
  String get userId => (origin as UserEventsProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
