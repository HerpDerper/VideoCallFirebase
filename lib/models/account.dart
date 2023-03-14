class Account {
  String email;
  String userName;
  String password;
  String birthDate;
  String image;
  String status;

  Account({required this.email, required this.userName, required this.password, required this.birthDate, this.image = 'default.png', this.status = "Online"});

  Map<String, dynamic> toJson() => {'email': email, 'userName': userName, 'password': password, 'birthDate': birthDate, 'image': image, 'status': status};

  static Account fromJson(Map<String, dynamic> json) => Account(
      email: json['email'], userName: json['userName'], password: json['password'], birthDate: json['birthDate'], image: json['image'], status: json['status']);
}
