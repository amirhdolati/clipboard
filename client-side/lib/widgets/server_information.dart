import 'package:flutter/material.dart';
import '../models/database.dart';
import '../server-communication/request-handler.dart';

class ServerInformation extends StatefulWidget {
  final _text_edit_controller = TextEditingController();
  ServerInformation({Key? key}) : super(key: key) {
    _text_edit_controller.text = DataBase().ip;
  }
  @override
  _ServerInformationState createState() => _ServerInformationState();
}

class _ServerInformationState extends State<ServerInformation> {
  int? _value = DataBase().is_http ? 1 : 2;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: widget._text_edit_controller,
          decoration: InputDecoration(
            hintText: 'Enter server address',
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListTile(
              title: Text(
                'http',
              ),
              leading: Radio(
                  value: 1,
                  groupValue: _value,
                  onChanged: (int? value) {
                    setState(() => _value = value);
                    DataBase().save_is_http(true);
                  }),
            )),
            Expanded(
                child: ListTile(
              title: Text(
                'https',
              ),
              leading: Radio(
                  value: 2,
                  groupValue: _value,
                  onChanged: (int? value) {
                    setState(() => _value = value);
                    DataBase().save_is_http(false);
                  }),
            )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              DataBase().save_is_http(_value == 1 ? true : false);
              DataBase().save_ip(widget._text_edit_controller.text);
              RequestHandler().ip = widget._text_edit_controller.text;
              RequestHandler().is_http = _value == 1 ? true : false;
              Navigator.of(context).pop();
            },
            child: Text("done"),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                fixedSize: Size(100, 50))),
        SizedBox(
          height: 20,
        ),
      ],
    ));
  }
}
