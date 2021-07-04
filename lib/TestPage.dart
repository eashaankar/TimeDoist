import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:filter_list/filter_list.dart';

class TestPage extends StatefulWidget {

  TestPage({required this.app});
  final FirebaseApp app;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  final referenceDatabase = FirebaseDatabase.instance;
  final taskfirename = 'TaskTitle';
  final taskfiredate = '01-12-2000';
  final customController = TextEditingController();
  final _dateController = TextEditingController();
  var _currentSelectedValue='General';


  DateTime _dateTime = DateTime.now();

  _selectedTodoData(BuildContext context) async{
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100));

    if(_pickedDate!= null){
      setState((){
        _dateTime=_pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(_pickedDate);

  });
  }
}

  void _openFilterDialog() async {
    await FilterListDialog.display<String>(
        context,
        listData: ,
        selectedListData: selectedCountList,
        height: 480,
        headlineText: "Select Count",
        searchFieldHintText: "Search Here",
        choiceChipLabel: (item) {
          return item;
        },
        validateSelectedItem: (list, val) {
          return list!.contains(val);
        },
        onItemSearch: (list, text) {
          if (list!.any((element) =>
              element.toLowerCase().contains(text.toLowerCase()))) {
            return list!
                .where((element) =>
                element.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
          else{
            return [];
          }
        },
        onApplyButtonClick: (list) {
          if (list != null) {
            setState(() {
              selectedCountList = List.from(list);
            });
          }
          Navigator.pop(context);
        });
  }

  Future _asynccreateAlertDialog(BuildContext context) async{

    final ref = referenceDatabase.reference();

    @override
    var alert = AlertDialog(
      title: Text("Enter Task"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: customController,
              decoration: InputDecoration(
                labelText: 'Task',
              ),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a Date',
                prefixIcon: InkWell(
                  onTap: () {
                    _selectedTodoData(context);
                  },
                  child: Icon(Icons.calendar_today),
                )
              ),
            ),
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text("Select Priority"),
                  value: _currentSelectedValue,
                  isDense: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentSelectedValue = newValue!;
                    });
                    print(_currentSelectedValue);
                  },
                  items: <String>['Urgent', 'Important', 'General'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
          ],
        ),
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
                .set({'Title':customController.text, 'Date':_dateController.text, 'Category':_currentSelectedValue})
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
            _dateController.clear();
            //_currentSelectedValue.clear();

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
      body:

      SingleChildScrollView(
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
                      return Column(
                        children: [
                          new ListTile(
                              trailing: IconButton(icon: Icon(Icons.delete),
                                onPressed: () => _taskName.child(snapshot.key).remove(),),
                              title: new Text(snapshot.value['Title']?? 'Error'),
                            subtitle: Wrap(
                              children: [
                                new Text(snapshot.value['Category'] ?? 'Error', textAlign: TextAlign.start,),
                                new Text(' // '),
                                new Text(snapshot.value['Date'] ?? 'Error', textAlign: TextAlign.start,)
                              ],
                            ),
                          ),
                        ],
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

