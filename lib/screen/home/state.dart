import 'package:drift_todo_train/database/database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final activeCategory = StateProvider<Category?>((_) => null);

final entriesInCategory = StreamProvider((ref) {
  final database = ref.watch(appDatabaseStateProvider);
  final current = ref.watch(activeCategory)?.id;
  return database.entriesInCategory(current);
});
