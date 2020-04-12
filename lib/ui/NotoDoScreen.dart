import 'package:flutter/material.dart';
import 'package:todoapp/model/nodo_item.dart';
import 'package:todoapp/util/database_client.dart';
import 'package:todoapp/util/date_formatter.dart';

class NotoDoScreen extends StatefulWidget {
  @override
  _NotoDoScreenState createState() => _NotoDoScreenState();
}

class _NotoDoScreenState extends State<NotoDoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper();
  List<NoDoItem> _itemList = <NoDoItem>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readNodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
                itemCount: _itemList.length,
                reverse: false,
                padding: EdgeInsets.all(8.0),
                itemBuilder: (_, int index) {
                  return Card(
                    color: Colors.black87,
                    child: ListTile(
                      title: _itemList[index],
                      onLongPress: () => _udateItem(_itemList[index], index),
                      trailing: Listener(
                        key: Key(_itemList[index].itemName),
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPointerDown: (pointerEvent) =>
                            _deleteNoDo(_itemList[index].id, index),
                      ),
                    ),
                  );
                }),
          ),
          Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Item',
        backgroundColor: Colors.redAccent,
        child: ListTile(
          title: Icon(Icons.add),
        ),
        onPressed: _showFormDialog,
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "eg Dont buy stuff",
                  icon: Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            _handelSubmit(_textEditingController.text);
            _textEditingController.clear();
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handelSubmit(String text) async {
    debugPrint(text);
    _textEditingController.clear();
    NoDoItem noDoItem = NoDoItem(text, dateFormatted());
    debugPrint(noDoItem.toMap().toString());
    int saveItemId = await db.saveItem(noDoItem);
    NoDoItem addItem = await db.getItem(saveItemId);

    setState(() {
      _itemList.insert(0, addItem);
    });
    Navigator.pop(context);
    print("Saved item $saveItemId");
    //.pop(context);
  }

  _readNodoList() async {
    List items = await db.getItems();
    // _itmeList = items;
    items.forEach((item) {
      setState(() {
        _itemList.add(NoDoItem.map(item));
      });
    });
  }

  _udateItem(NoDoItem item, int index) {
    var alert = AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't buy stuff",
                icon: Icon(Icons.update)),
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              NoDoItem newItemUpdated = NoDoItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": dateFormatted(),
                "id": item.id
              });

              _handleSubmittedUpdate(index, item); //redrawing the screen
              await db.updateItem(newItemUpdated); //updating the item
              setState(() {
                _readNodoList(); // redrawing the screen with all items saved in the db
              });

              Navigator.pop(context);
            },
            child: Text("Update")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, NoDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted Item!");

    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }
}
