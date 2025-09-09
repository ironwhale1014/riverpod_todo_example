

# Riverpod 환경에서 Drift 데이터베이스 인스턴스 관리 개선 방안

이 문서는 Riverpod 환경에서 Drift 데이터베이스(`AppDatabase`) 인스턴스의 생명주기를 더 효율적이고 관용적인 방법으로 관리하는 것을 목표로 합니다.

## 현재 구현 방식 (As-Is)

현재 `database.dart` 파일에서는 다음과 같이 데이터베이스 인스턴스를 관리하고 있습니다.

```dart
// lib/database/database.dart

// ... (imports)

// ... (Database class definition)

// 전역에서 단일 인스턴스를 재사용
final _appDbSingleton = AppDatabase();

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  ref.onDispose(() => _appDbSingleton.close());
  return _appDbSingleton;
}
```

### 분석

1.  `_appDbSingleton`이라는 전역 변수(싱글톤)를 생성하여 `AppDatabase` 인스턴스를 앱의 생명주기 동안 유지합니다.
2.  `appDatabase` Provider는 이 전역 인스턴스를 단순히 반환하는 역할을 합니다.
3.  `ref.onDispose`를 사용하여 Provider가 파괴될 때 데이터베이스 연결을 닫도록 설정했습니다.

이 방식은 동작은 하지만, Riverpod의 상태 관리 철학을 온전히 활용하지 못하며 몇 가지 단점을 가집니다.

## 현재 방식의 문제점

### 1. 코드의 중복성 및 장황함

Riverpod의 Provider(`keepAlive: true` 포함)는 그 자체로 상태를 한 번만 생성하고 앱의 생명주기 동안 유지하는 싱글톤처럼 동작합니다. 따라서 별도의 전역 싱글톤 변수(`_appDbSingleton`)를 선언하는 것은 불필요한 중복입니다.

### 2. 테스트의 어려움

전역 변수는 상태를 공유하기 때문에 단위 테스트나 위젯 테스트 시에 문제를 일으킬 수 있습니다. 각 테스트는 독립적인 환경에서 실행되어야 하는데, 전역 인스턴스는 테스트 간에 상태를 공유하게 만들어 예기치 않은 결과를 낳을 수 있습니다. 예를 들어, 특정 테스트에서 데이터베이스를 수정한 것이 다른 테스트에 영향을 줄 수 있습니다.

Riverpod Provider를 사용하면 테스트 환경에서 Provider를 재정의(override)하여 Mock 객체나 테스트용 인메모리 데이터베이스를 쉽게 주입할 수 있어 테스트 격리성이 높아집니다.

### 3. 불명확한 생명주기 관리

현재 코드는 Provider가 전역 인스턴스의 생명주기(`onDispose`)를 관리하는 형태입니다. 하지만 인스턴스 생성 자체는 Provider 외부에서 이루어지므로, 코드의 흐름이 분산되어 직관적이지 않습니다. Provider가 인스턴스의 생성과 소멸을 모두 책임지는 것이 Riverpod의 설계에 더 부합합니다.

## 개선된 구현 방식 (To-Be)

전역 변수를 제거하고 Provider가 `AppDatabase` 인스턴스의 생성과 생명주기를 모두 책임지도록 코드를 리팩토링할 수 있습니다.

```dart
// lib/database/database.dart (개선안)

import 'dart:ui' show Color;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/converter/color_converter.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:drift_todo_train/repository/category_repository.dart';
import 'package:drift_todo_train/repository/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [CategoryEntries, TodoEntries],
  daos: [TodoDao, CategoryDao],
  include: {'sql.drift'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(LazyDatabase(_openConnection));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return NativeDatabase(await getDbFile());
  });
}

// 전역 변수 제거!

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  // Provider가 직접 인스턴스를 생성
  final db = AppDatabase();
  
  // Provider가 파괴될 때 생성했던 인스턴스의 연결을 닫음
  ref.onDispose(() => db.close());
  
  // 생성한 인스턴스를 반환
  return db;
}
```

## 개선 방식의 장점

1.  **코드 간소화**: 불필요한 전역 변수를 제거하여 코드가 더 간결하고 명확해집니다.
2.  **테스트 용이성 향상**: Provider를 재정의하여 테스트 시 Mock 데이터베이스를 주입하기 쉬워집니다.
3.  **관용적인 Riverpod 사용**: 인스턴스의 생성과 소멸을 모두 Provider가 책임지게 함으로써, Riverpod의 상태 관리 패턴을 일관성 있게 따르게 됩니다. 이는 프로젝트의 유지보수성을 높여줍니다.

## 결론

전역 싱글톤 대신 Riverpod Provider를 사용하여 데이터베이스 같은 서비스 객체의 생명주기를 관리하면 코드 구조가 단순해지고 테스트가 용이해지는 등 많은 이점을 얻을 수 있습니다. 이는 Riverpod를 사용하는 프로젝트에서 권장되는 표준적인 접근 방식입니다.
