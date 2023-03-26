import 'package:flutter/material.dart';
import 'package:flutter_video_call/controllers/friend_request_controller.dart';

import '../controllers/account_controller.dart';

class AppUtils {
  AccountController controller;

  AppUtils({required this.controller});

  static void showInfoMessage(String messageText, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageText, textAlign: TextAlign.center)));

  static void switchScreen(Widget screen, BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

  void showEditEmailDialog(BuildContext context) {
    TextEditingController controllerEmail = TextEditingController();
    TextEditingController controllerPassword = TextEditingController();
    GlobalKey<FormState> key = GlobalKey();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 24, 19, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controllerEmail,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'Email must not be empty';
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(text)) {
                              return 'Email entered incorrectly';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'Email',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        TextFormField(
                          controller: controllerPassword,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'Password must not be empty';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () {
                            if (!key.currentState!.validate()) return;
                            controller.updateEmail(controllerEmail.text.toLowerCase().trim(), controllerPassword.text);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Submit",
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Back",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditUsernameDialog(BuildContext context) {
    TextEditingController controllerUsername = TextEditingController();
    TextEditingController controllerPassword = TextEditingController();
    GlobalKey<FormState> key = GlobalKey();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 24, 19, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controllerUsername,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'Username must not be empty';
                            }
                            if (text.length < 8 || text.length >= 16) {
                              return 'Username must be from 8 to 16 characters';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'Username',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        TextFormField(
                          controller: controllerPassword,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'Password must not be empty';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () {
                            if (!key.currentState!.validate()) return;
                            controller.updateUsername(controllerUsername.text.trim(), controllerPassword.text);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Submit",
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Back",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditPasswordDialog(BuildContext context) {
    TextEditingController controllerOldPassword = TextEditingController();
    TextEditingController controllerNewPassword = TextEditingController();
    TextEditingController controllerNewPasswordSubmit = TextEditingController();
    GlobalKey<FormState> key = GlobalKey();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 24, 19, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controllerOldPassword,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'Old password must not be empty';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'Old password',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        TextFormField(
                          controller: controllerNewPassword,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'New password must not be empty';
                            }
                            if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,16}$').hasMatch(text)) {
                              return 'New password must be from 8 to 16 characters, must contain letters, numbers and special characters';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'New password',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        TextFormField(
                          controller: controllerNewPasswordSubmit,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'New password submit must not be empty';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'New password submit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () {
                            if (!key.currentState!.validate()) return;
                            controller.updatePassword(controllerOldPassword.text, controllerNewPassword.text, controllerNewPasswordSubmit.text);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Submit",
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Back",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAccountInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 24, 19, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: controller.getAccountImage(),
                  builder: (context, snapshotImage) {
                    if (snapshotImage.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 123, 118, 155),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () => controller.updateImage(),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                          snapshotImage.data.toString(),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.transparent,
                          child: Builder(
                            builder: (context) {
                              return Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: controller.account!.status ? Colors.green : Colors.grey,
                                  radius: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        controller.account!.userName,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        controller.account!.email,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      child: const Text(
                        'Close',
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      child: const Text(
                        'Send friend request',
                      ),
                      onPressed: () {
                        FriendRequestController(context: context).createFriendRequest(controller.account!);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
