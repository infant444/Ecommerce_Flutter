class UserModel {
  String name, email, address, phone, profile;

  UserModel({
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.profile,
  });
  factory UserModel.formJson(Map<String, dynamic> json) {
    return UserModel(
        name: json["name"] ?? "User",
        address: json["address"] ?? "",
        email: json["email"] ?? "",
        phone: json["phone"] ?? "",
        profile: json["profile"] ?? "");
  }
}
