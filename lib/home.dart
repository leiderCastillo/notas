import 'package:flutter/material.dart';
import 'package:notas/new_note.dart';
import 'package:notas/structs.dart';
import 'package:notas/style.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  Color backgroundColor = const Color.fromARGB(255, 247, 247, 247);
  int _idCategory = 0;
  double _progressRemove = 0;
  int _idRemove = -1;
  late Animation<double> _animationProgress;
  late AnimationController _controller;

  Color getInterpolatedColor(double factor) {
    Color colorStart = Colors.white;
    Color colorEnd = Colors.red;
    int red = (colorStart.red + (colorEnd.red - colorStart.red) * factor).round();
    int green = (colorStart.green + (colorEnd.green - colorStart.green) * factor).round();
    int blue = (colorStart.blue + (colorEnd.blue - colorStart.blue) * factor).round();
    return Color.fromARGB(255, red, green, blue);
  }

  void initAnimation(){
    const animationDuration = Duration(milliseconds: 100);
    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    _animationProgress = Tween<double>(begin: 25, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    _animationProgress.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return NewNote(id: notes.length,);
            },)
          ).whenComplete(() {
            setState(() {});
          });
        }
      ),

      body:
        CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: backgroundColor,
              foregroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text("Notas app 🤪"),
              actions: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.search))
              ],
            ),

            SliverToBoxAdapter(
              child:SizedBox(
                height: 30,
                child:ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20,0,10,0),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return 
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _idCategory = index;
                        });
                      },
                      child:
                        AnimatedContainer( 
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(right: 10, top : _animationProgress.value),
                          padding: EdgeInsets.fromLTRB(10,_animationProgress.value ,10,5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: categories[index].color.withAlpha(index == _idCategory ? 500 : 50)
                          ),
                          child:
                            Center(child: Text(
                              categories[index].name,
                              style: TextStyle(fontWeight: index == _idCategory ? FontWeight.bold : FontWeight.normal),
                            ),)
                        )
                    );
                  },
                )
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20,),
            ),
            notes.isEmpty ? 
            SliverToBoxAdapter(
              child: 
                Container(
                  padding: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height - 250,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(child:
                    Text(
                      "Haz clic en el botón (+) para añadir una nueva nota.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //fontSize: 20,
                        color: Color.fromARGB(73, 0, 0, 0),
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                )
            )
            :
            SliverList.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return 
              Dismissible(
                key: Key("${notes[index].dateTime}|${notes[index].title}|${notes[index].characters}"),
                confirmDismiss: (direction) {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Advertencia 😬"),
                        content: Text("¿Estás seguro de que deseas eliminar la nota \"${notes[index].title}\" "),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color.fromARGB(123, 158, 158, 158)
                            ),
                            onPressed: (){
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("Cancelar")),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color.fromARGB(255, 255, 0, 0)
                            ),
                            onPressed: (){
                            Navigator.of(context).pop(true);
                            setState(() {
                              notes.removeAt(_idRemove);
                              _idRemove = -1;
                              _progressRemove = 0;
                            });
                          }, child: Text("Eliminar")),
                        ],
                      );
                    },
                  );
                },
                onUpdate: (details) {
                  setState(() {
                    _progressRemove = details.progress;
                    if(_progressRemove != 0){
                      _idRemove = index;
                    }else{
                      _idRemove = -1;
                    }
                  });
                },
                child:
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return NewNote(id: index,);
                      },)
                    ).whenComplete(() {
                      setState(() {});
                    });
                  },
                  child: 
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(20,10,20,0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: index != _idRemove ? Colors.white : getInterpolatedColor(_progressRemove),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notes[index].title,style: TextStyle(fontWeight: FontWeight.bold, fontSize: Style.fontTitleSize-5),),
                          const SizedBox(height: 10,),
                          Text(notes[index].content.split("\n")[0]),
                          const SizedBox(height: 8,),
                          Text(notes[index].dateTimeText,textScaleFactor: 0.8, style: const TextStyle(color: Colors.grey),),
                        ],
                      ),
                    )
                )
              );
            },
          ),
        ]
      )
    );
  }
}