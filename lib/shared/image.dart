//원래 수미 코드

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:an_muk_so/theme/colors.dart';

class FoodImage extends StatefulWidget {
  final String foodItemSeq;

  const FoodImage({Key key, this.foodItemSeq}) : super(key: key);

  @override
  _FoodImageState createState() => _FoodImageState();
}

class _FoodImageState extends State<FoodImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _downloadURLExample(widget.foodItemSeq),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == 'null') {
            return Container(
              decoration: BoxDecoration(border: Border.all(color: gray75)),
              child: Image.asset('assets/images/null.png'),
            );
          } else {
            return Container(
                decoration: BoxDecoration(border: Border.all(color: gray75)),
                child: Image.network(snapshot.data));
          }
        } else {
          return Container();
        }
      },
    );
  }
}

Future<String> _downloadURLExample(String itemSeq) async {
  try {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('Image/$itemSeq.jpeg')
        .getDownloadURL();


    return downloadURL;
  } on firebase_storage.FirebaseException catch (e) {
    if (e.code == 'object-not-found') {
      // String downloadURL = await firebase_storage.FirebaseStorage.instance
      //     .ref('null.png')
      //     // .ref('Image/195900043.png')
      //     .getDownloadURL();

      return 'null';
    }
  }
}

