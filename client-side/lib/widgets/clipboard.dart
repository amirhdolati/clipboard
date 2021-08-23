import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../server-communication/request-handler.dart';

class Clipboard extends StatefulWidget {
  Clipboard({Key? key}) : super(key: key);
  final _text_edit_controller = TextEditingController();
  @override
  _ClipboardState createState() => _ClipboardState();
}

class _ClipboardState extends State<Clipboard> {
  var _server_clipboard;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.deepPurple),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: FutureBuilder<String>(
              future: RequestHandler().clipboard_get_request(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.data != "") {
                      widget._text_edit_controller.text =
                          snapshot.data.toString();
                      return TextField(
                        controller: widget._text_edit_controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      );
                    } else
                      return Text(
                        "ERROR! can't get quote from server.",
                        style: TextStyle(color: Colors.red),
                      );
                } // switch end
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text("Reload"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    fixedSize: Size(100, 50))),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  RequestHandler().clipboard_post_request(
                      widget._text_edit_controller.text);
                },
                child: Text("Save"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    fixedSize: Size(100, 50))),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Quote",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.deepPurple),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: FutureBuilder<String>(
              future: RequestHandler().get_a_quote(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.data != "") {
                      return AnimatedTextKit(
                        pause: Duration(minutes: 5),
                        animatedTexts: [
                          TypewriterAnimatedText(snapshot.data.toString(),
                              textAlign: TextAlign.center,
                              speed: Duration(milliseconds: 100)),
                        ],
                      );
                    } else
                      return Text(
                        "ERROR! can't get quote from server.",
                        style: TextStyle(color: Colors.red),
                      );
                } // switch end
              }),
        ),
      ],
    );
  }
}
