class Empresa {
  String? empid;
  String? empnome;
  String? empapelido;

  Empresa({empid, empnome, empapelido});

  Empresa.fromJson(Map<String, dynamic> json) {
    empid = json['emp_id'];
    empnome = json['emp_nome'];
    empapelido = json['emp_apelido'];
  }

  Empresa.nulo();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empid'] = empid;
    data['empnome'] = empnome;
    data['empapelido'] = empapelido;
    return data;
  }
}
