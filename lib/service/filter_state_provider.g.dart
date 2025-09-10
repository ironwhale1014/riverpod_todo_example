// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(TodoListFilterState)
const todoListFilterStateProvider = TodoListFilterStateProvider._();

final class TodoListFilterStateProvider
    extends $NotifierProvider<TodoListFilterState, TodoListFilter> {
  const TodoListFilterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListFilterStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListFilterStateHash();

  @$internal
  @override
  TodoListFilterState create() => TodoListFilterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoListFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoListFilter>(value),
    );
  }
}

String _$todoListFilterStateHash() =>
    r'c24693b86035efded4795feea09419a76a45911a';

abstract class _$TodoListFilterState extends $Notifier<TodoListFilter> {
  TodoListFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TodoListFilter, TodoListFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TodoListFilter, TodoListFilter>,
              TodoListFilter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
