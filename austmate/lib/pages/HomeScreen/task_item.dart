import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final String title;
  final String badge;
  final Color badgeColor;
  final bool bold;
  final VoidCallback? onDelete;

  const TaskItem({
    super.key,
    required this.title,
    required this.badge,
    required this.badgeColor,
    this.bold = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F2F2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
                //letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
       Container(
          width: 70, // Fixed width for alignment
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            badge,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
         const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Color(0xFFE53935)),
          onPressed: onDelete,
          tooltip: "Delete",
        ),
      ],
    );
  }
}