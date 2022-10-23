import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlfildnodepractice/alldatabase/database_holder.dart';
import 'package:sqlfildnodepractice/model/todo_model.dart';

class Todo_Screen extends StatefulWidget {
  const Todo_Screen({Key? key}) : super(key: key);

  @override
  State<Todo_Screen> createState() => _Todo_ScreenState();
}

class _Todo_ScreenState extends State<Todo_Screen> {
  bool loader = false;

  final DatabaseHolder databasehd = DatabaseHolder();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController discriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Initence();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Document"),
        centerTitle: true,
      ),
      body: Container(
          child: loader
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                )
              : FutureBuilder(
                  future: databasehd.getTodomathod(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TodoModel>?> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Samthing is wrong'),
                      );
                    } else {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading:
                                    Text('${snapshot.data![index].datetime}'),
                                title: Text('${snapshot.data![index].title}'),
                                subtitle: Text(
                                    '${snapshot.data![index].description}'),
                              );
                            });
                      }
                    }
                    return Container();
                  })),
    );
  }

  Initence() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: 'Title',
                          label: Text(
                            'Title',
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ))),
                    ),
                  ),
                  SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      controller: discriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Discreption',
                          label: Text(
                            'Discreption',
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ))),
                    ),
                  ),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.deepPurple),
                      onPressed: () async {
                        setState(() {
                          loader = true;
                        });

                        var todomodel = TodoModel(
                            id: 1,
                            title: titleController.text,
                            description: discriptionController.text,
                            datetime:
                                DateFormat().add_jm().format(DateTime.now()));
                        await databasehd.addTodoMathod(todomodel);
                        Navigator.pop(context);
                        setState(() {
                          loader = false;
                        });
                      },
                      child: Text('Submit'))
                ],
              ),
            ),
          );
        });
  }
}
