import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/shopping_list.dart';
import 'package:flutter_application_1/utils/dbhelper.dart';

class ShoppingListDialog{
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew){
    DbHelper helper = DbHelper();
    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }

    else {
      txtName.text = "";
      txtPriority.text = "";
    }

    return AlertDialog(
      title: Text((isNew)? 'New shopping list' : 'Edit shopping list'),
      content: SingleChildScrollView(
        child: Column(
          children:<Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
              hintText: 'Shopping list name'
              ),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Shopping list priority (1-3)'
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);
                await helper.insertList(list);
                Navigator.pop(context);
              },
              child: Text('Save Shopping List'),
            )

          ],
        ),
      ),
    );
  }
}
