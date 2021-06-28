import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      home: TestPage(),
    );
  }
}

TextEditingController customController = TextEditingController();

class TestPage extends StatefulWidget {


  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  final referenceDatabase = FirebaseDatabase.instance;
  final taskfirename = 'TaskTitle';

  final List<String> tasknames = <String>[];

  void addItemToList(){
    setState(() {
      tasknames.insert(0,customController.text);
    });
  }

  Future _asynccreateAlertDialog(BuildContext context) async{


    var alert = AlertDialog(
      title: Text("Enter Task"),
      content: TextField(
        controller: customController,
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 4.0,
          child: Text('Submit'),
          onPressed: (){
            addItemToList();
            Navigator.of(context).pop(customController.text.toString());
            final snackBar = SnackBar(
              content: Text('Added ' + customController.text),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );

            // Find the ScaffoldMessenger in the widget tree
            // and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }


  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    return Scaffold(
      appBar: AppBar(title: Text('To-Do list')),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: tasknames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    child: ListTile(
                      title: Text('${tasknames[index]}', style: TextStyle(fontSize: 18),),
                    ),
                    background: Container(
                      color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.1),
                        child: Icon(Icons.check,
                        color: Colors.white,),
                      ),
                    ),
                    key: ValueKey<int>(index),
                    onDismissed: (DismissDirection direction){
                      setState(() {
                        tasknames.removeAt(index);
                      });
                    },

                  );
                },
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _asynccreateAlertDialog(context);
          print('Pressed');
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.black,
        hoverColor: Colors.black54,
      ),
    );
  }
}






