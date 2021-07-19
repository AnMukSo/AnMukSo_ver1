import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STANDARD_ in JUDA"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('test').doc('data').snapshots(),
      builder: (context, snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }

       return Center(child: Text(snapshot.data['name'],style: TextStyle(fontSize: 30),));


          //return Text(snapshots.data['name']);
      },
      ),

    ); }
}
