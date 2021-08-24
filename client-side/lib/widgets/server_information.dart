import 'package:flutter/material.dart';
import '../models/database.dart';
import '../server-communication/request-handler.dart';

class ServerInformation extends StatefulWidget {
  final _text_edit_controller = TextEditingController();
  int? _value = DataBase().is_http ? 1 : 2;
  ServerInformation({Key? key}) : super(key: key) {
    _text_edit_controller.text = DataBase().ip;
  }
  @override
  _ServerInformationState createState() => _ServerInformationState();
}

class _ServerInformationState extends State<ServerInformation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: widget._text_edit_controller,
            onSubmitted: (String text) =>
                widget._text_edit_controller.text = text,
            decoration: InputDecoration(
              hintText: 'Enter server address',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
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
                    groupValue: widget._value,
                    onChanged: (int? value) {
                      setState(() => widget._value = value);
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
                    groupValue: widget._value,
                    onChanged: (int? value) {
                      setState(() => widget._value = value);
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
                DataBase().save_is_http(widget._value == 1 ? true : false);
                DataBase().save_ip(widget._text_edit_controller.text);
                RequestHandler().ip = widget._text_edit_controller.text;
                RequestHandler().is_http = widget._value == 1 ? true : false;
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
      )),
    );
  }
}
