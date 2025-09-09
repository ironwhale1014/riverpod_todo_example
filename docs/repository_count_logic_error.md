
# Repository의 카테고리별 Todo 개수 집계 로직 오류 분석

이 문서는 `todo_repository.dart`의 `getTodosWithCategoryEntries` 메소드에 존재하는 데이터 집계(count) 로직 오류를 분석하고 해결 방안을 제시합니다.

## 문제 분석 (As-Is)

현재 `TodoRepository`는 특정 카테고리에 속한 Todo 목록을 가져올 때, `Category` 모델에 포함되는 `count` 값을 잘못 계산하고 있습니다.

다음은 `todo_repository.dart`의 관련 코드입니다.

```dart
// lib/repository/todo_repository.dart

Future<List<TodoModel>> getTodosWithCategoryEntries(
  Category? category,
) async {
  final query = select(todoEntries).join([
    // ... join query
  ]);

  // 1. 특정 카테고리(또는 null)로 Todo 목록을 필터링
  if (category != null && category.id != null) {
    query.where(todoEntries.category.equals(category.id!));
  } else {
    query.where(todoEntries.category.isNull());
  }

  // 2. 필터링된 Todo 목록을 데이터베이스에서 가져옴
  final List<TodoWithCategoryFromEntry> todos = (await query.get())
      .map(_mapper)
      .toList();

  // 3. 필터링된 목록의 길이를 'count'로 사용
  final count = todos.length;

  // 4. 모든 Todo 모델에 동일한 'count' 값을 할당하여 반환
  return todos.map((row) => _todoModelMapper(row, count)).toList();
}

// ...

TodoModel _todoModelMapper(row, count) => TodoModel(
  id: row.todo.id,
  description: row.todo.description,
  category: (row.category != null)
      ? Category(
          id: row.category!.id,
          name: row.category!.name,
          color: row.category!.color,
          // 5. 여기서 잘못된 'count'가 할당됨
          count: count,
        )
      : null,
);
```

### 문제점 시나리오

-   '업무' 카테고리에 총 **10개**의 Todo가 저장되어 있다고 가정해 보겠습니다.
-   사용자가 '업무' 카테고리를 선택하면, `getTodosWithCategoryEntries` 메소드가 호출됩니다.
-   `query.get()`은 10개의 '업무' Todo를 반환하고, `todos.length`는 `10`이 됩니다.
-   이때 `Category` 모델의 `count`는 `10`으로 올바르게 표시됩니다.
-   **하지만**, 만약 나중에 검색 기능이 추가되어 '업무' 카테고리 내에서 '회의'라는 키워드로 검색했다고 가정해 봅시다. 검색 결과로 **2개**의 Todo만 필터링되었습니다.
-   이 경우 `todos.length`는 `2`가 되고, `_todoModelMapper`는 `Category`의 `count`를 `2`로 설정하게 됩니다.
-   결과적으로 UI에는 '업무 (2)'라고 표시되어, 사용자에게 해당 카테고리에 총 2개의 Todo만 있는 것처럼 잘못된 정보를 전달하게 됩니다.

## 근본 원인

`Category` 모델의 `count` 속성은 **'해당 카테고리에 속한 전체 Todo의 개수'**를 의미해야 합니다. 하지만 현재 로직은 '필터링된 결과 목록의 길이'를 `count`로 사용하고 있어 데이터의 의미가 왜곡되고 있습니다.

## 해결 방안

가장 효율적이고 올바른 해결책은 **Drift 파일에 작성된 SQL 쿼리를 활용**하는 것입니다.

이미 `lib/database/sql.drift` 파일에는 각 카테고리별로 Todo의 총개수를 계산하는 매우 효율적인 쿼리가 준비되어 있습니다.

```sql
-- lib/database/sql.drift

getCategoryWithCount : SELECT c.*, (SELECT COUNT(*) FROM todo_entries WHERE todo_entries.category = c.id) as amount
                       FROM category_entries c
                       UNION ALL
                       SELECT null, null, null, (SELECT COUNT(*) FROM todo_entries WHERE todo_entries.category IS NULL );
```

이 쿼리는 각 카테고리와 함께, 서브쿼리를 통해 해당 카테고리에 속한 모든 `todo_entries`의 개수(`amount`)를 한 번에 가져옵니다.

### 추천 리팩토링 방향

1.  **`CategoryRepository`의 역할 강화**:
    `CategoryRepository`가 `getCategoryWithCount` 쿼리를 실행하여, `count`가 정확하게 계산된 `Category` 모델 목록을 반환하는 역할을 전담하도록 합니다.

2.  **`TodoRepository`의 역할 분리**:
    `TodoRepository`는 이름 그대로 `Todo` 데이터를 가져오는 역할에만 집중합니다. `getTodosWithCategoryEntries` 메소드는 더 이상 `Category`의 `count`를 계산하거나 주입할 필요가 없습니다.

3.  **서비스/UI 레이어에서 데이터 조합**:
    화면에서는 `CategoryRepository`를 통해 '카테고리 목록과 각 카테고리별 총개수'를 가져오고, `TodoRepository`를 통해 '선택된 카테고리의 Todo 목록'을 가져와서 각각 필요한 위치에 표시합니다.

이처럼 각 Repository의 역할을 명확히 분리하면 코드가 더 단순해지고, 데이터의 무결성을 지킬 수 있으며, 성능적으로도 더 효율적입니다.

## 결론

현재의 `count` 계산 로직은 명백한 오류이며, 사용자에게 잘못된 정보를 제공할 수 있습니다. `sql.drift`에 이미 준비된 집계 쿼리를 `CategoryRepository`에서 활용하도록 역할을 재분배하여 이 문제를 해결하는 것이 가장 바람직합니다.
