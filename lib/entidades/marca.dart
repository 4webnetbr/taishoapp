class Marca {
  String? proid;
  String? undid;
  String? pronome;
  String? undprod;
  String? promarca;
  String? undmarca;
  String? fatorconv;
  String? saldo;

  Marca(
      {proid,
      undid,
      pronome,
      undprod,
      promarca,
      undmarca,
      fatorconv,
      saldo});

  Marca.fromJson(Map<String, dynamic> json) {
    proid = json['proid'];
    undid = json['undid'];
    pronome = json['pronome'];
    undprod = json['undprod'];
    promarca = json['promarca'];
    undmarca = json['undmarca'];
    fatorconv = json['fatorconv'];
    saldo = json['saldo'];
  }

  Marca.nulo();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['proid'] = proid;
    data['undid'] = undid;
    data['pronome'] = pronome;
    data['undprod'] = undprod;
    data['promarca'] = promarca;
    data['undmarca'] = undmarca;
    data['fatorconv'] = fatorconv;
    data['saldo'] = saldo;
    return data;
  }
}
