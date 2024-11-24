class Usuario {
  String? message;
  String? prfid;
  bool? authenticated;
  String? token;

  Usuario({message, tipo, authenticated, token});

  Usuario.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    prfid = json['prf_id'];
    authenticated = json['authenticated'];
    token = json['token'];
  }

  Usuario.nulo();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['prfid'] = prfid;
    data['authenticated'] = authenticated;
    data['token'] = token;
    return data;
  }

  @override
  String toString() {
    return 'Usuario(message: $message, token: $token)';
  }
}
