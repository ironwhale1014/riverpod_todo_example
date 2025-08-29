// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CategoryService)
const categoryServiceProvider = CategoryServiceProvider._();

final class CategoryServiceProvider
    extends $NotifierProvider<CategoryService, BaseStateModel<Category>> {
  const CategoryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryServiceHash();

  @$internal
  @override
  CategoryService create() => CategoryService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseStateModel<Category> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseStateModel<Category>>(value),
    );
  }
}

String _$categoryServiceHash() => r'a90f74498a8f7b5a24005f15e954a18a9ecd4e81';

abstract class _$CategoryService extends $Notifier<BaseStateModel<Category>> {
  BaseStateModel<Category> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<BaseStateModel<Category>, BaseStateModel<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BaseStateModel<Category>, BaseStateModel<Category>>,
              BaseStateModel<Category>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
