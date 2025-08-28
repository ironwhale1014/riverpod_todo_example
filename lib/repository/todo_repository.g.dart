// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_repository.dart';

// ignore_for_file: type=lint
mixin _$TodoDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoryEntriesTable get categoryEntries => attachedDatabase.categoryEntries;
  $TodoEntriesTable get todoEntries => attachedDatabase.todoEntries;
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(todoRepository)
const todoRepositoryProvider = TodoRepositoryProvider._();

final class TodoRepositoryProvider
    extends $FunctionalProvider<TodoDao, TodoDao, TodoDao>
    with $Provider<TodoDao> {
  const TodoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoRepositoryHash();

  @$internal
  @override
  $ProviderElement<TodoDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoDao create(Ref ref) {
    return todoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoDao>(value),
    );
  }
}

String _$todoRepositoryHash() => r'60a0d1e5d0a4181df8bb5dabe72635af63c175ed';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
