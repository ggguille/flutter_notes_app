import 'package:flutter/material.dart';
import 'package:flutter_notes_app/domain/notes/value_objects.dart';

class ColorField extends StatelessWidget {
  const ColorField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: NoteColor.predefinedColors.length,
        itemBuilder: (context, index) {
          final itemColor = NoteColor.predefinedColors[index];
          return Material(
            color: itemColor,
            elevation: 4,
            shape: const CircleBorder(
              side: BorderSide.none,
            ),
            child: Container(
              width: 50,
              height: 50,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 12,
          );
        },
      ),
    );
  }
}
