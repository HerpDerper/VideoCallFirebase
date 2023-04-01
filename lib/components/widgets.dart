import 'package:flutter/material.dart';

import '../models/message.dart';

class ChatWidgets {
  static Widget messagesCard(bool check, Message message) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (check) const Spacer(),
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
                message.isEdited ? '${message.text}\n${message.dateSent} Edited' : '${message.text}\n${message.dateSent}',
                style: TextStyle(
                  color: check ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (!check) const Spacer(),
        ],
      ),
    );
  }
}
