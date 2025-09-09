// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(TodoService)
const todoServiceProvider = TodoServiceProvider._();

final class TodoServiceProvider
    extends $NotifierProvider<TodoService, BaseStateModel<TodoModel>> {
  const TodoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoServiceHash();

  @$internal
  @override
  TodoService create() => TodoService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseStateModel<TodoModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseStateModel<TodoModel>>(value),
    );
  }
}

String _$todoServiceHash() => r'faa133568e0cdd6794988496b5d3d940f8e6967f';

abstract class _$TodoService extends $Notifier<BaseStateModel<TodoModel>> {
  BaseStateModel<TodoModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<BaseStateModel<TodoModel>, BaseStateModel<TodoModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BaseStateModel<TodoModel>, BaseStateModel<TodoModel>>,
              BaseStateModel<TodoModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
