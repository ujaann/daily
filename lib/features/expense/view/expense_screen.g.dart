// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userExpensesHash() => r'ba9c245435640fb5fbb48a11e8a70c10bea8a7ac';

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

/// See also [userExpenses].
@ProviderFor(userExpenses)
const userExpensesProvider = UserExpensesFamily();

/// See also [userExpenses].
class UserExpensesFamily extends Family<AsyncValue<List<ExpenseEntity>>> {
  /// See also [userExpenses].
  const UserExpensesFamily();

  /// See also [userExpenses].
  UserExpensesProvider call(
    String userId,
  ) {
    return UserExpensesProvider(
      userId,
    );
  }

  @override
  UserExpensesProvider getProviderOverride(
    covariant UserExpensesProvider provider,
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
  String? get name => r'userExpensesProvider';
}

/// See also [userExpenses].
class UserExpensesProvider
    extends AutoDisposeStreamProvider<List<ExpenseEntity>> {
  /// See also [userExpenses].
  UserExpensesProvider(
    String userId,
  ) : this._internal(
          (ref) => userExpenses(
            ref as UserExpensesRef,
            userId,
          ),
          from: userExpensesProvider,
          name: r'userExpensesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userExpensesHash,
          dependencies: UserExpensesFamily._dependencies,
          allTransitiveDependencies:
              UserExpensesFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserExpensesProvider._internal(
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
    Stream<List<ExpenseEntity>> Function(UserExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserExpensesProvider._internal(
        (ref) => create(ref as UserExpensesRef),
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
  AutoDisposeStreamProviderElement<List<ExpenseEntity>> createElement() {
    return _UserExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserExpensesProvider && other.userId == userId;
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
mixin UserExpensesRef on AutoDisposeStreamProviderRef<List<ExpenseEntity>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserExpensesProviderElement
    extends AutoDisposeStreamProviderElement<List<ExpenseEntity>>
    with UserExpensesRef {
  _UserExpensesProviderElement(super.provider);

  @override
  String get userId => (origin as UserExpensesProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
