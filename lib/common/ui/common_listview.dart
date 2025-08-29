import 'package:drift_todo_train/service/state_model/base_state_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

typedef ItemBuilder<U> =
    Widget Function(BuildContext context, int index, U model);

class CommonListview<U, T extends BaseStateModel> extends ConsumerWidget {
  const CommonListview({
    super.key,
    required this.provider,
    required this.itemBuilder,
  });

  final ProviderListenable<T> provider;
  final ItemBuilder<U> itemBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    return switch (state) {
      Loading() => Center(child: CircularProgressIndicator()),
      LoadedModel(datas: final datas) => ListView.builder(
        itemCount: datas.length,
        itemBuilder: (context, index) {
          return itemBuilder(context, index, datas[index]);
        },
      ),
      Error(message: final message) => Center(child: Text(message)),
    };
  }
}
