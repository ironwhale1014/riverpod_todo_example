// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(RepositoryProvider)
const repositoryProviderProvider = RepositoryProviderProvider._();

final class RepositoryProviderProvider
    extends $NotifierProvider<RepositoryProvider, void> {
  const RepositoryProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repositoryProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repositoryProviderHash();

  @$internal
  @override
  RepositoryProvider create() => RepositoryProvider();

  @$internal
  @override
  $NotifierProviderElement<RepositoryProvider, void> $createElement(
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

String _$repositoryProviderHash() =>
    r'ba16e4a78edefc24bcaeccbb375c26b278f6c010';

abstract class _$RepositoryProvider extends $Notifier<void> {
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
