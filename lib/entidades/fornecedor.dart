class Fornecedor {
  String? forid;
  String? fornome;

  Fornecedor({forid, fornome});

  Fornecedor.fromJson(Map<String, dynamic> json) {
    forid = json['for_id'];
    fornome = json['for_nome'];
  }

  Fornecedor.nulo();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['forid'] = forid;
    data['fornome'] = fornome;
    return data;
  }
}
