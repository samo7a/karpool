import 'dart:ui';

import 'package:flutter/material.dart';

const String _heroAddTodo = 'add-todo-hero';

class UserModal extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  const UserModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "unique-tag",
          child: Material(
            color: Color(0xff0353A4),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Container(
                child: Text("hello"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
