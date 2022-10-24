class Promocao {
  final String? id;
  final String nome;
  final String url;
  final String imagemUrl;
  final String? cupom;
  final DateTime criadoEm;
  final int valor;
  final String? descricao;

  Promocao({
    this.id,
    required this.nome,
    required this.url,
    required this.imagemUrl,
    this.cupom,
    required this.criadoEm,
    required this.valor,
    this.descricao,
  });

  factory Promocao.fromJson(Map<String, dynamic> json) => Promocao(
        id: json['id'],
        nome: json['nome'],
        url: json['url'],
        imagemUrl: json['img_url'],
        criadoEm: DateTime.parse(json['criado_em']),
        cupom: json['cupom'],
        valor: json['valor_em_centavos'],
        descricao: json['descricao'],
      );

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'url': url,
        'img_url': imagemUrl,
        'criado_em': criadoEm,
        'cupom': cupom,
        'valor_em_centavos': valor,
        'descricao': descricao,
      };
}
