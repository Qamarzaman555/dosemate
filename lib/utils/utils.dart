import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void fieldFocus(BuildContext context, FocusNode currentfocusNode,
      FocusNode nextFocusNode) {
    currentfocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor:
            const Color.fromRGBO(206, 147, 216, 1).withOpacity(0.7),
        textColor: Colors.black.withOpacity(0.4),
        fontSize: 16);
  }
}

extension EmptySpace on num {
  SizedBox get spaceY => SizedBox(
        height: toDouble(),
      );
  SizedBox get spaceX => SizedBox(
        width: toDouble(),
      );
}
