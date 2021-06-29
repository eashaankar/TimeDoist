import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class TestPage extends StatefulWidget {

  TestPage({required this.app});
  final FirebaseApp app;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  final referenceDatabase = FirebaseDatabase.instance;
  final taskfirename = 'TaskTitle';
  final customController = TextEditingController();

  //final List<String> tasknames = <String>[];

  /*void addItemToList(){
    setState(() {
      tasknames.insert(0,customController.text);
    });
  }*/

  Future _asynccreateAlertDialog(BuildContext context) async{

    final ref = referenceDatabase.reference();


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
            //addItemToList();
            ref
                .child('TaskNameF')
                .push()
                .child(taskfirename)
                .set(customController.text)
                .asStream();

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
            customController.clear();
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

  late DatabaseReference _taskName;

  @override
  void initState(){
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _taskName = database.reference().child('TaskNameF');

    super.initState();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do list')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Flexible(
                        child: new FirebaseAnimatedList(
                          shrinkWrap: true,
                            query: _taskName,
                            itemBuilder: (BuildContext context,
                        DataSnapshot snapshot,
                        Animation<double> animation,
                        int index){
                      return new ListTile(
                          trailing: IconButton(icon: Icon(Icons.delete),
                            onPressed: () => _taskName.child(snapshot.key).remove(),),
                          title: new Text(snapshot.value['TaskTitle'] ?? ''),
                      );
                    })
                      /*child: ListView.builder(
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
                        )*/),
                  ],
                ),
              ),
            ),
          ],
        ),
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
  /*@override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DatabaseReference>('_taskName', _taskName));
  }*/
}