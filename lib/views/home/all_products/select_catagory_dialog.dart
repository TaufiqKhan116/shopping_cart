import 'package:flutter/material.dart';
import 'package:shopping_cart/constants/shared_constants.dart';

// ignore: must_be_immutable
class SelectCategoryDialog extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final Function callBack;

  String _category = '';

  SelectCategoryDialog({this.callBack});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                labelText: 'Product category',
                icon: Icon(Icons.list)
            ),
            items: ['All', ...categoryList].map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text('$item'),
              );
            }).toList(),
            onChanged: (val) {
              _category = val;
            },
            validator: (val) {
              String errorMsg;
              if(val == null)
                errorMsg =  'Must select a category';
              return errorMsg;
            },
          ),
        ),
      ),
      title: Text('Select a category'),
      actions: [
        FlatButton(
          child: Text('Submit'),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              callBack(_category);
              Navigator.pop(context);
            }
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
