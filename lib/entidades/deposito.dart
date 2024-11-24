class Deposito {
  String? depid;
  String? depnome;

  Deposito({depid, depnome});

  Deposito.fromJson(Map<String, dynamic> json) {
    depid = json['dep_id'];
    depnome = json['dep_nome'];
  }

  Deposito.nulo();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['depid'] = depid;
    data['depnome'] = depnome;
    return data;
  }
}
