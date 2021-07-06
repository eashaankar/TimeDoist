import 'package:flutter/material.dart';
import 'package:to_do_list/Pomodoro.dart';
import 'package:to_do_list/TestPage.dart';

class NavDrawer extends StatelessWidget {
  get app => null;

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TestPage(app: app,)),
              );
            }
            //{Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Pomodoro'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CountDownTimer()),
              );
            }
          ),
        ],
      ),
    );
  }
}