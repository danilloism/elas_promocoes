class Promocao {
  final String id;
  final String nome;
  final String url;
  final String imagemUrl;
  final String? cupom;
  final DateTime criadoEm;

  Promocao({
    required this.id,
    required this.nome,
    required this.url,
    required this.imagemUrl,
    this.cupom,
    required this.criadoEm,
  });

  factory Promocao.fromJson(Map<String, dynamic> json) => Promocao(
        id: json['id'],
        nome: json['nome'],
        url: json['url'],
        imagemUrl: json['imagem'],
        criadoEm: DateTime.parse(json['criado_em']),
        cupom: json['cupom'],
      );
}
