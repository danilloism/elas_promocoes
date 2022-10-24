import 'package:elas_promocoes/promocao.dart';
import 'package:flutter/material.dart';

class EditorPromocao extends StatefulWidget {
  const EditorPromocao({super.key, this.promocao});
  final Promocao? promocao;

  @override
  State<EditorPromocao> createState() => _EditorPromocaoState();
}

class _EditorPromocaoState extends State<EditorPromocao> {
  final _key = GlobalKey<FormState>();
  bool get _isEditar => widget.promocao != null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(8),
        contentPadding: const EdgeInsets.all(8),
        title: Center(
          child: Text(_isEditar ? 'Editar Promoção' : 'Adicionar Promoção'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () {},
              child: Text(_isEditar ? 'Salvar' : 'Adicionar')),
        ],
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            // shrinkWrap: true,
            children: [
              const Text('Nome do produto:'),
              TextFormField(),
              const Text('Link:'),
              TextFormField(),
              const Text('Imagem:'),
              TextFormField(),
              const Text('Cupom de promoção:'),
              TextFormField(),
              const Text('Valor:'),
              TextFormField(),
              const Text('Descrição:'),
              TextFormField(),
            ],
          ),
        ),
      ),
    );
  }
}
