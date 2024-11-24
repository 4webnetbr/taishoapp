class Produto {
  String? proid;
  String? pronome;
  String? undsigla;
  String? minimo;
  String? maximo;
  String? saldo;

  Produto({proid, pronome, undsigla, saldo});

  Produto.fromJson(Map<String, dynamic> json) {
    proid = json['proid'];
    pronome = json['pronome'];
    undsigla = json['undsigla'];
    minimo = json['minimo'];
    maximo = json['maximo'];
    saldo = json['saldo'];
  }

  Produto.nulo();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['proid'] = proid;
    data['pronome'] = pronome;
    data['undsigla'] = undsigla;
    data['minimo'] = minimo;
    data['maximo'] = maximo;
    data['saldo'] = saldo;
    return data;
  }
}
