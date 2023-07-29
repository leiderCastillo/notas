import 'package:flutter/material.dart';

class Note{
  String title;
  String content;
  String dateTimeText;
  DateTime dateTime;
  int characters;
  Note(
    {
      required this.title,
      required this.content,
      required this.dateTime,
      required this.dateTimeText,
      required this.characters
    }
  );
}

class Category{
  final String name;
  final Color color;
  Category({
    required this.name,
    required this.color
  });
}

List<Note> notes = [];
List<Category> categories = [
    Category(name: "Todo", color: const Color.fromARGB(255, 161, 179, 228)),
    Category(name: "Casa", color: const Color.fromARGB(255, 161, 228, 161)),
    Category(name: "Trabajo", color: const Color.fromARGB(255, 228, 224, 161)),
    Category(name: "Estudio", color: const Color.fromARGB(255, 228, 161, 161)),
    Category(name: "Personal", color: const Color.fromARGB(255, 209, 161, 228)),
    Category(name: "Otros", color: const Color.fromARGB(255, 161, 228, 217)),
];
