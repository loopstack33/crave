import 'package:flutter/material.dart';

Widget text(context, text, size,
    {color = "", boldText = "", fontFamily = "", flow = ""}) {
  return Text(
    text,
    style: TextStyle(
      color: color == "" ? Colors.black : color,
      overflow: flow == "" ? TextOverflow.visible : TextOverflow.ellipsis,
      fontSize: size,
      fontWeight: boldText == "" ? FontWeight.normal : boldText,
      fontFamily: fontFamily == "" ? 'Poppins' : fontFamily,
    ),
  );
}
