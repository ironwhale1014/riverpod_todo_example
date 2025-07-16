import 'package:drift_todo_train/domain/base_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef ItemBuilder<U> =
    Widget Function(BuildContext context, int index, U model);

class CommonListview<T extends BaseModel, U> extends ConsumerWidget {
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
      Model() => ListView.builder(
        itemCount: state.data.length,
        itemBuilder: (context, index) {
          final U data = state.data[index];
          return itemBuilder(context, index, data);
        },
      ),
    };
  }
}
