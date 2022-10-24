import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:elas_promocoes/promocao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class EditorPromocao extends HookWidget {
  const EditorPromocao({super.key, this.promocao});
  final Promocao? promocao;

  bool get _isEditar => promocao != null;

  String? _emptyValidator(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final nome = useTextEditingController();
    final link = useTextEditingController();
    final cupom = useTextEditingController();
    final descricao = useTextEditingController();
    final imageFile = useState<File?>(null);
    final key = useState(GlobalKey<FormState>());
    final picker = useState(ImagePicker());
    return Form(
      key: key.value,
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
              onPressed: () {
                if (key.value.currentState!.validate()) {
                  if (imageFile.value == null && !_isEditar) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Nenhuma imagem foi selecionada.')));
                    return;
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(_isEditar ? 'Salvar' : 'Adicionar')),
        ],
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            // shrinkWrap: true,
            children: [
              const Text('Nome do produto:'),
              TextFormField(
                controller: nome,
                validator: _emptyValidator,
              ),
              const Text('Link:'),
              TextFormField(
                controller: link,
                keyboardType: TextInputType.url,
                validator: _emptyValidator,
              ),
              const Text('Imagem:'),
              if (imageFile.value != null)
                Image.file(imageFile.value!, fit: BoxFit.fitWidth),
              ElevatedButton(
                  onPressed: () async {
                    final imagem = await picker.value.pickImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    if (imagem != null) {
                      imageFile.value = File(imagem.path);
                    }
                  },
                  child: const Text('Selecionar Imagem.')),
              const Text('Cupom de promoção:'),
              TextFormField(
                controller: cupom,
              ),
              const Text('Valor:'),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    locale: 'pt',
                    symbol: 'R\$',
                  ),
                ],
                validator: _emptyValidator,
              ),
              const Text('Descrição:'),
              TextFormField(
                controller: descricao,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
