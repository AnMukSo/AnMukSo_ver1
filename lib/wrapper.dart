import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/initial/1_policy_agree.dart';

import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/login/login.dart';
import 'package:an_muk_so/bottom_bar_navigation.dart';
import 'package:an_muk_so/services/db.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // TODO: check an auto-login
    final TheUser user = Provider.of<TheUser>(context);

    if (user == null) {
      return LoginPage();
    } else {
      return FutureBuilder<bool>(
          future: DatabaseService(uid: user.uid).checkIfDocExists(user.uid),
          builder: (context, snapshot) {
            // return BottomBar();

            if (snapshot.data == false) {
              return PolicyAgreePage();
            } else {
              return BottomBar();
            }
          });
    }
  }
}
