class Account {
  String email;
  String userName;
  String password;
  String dateBirth;

  Account({required this.email, required this.userName, required this.password, required this.dateBirth});

  Map<String, dynamic> toJson() => {'email': email, 'userName': userName, 'password': password, 'dateBirth': dateBirth};
}
