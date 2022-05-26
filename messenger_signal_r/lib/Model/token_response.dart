class TokenResponse {
  String? accessToken;
  String? username;
  int? userId;

  TokenResponse({this.accessToken, this.username, this.userId});

  TokenResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    username = json['username'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['username'] = this.username;
    data['userId'] = this.userId;
    return data;
  }
}