import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

deleteReminder(BuildContext context, String id, String uid) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: const Text('Delete Reminder'),
        content: const Text('Are you sure you want to delete?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customButtons(context, () {
                try {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('reminder')
                      .doc(id)
                      .delete();
                  Utils.toastMessage('Reminder Deleted');
                  Navigator.pop(context);
                } catch (e) {
                  Utils.toastMessage(e.toString());
                }
              }, 'Delete'),
              customButtons(context, () {
                Navigator.pop(context);
              }, 'Cancel'),
            ],
          ),
        ],
      );
    },
  );
}

Widget customButtons(
    BuildContext context, void Function()? onTap, String text) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}
