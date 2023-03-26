import 'package:flutter/material.dart';

class ChatWidgets {
  static Widget messagesCard(i, message, time) {
    bool check = i % 2 == 0;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (check) const Spacer(),
          if (!check)
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 10,
              child: Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 250,
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: check ? Colors.indigo.shade300 : Colors.grey.shade300,
              ),
              child: Text(
                '$message\n$time',
                style: TextStyle(
                  color: check ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (check)
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 10,
              child: Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
            ),
          if (!check) const Spacer(),
        ],
      ),
    );
  }
}
