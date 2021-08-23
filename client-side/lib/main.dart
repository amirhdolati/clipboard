import 'package:flutter/material.dart';
import 'models/database.dart';
import 'widgets/server_information.dart';
import 'widgets/clipboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'clipboard client side',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("clipboard")),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.network_wifi),
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => ServerInformation(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        body: FutureBuilder<bool>(
            future: DataBase().load_database(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.data == true) {
                    return SingleChildScrollView(child: Clipboard());
                  } else
                    return Dialog(
                        child: Text(
                            "something wrong! maybe you reject storage permission!"));
              } // switch end
            } // builder end
            ));
  }
}
