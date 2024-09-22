
class Model{
  String name;
  String username;
  String token;
  bool isError;
  String message;

 Model({
    required this.name,
    required this.username,
    required this.token,
    required this.isError,
    required this.message,
  }) ;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'token': token,
    };
  }
  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      name: json['name'],
      username: json['username'],
      token: json['token'],
      isError: false,
      message: "no Error"
    );
  }

 
}
