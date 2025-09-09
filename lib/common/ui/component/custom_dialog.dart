import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 다른 파일에서도 재사용할 수 있는 범용 확인 다이얼로그 함수
/// 이 함수는 다이얼로그를 화면에 '표시하는' 역할만 담당합니다.
/// [onConfirm] 콜백을 전달하여 '삭제' 버튼의 기본 동작을 재정의할 수 있습니다.
Future<bool?> showCustomConfirmDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  VoidCallback? onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      // 실제 다이얼로그 UI는 별도의 위젯으로 분리하여 호출합니다.
      return _ConfirmDialog(
        title: title,
        content: content,
        onConfirm: onConfirm,
      );
    },
  );
}

/// 다이얼로그의 UI를 구성하는 Stateless 위젯
/// UI의 구조와 모양을 정의하는 역할만 담당합니다.
class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.content,
    this.onConfirm,
  });

  final String title;
  final Widget content;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, textAlign: TextAlign.center),
      content: content,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(
        bottom: 24.0,
        left: 24.0,
        right: 24.0,
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('취소', style: TextStyle(color: Colors.black87)),
          onPressed: () {
            context.pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          // onConfirm 콜백이 제공되면 해당 콜백을, 아니면 기본 pop(true) 동작을 실행합니다.
          onPressed:
              onConfirm ??
              () {
                context.pop();
              },
          child: const Text('삭제', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
