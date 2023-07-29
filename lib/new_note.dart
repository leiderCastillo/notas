import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notas/structs.dart';
import 'package:notas/style.dart';

class NewNote extends StatefulWidget {
  final int id;
  const NewNote(
    {
      required this.id,
      super.key
    }
  );
  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {

  int _numCharacters = 0;
  String _time = "";
  late DateTime _dateTime;
  //bool _keyboardActive = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  void getData(){
    if(notes.length <= widget.id){
      _dateTime = DateTime.now();
      DateFormat dateFormatter = DateFormat('d MMMM');
      DateFormat timeFormatter = DateFormat('h:mm a');
      _time =  "${dateFormatter.format(_dateTime)} ${timeFormatter.format(_dateTime)} ";
      _numCharacters = 0;
      titleController.clear();
      contentController.clear();
    }else{
      _time = notes[widget.id].dateTimeText;
      _numCharacters = notes[widget.id].characters;
      contentController.text = notes[widget.id].content;
      titleController.text = notes[widget.id].title;
    }
  }

  void setData(){
    _numCharacters = titleController.text.length + contentController.text.length;
    if(notes.length <= widget.id){
      notes.add(
        Note(
          title: titleController.text,
          content: contentController.text,
          dateTime: _dateTime,
          dateTimeText: _time,
          characters: _numCharacters
        )
      );
    }else{
      notes[widget.id].content = contentController.text;
      notes[widget.id].title = titleController.text;
    }
    setState(() { });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ThemeData.light().scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.black,),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back_ios_rounded),),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.ios_share)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20,5,20,10),
        children: [
          TextField(
            controller: titleController,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: Style.fontTitleSize),
            decoration: const InputDecoration(  
              border: InputBorder.none,
              hintText: "Título"
            ),
            onChanged: (_) => setData(),
          ),
          Text("$_time | $_numCharacters caracteres",textScaleFactor: 0.8, style: const TextStyle(color: Colors.grey)),
          TextField(
            controller: contentController,
            maxLines: null,
            decoration: const InputDecoration(  
              border: InputBorder.none,
              hintText: "Contenido"
            ),
            onChanged: (_) => setData(),
          )
        ],
      ),
    );
  }
}