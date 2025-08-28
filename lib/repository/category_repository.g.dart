// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_repository.dart';

// ignore_for_file: type=lint
mixin _$CategoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoryEntriesTable get categoryEntries => attachedDatabase.categoryEntries;
  $TodoEntriesTable get todoEntries => attachedDatabase.todoEntries;
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(categoryRepository)
const categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends $FunctionalProvider<CategoryDao, CategoryDao, CategoryDao>
    with $Provider<CategoryDao> {
  const CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CategoryDao create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryDao>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'034c11543b252da1b48b74e1b712ff5dcdc9b7c5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
