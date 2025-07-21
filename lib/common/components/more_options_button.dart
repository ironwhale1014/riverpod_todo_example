import 'package:flutter/material.dart';

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key, this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IconButton(
          onPressed: () async {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final offset = renderBox.localToGlobal(Offset.zero);

            final selectedValue = await showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                offset.dx + renderBox.size.width,
                offset.dy,
                offset.dx + renderBox.size.width,
                offset.dy,
              ),
              items: [
                if (onEdit != null)
                  PopupMenuItem(value: 'edit', child: Text('수정하기')),
                if (onDelete != null)
                  PopupMenuItem(value: 'delete', child: Text('삭제하기')),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );

            if (selectedValue != null) {
              switch (selectedValue) {
                case 'edit':
                  onEdit?.call();
                case 'delete':
                  onDelete?.call();
              }
            }
          },
          icon: Icon(Icons.more_vert),
        );
      },
    );
  }
}
