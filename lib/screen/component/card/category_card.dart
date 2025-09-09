import 'package:drift_todo_train/domain/category.dart';
import 'package:flutter/material.dart';

/// 각 카테고리 항목을 표시하는 카드 위젯
class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // 왼쪽에는 카테고리 색상을 표시하는 원을 배치합니다.
      leading: CircleAvatar(
        backgroundColor: category.color ?? Colors.grey,
        radius: 12,
      ),
      // 카테고리 이름과 게시물 수를 함께 표시합니다.
      title: Row(
        children: [
          Expanded(
            child: Text(
              category.name ?? '기본',
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${category.count}',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
      // 오른쪽 끝에 팝업 메뉴 버튼을 배치합니다.
      trailing: category.name != null
          ? PopupMenuButton<String>(
              onSelected: (value) {
                // 메뉴 항목 선택 시 호출될 로직
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('수정'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20),
                      SizedBox(width: 8),
                      Text('삭제'),
                    ],
                  ),
                ),
              ],
            )
          : SizedBox(width: 48,),
    );
  }
}
