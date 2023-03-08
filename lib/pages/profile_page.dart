import '../screens/auth_screen.dart';
import '../utils/firebase_utils.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  Future<void> updateProfile() async {
    String updateStatus = "Successful";

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(updateStatus, textAlign: TextAlign.center)));
  }

  void signOut() {
    FirebaseUtils.auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
            child: Center(
              child: Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controllerUsername,
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return "Логин не должен быть пустым";
                        }
                        if (value.length < 8 || value.length >= 16) {
                          return "Логин должен быть от 8 до 16 символов";
                        }
                        return null;
                      }),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: "Логин",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(25, 5, 25, 20)),
                    TextFormField(
                      controller: controllerEmail,
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return "Email не должен быть пустым";
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return "Email введен неправильно";
                        }
                        return null;
                      }),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: "Email",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 5, 25, 10),
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                    ),
                    onPressed: () async {
                      updateProfile();
                    },
                    child: const Text("Изменить"),
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(25, 5, 25, 5)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                    ),
                    onPressed: () => signOut(),
                    child: const Text("Выйти"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
