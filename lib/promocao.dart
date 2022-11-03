import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elas_promocoes/helpers/currency_helper.dart';

class Promocao {
  final String? id;
  final String nome;
  final String url;
  final String imagemUrl;
  final String? cupom;
  final DateTime? criadoEm;
  final String valor;
  final String? descricao;

  Promocao({
    this.id,
    required this.nome,
    required this.url,
    required this.imagemUrl,
    this.cupom,
    this.criadoEm,
    required this.valor,
    this.descricao,
  });

  factory Promocao.fromJson(
          {required Map<String, dynamic> data, required String id}) =>
      Promocao(
        id: id,
        nome: data['nome'],
        url: data['url'],
        imagemUrl: data['img_url'],
        criadoEm: (data['criado_em'] as Timestamp?)?.toDate(),
        cupom: data['cupom'],
        valor: MoneyHelper.fromNumber(data['valor']),
        descricao: data['descricao'],
      );

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'url': url,
        'img_url': imagemUrl,
        'criado_em': criadoEm == null
            ? Timestamp.fromDate(DateTime.now())
            : Timestamp.fromDate(criadoEm!),
        'cupom': cupom,
        'valor': MoneyHelper.toNumber(valor),
        'descricao': descricao,
      };
}
