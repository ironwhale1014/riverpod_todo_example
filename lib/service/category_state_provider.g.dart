// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CategoryState)
const categoryStateProvider = CategoryStateProvider._();

final class CategoryStateProvider
    extends $NotifierProvider<CategoryState, Category?> {
  const CategoryStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryStateHash();

  @$internal
  @override
  CategoryState create() => CategoryState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Category? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Category?>(value),
    );
  }
}

String _$categoryStateHash() => r'5552a6f61703c5782bb59ec664d14dc8ef28ddec';

abstract class _$CategoryState extends $Notifier<Category?> {
  Category? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Category?, Category?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Category?, Category?>,
              Category?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
