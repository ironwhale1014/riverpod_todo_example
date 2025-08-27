// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dao.dart';

// ignore_for_file: type=lint
mixin _$TodoDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoryEntriesTable get categoryEntries => attachedDatabase.categoryEntries;
  $TodoEntriesTable get todoEntries => attachedDatabase.todoEntries;
}
mixin _$CategoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoryEntriesTable get categoryEntries => attachedDatabase.categoryEntries;
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(todoDao)
const todoDaoProvider = TodoDaoProvider._();

final class TodoDaoProvider
    extends $FunctionalProvider<TodoDao, TodoDao, TodoDao>
    with $Provider<TodoDao> {
  const TodoDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoDaoHash();

  @$internal
  @override
  $ProviderElement<TodoDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoDao create(Ref ref) {
    return todoDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoDao>(value),
    );
  }
}

String _$todoDaoHash() => r'3f62e5494b384c90a284ffaf696c8ddfd58be9f6';

@ProviderFor(categoryDao)
const categoryDaoProvider = CategoryDaoProvider._();

final class CategoryDaoProvider
    extends $FunctionalProvider<CategoryDao, CategoryDao, CategoryDao>
    with $Provider<CategoryDao> {
  const CategoryDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryDaoHash();

  @$internal
  @override
  $ProviderElement<CategoryDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CategoryDao create(Ref ref) {
    return categoryDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryDao>(value),
    );
  }
}

String _$categoryDaoHash() => r'519e877782bd9c7d00f0c1bdc2a0abdd355051ff';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
