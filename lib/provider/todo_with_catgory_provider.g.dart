// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_with_catgory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTodoWithCategoryHash() =>
    r'503165cc06ae7f8a4b0c95985bad5b7c85ab3b00';

/// See also [getTodoWithCategory].
@ProviderFor(getTodoWithCategory)
final getTodoWithCategoryProvider =
    AutoDisposeStreamProvider<List<TodoWithCategory>>.internal(
      getTodoWithCategory,
      name: r'getTodoWithCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getTodoWithCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTodoWithCategoryRef =
    AutoDisposeStreamProviderRef<List<TodoWithCategory>>;
String _$categoryStateHash() => r'5552a6f61703c5782bb59ec664d14dc8ef28ddec';

/// See also [CategoryState].
@ProviderFor(CategoryState)
final categoryStateProvider =
    AutoDisposeNotifierProvider<CategoryState, Category?>.internal(
      CategoryState.new,
      name: r'categoryStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CategoryState = AutoDisposeNotifier<Category?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
