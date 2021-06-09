/* Message to luis. Finding a skeleton code/template to go off was simple enough
* here is the code i based mine upon. You will however find some key differences
* https://github.com/TheAlphaApp/flutter-task-planner-app/blob/master/lib/main.dart
* I made sure to take the time to actually understand what is going on. The author of this code also
* happened to write an article about it on medium. feel free to compare their code to mine! */



// Import MaterialApp and other widgets needed to create app.
import 'package:flutter/material.dart';

void main() => runApp(new TodoApp()); //starts executing here


class TodoApp extends StatelessWidget {
  /* Every component in Flutter is a widget, even the whole app itself
This is a stateless widget since it doesn't change when user interacts with it!
 This is the top bar.*/
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Todo List',
        home: new TodoList()
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();   //TodoListState will make a change - statefull
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];   //array to keep our todoItems.

  void _addTodoItem(String task) {
    // Add task if user provides input
    if(task.length > 0) {
      // Putting our code inside "setState" tells the app that our state has changed, and
      // it will automatically re-render the list
      setState(() => _todoItems.add(task));
    }
  }

  void _removeTodoItem(int index) {   //create a remove item "function"
    setState(() => _todoItems.removeAt(index));
  }

  void _promptRemoveTodoItem(int index) { //pop up to confirm if user wants to remove.
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Remove "${_todoItems[index]}"?'), // message
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    // The alert is actually part of the navigation stack, so to close it, we
                    // need to pop it.
                    onPressed: () => Navigator.of(context).pop()
                ),
                new FlatButton(
                    child: new Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    }
                )
              ]
          );
        }
    );
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if(index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
        return Scaffold();
      },
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText),
        onTap: () => _promptRemoveTodoItem(index)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.teal, //I jsut like teal
          title: new Text('Todo List')

      ),
      body: _buildTodoList(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.teal,   //again, Hi, I just like teal
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: new Icon(Icons.add)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,   // Make button centre docked

    );
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well as adding
      // a back button to close it
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                  appBar: new AppBar(
                      backgroundColor: Colors.teal, // sticking with teal theme
                      title: new Text('Add a new task')
                  ),
                  body: new TextField(
                    autofocus: true,
                    onSubmitted: (val) {
                      _addTodoItem(val);
                      Navigator.pop(context); // Close the add todo screen
                    },
                    decoration: new InputDecoration(
                        hintText: 'Enter something to do...',
                        contentPadding: const EdgeInsets.all(16.0) // so user doesn't write from first pixel
                    ),
                  )
              );
            }
        )
    );
  }
}

