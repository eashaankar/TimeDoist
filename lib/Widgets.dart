import 'package:flutter/material.dart';
import 'package:to_do_list/TestPage.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'To-Do List',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.black26,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/graph.jfif'))),
          ),
          ListTile(
            leading: Icon(Icons.task),
            title: Text('Tasks'),
            onTap: () => {Navigator.of(context).pop(TestPage)},
          ),
        ],
      ),
    );
  }
}