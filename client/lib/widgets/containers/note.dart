import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  const Note({@required this.title, Key key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 10,
        minWidth: 300,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outlined,
            size: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: Styles.body1)),
        ],
      ),
    );
  }
}
