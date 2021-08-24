import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../server-communication/request-handler.dart';
import '../data/offline_quote.dart';

class Clipboard extends StatefulWidget {
  Clipboard({Key? key}) : super(key: key);
  final _text_edit_controller = TextEditingController();
  @override
  _ClipboardState createState() => _ClipboardState();
}

class _ClipboardState extends State<Clipboard> {
  var _server_clipboard;
  Future<Null> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.deepPurple),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: FutureBuilder<String>(
                future: RequestHandler().clipboard_get_request(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                          "ERROR! CAN't GET CLIPBOARD FROM SERVER!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        );
                  } // switch end
                }),
          ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      RequestHandler().clipboard_post_request(
                          widget._text_edit_controller.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: ListTile(
                          title: Text(
                            "Sending save request...",style: TextStyle(color: Colors.white),
                          ),
                          leading: Icon(Icons.send_sharp,color: Colors.white,),
                        )),
                      );
                    },
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        fixedSize: Size(100, 50))),
              ),
            
          SizedBox(
            height: 20,
          ),
          Text(
            "Quote",
            textAlign: TextAlign.center,
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
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.data != "") {
                        return AnimatedTextKit(
                          pause: Duration(minutes: 1),
                          animatedTexts: [
                            TypewriterAnimatedText(snapshot.data.toString(),
                                textAlign: TextAlign.center,
                                speed: Duration(milliseconds: 100)),
                          ],
                        );
                      } else
                        return AnimatedTextKit(
                          pause: Duration(minutes: 1),
                          animatedTexts: [
                            TypewriterAnimatedText(
                                OfflineQuote().quote.first['quote'],
                                textAlign: TextAlign.center,
                                speed: Duration(milliseconds: 100)),
                          ],
                        );
                  } // switch end
                }),
          ),
        ],
      ),
    );
  }
}
