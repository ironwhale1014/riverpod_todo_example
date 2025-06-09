// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_with_category_provider.dart';

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

  @$internal
  @override
  $NotifierProviderElement<CategoryState, Category?> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Category? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Category?>(value),
    );
  }
}

String _$categoryStateHash() => r'd9feb4554d1947556acc9a7cca119efc40611850';

abstract class _$CategoryState extends $Notifier<Category?> {
  Category? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Category?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Category?>,
              Category?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
