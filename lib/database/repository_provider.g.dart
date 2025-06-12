// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Repository)
const repositoryProvider = RepositoryProvider._();

final class RepositoryProvider extends $NotifierProvider<Repository, void> {
  const RepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repositoryHash();

  @$internal
  @override
  Repository create() => Repository();

  @$internal
  @override
  $NotifierProviderElement<Repository, void> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<void>(value),
    );
  }
}

String _$repositoryHash() => r'1960aa0909fdf4ff29ecf00b48f4724286469551';

abstract class _$Repository extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<void>, void, Object?, Object?>;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
