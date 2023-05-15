import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Function callBack;

  final TextEditingController searchController = TextEditingController();

  SearchDialog({this.callBack});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: 'Search'
              ),
              validator: (val) {
                String errorMsg;
                if(val.isEmpty)
                  errorMsg = "Field can't be empty";
                return errorMsg;
              },
            )),
      ),
      title: Text('Search by product name'),
      actions: [
        FlatButton(
          child: Text('Submit'),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              callBack(searchController.text);
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
