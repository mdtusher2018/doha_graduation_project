class StaffLoginModel {
  final String accessToken;
  final String role;

  StaffLoginModel({required this.accessToken, required this.role});

  factory StaffLoginModel.fromJson(Map<String, dynamic> json) {
    return StaffLoginModel(
      accessToken: json['data']['accessToken'],
      role: json['data']['user']['role'],
    );
  }
}
