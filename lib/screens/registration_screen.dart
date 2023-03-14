import '../models/account.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../utils/app_utils.dart';
import '../utils/firebase_utils.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerBirthDate = TextEditingController();

  void _registerNewUser(String email, String userName, String password, String birthDate) async {
    try {
      await FirebaseUtils.auth.createUserWithEmailAndPassword(email: email, password: password).then((newUser) {
        Account account = Account(email: email, userName: userName, password: password, birthDate: birthDate);
        FirebaseUtils.setCollection('Accounts');
        FirebaseUtils.collection.doc(newUser.user!.uid).set(account.toJson());
        AppUtils.switchScreen(const HomeScreen(), context);
      });
    } on FirebaseAuthException {
      AppUtils.showInfoMessage('Current email is already in use', context);
    }
  }

  void _showDatePickerDialog() async {
    DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
    if (pickedDate != null) {
      setState(() => controllerBirthDate.text = DateFormat('dd.MM.yyyy').format(pickedDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
        child: GestureDetector(
          child: RichText(
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Already registered?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          onTap: () => AppUtils.switchScreen(const AuthScreen(), context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(
                  'images/icon.png',
                  width: 67,
                  height: 67,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextFormField(
                    controller: controllerEmail,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Email must not be empty';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 0),
                  child: TextFormField(
                    controller: controllerUsername,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Username must not be empty';
                      }
                      if (value.length < 8 || value.length >= 16) {
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 0),
                  child: TextFormField(
                    controller: controllerPassword,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Password must not be empty';
                      }
                      if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,16}$').hasMatch(value)) {
                        return 'Password must be from 8 to 16 characters, must contain letters, numbers and special characters';
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 0),
                  child: TextFormField(
                    controller: controllerBirthDate,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Birthdate must not be empty';
                      }
                      if (DateTime.parse(controllerBirthDate.text).isBefore(DateTime.now())) {
                        return 'Birthdate must be less than the current date';
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
                      labelText: 'Birthdate',
                    ),
                    onTap: () => _showDatePickerDialog(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: SizedBox(
                    height: 40,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => _registerNewUser(controllerEmail.text, controllerUsername.text, controllerPassword.text, controllerBirthDate.text),
                      child: const Text(
                        'Register',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
