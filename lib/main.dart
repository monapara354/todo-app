import 'package:flutter/material.dart';
import 'package:todo/db_handler.dart';
import 'package:todo/notes.dart';
import 'package:todo/todu.dart';

void main() {
  runApp(MaterialApp(
    home: myapp(),
  ));
}

class myapp extends StatefulWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  //List todos = [];

  String input = "";
  String des = "";

  bool isFavourite = false;

  Dbhelper? dbhelper;

  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbhelper = Dbhelper();
    loadData();
  }

  loadData() async {
    notesList = dbhelper!.getNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 136, 209, 243),
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 136, 209, 243),
        foregroundColor: Colors.black,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: TextField(
                    decoration: InputDecoration(hintText: 'Enter Title'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  content: TextFormField(
                    decoration: InputDecoration(hintText: 'Description'),
                    //  maxLines: 5,
                    onChanged: (String value) {
                      des = value;
                    },
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                    FlatButton(
                        autofocus: true,
                        focusColor: Colors.black26,
                        onPressed: () {
                          dbhelper!
                              .insert(
                                  NotesModel(title: input, description: des))
                              .then((value) {
                            print('data add');
                            setState(() {
                              notesList = dbhelper!.getNoteList();
                            });
                          }).onError((error, stackTrace) {
                            print(error.toString());
                          });

                          Navigator.pop(context);
                        },
                        child: const Text('Add')),
                  ],
                  // Navigator.pop(context);
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                );
              });
        },
        child: Icon(
          Icons.add,
          size: 29,
        ),
      ),
      body: FutureBuilder(
          future: notesList,
          builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
            return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.hasError) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // progress indicator
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // return Dismissible(
                  //   key: ValueKey<int>(snapshot.data![index].id!),
                  return Card(
                    elevation: 6,
                    shadowColor: const Color.fromARGB(255, 41, 40, 40),
                    // color: Color.fromARGB(255, 220, 220, 153),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                        right: 15,
                      ),
                      title: Text(
                        snapshot.data![index].title.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        snapshot.data![index].description.toString(),
                        style:
                            TextStyle(color: Color.fromARGB(221, 68, 67, 67)),
                      ),
                      // trailing: IconButton(
                      //   icon: Icon(
                      //     Icons.star,
                      //     color: isFavourite
                      //         ? Colors.red
                      //         : const Color.fromARGB(255, 114, 113, 113),
                      //   ),
                      //   onPressed: () {
                      //     setState(() {
                      //       // todos[index];
                      //       snapshot.data![index].id!;

                      //       isFavourite = !isFavourite;
                      //     });
                      //   },
                      // ),
                      onTap: () {
                        // snapshot.data![index].id!;
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ToduOp(
                        //               // total: index,
                        //               title: [snapshot.data![index].title]
                        //                   .toString(),
                        //               // descrption: des,
                        //               // NotesModel: notesList,
                        //             )));
                        // {
                        //   print(snapshot.data![index].id);
                        // }
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext contex) {
                              return AlertDialog(
                                title: Text(
                                  'Are you sure delete',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                      onPressed: (() {
                                        Navigator.pop(context);
                                      }),
                                      child: Text('Cancel')),
                                  FlatButton(
                                      onPressed: (() {
                                        setState(() {
                                          //todos.removeAt(index);
                                          dbhelper!.delete(
                                              snapshot.data![index].id!);
                                          notesList = dbhelper!.getNoteList();
                                          snapshot.data!
                                              .remove(snapshot.data![index]);
                                        });
                                        Navigator.pop(context);
                                      }),
                                      child: Text('Delete')),
                                ],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              );
                            });
                      },
                    ),
                  );
                },
                itemCount: snapshot.data?.length);
          }),
    );
  }
}
