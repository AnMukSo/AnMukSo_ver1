import 'package:flutter/material.dart';
import 'package:an_muk_so/theme/colors.dart';

const textInputDecoration = InputDecoration(
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: gray100),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: primary300_main),
  ),
  hintStyle: TextStyle(fontSize: 16.0, color: gray100),
);
