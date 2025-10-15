class User {
  int id;
  String email;
  String? nama;

  User({required this.id, required this.email, this.nama});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], email: json['email'], nama: json['nama']);
  }
}
