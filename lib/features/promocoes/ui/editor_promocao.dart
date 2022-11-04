import 'dart:io';

import 'package:elas_promocoes/core/helpers/currency_helper.dart';
import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditorPromocao extends HookConsumerWidget {
  const EditorPromocao({super.key, this.promocao});
  final PromocaoModel? promocao;

  bool get _isEditar => promocao != null;

  String? _emptyValidator(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório.';
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nome = useTextEditingController();
    final link = useTextEditingController();
    final cupom = useTextEditingController();
    final descricao = useTextEditingController();
    final valor = useTextEditingController();
    final pickedFile = useState<XFile?>(null);
    final key = useState(GlobalKey<FormState>());
    final picker = useState(ImagePicker());
    final isLoading = useState(false);
    final mostrarErroImagemObrigatoria = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditar ? 'Editar Promoção' : 'Adicionar Promoção'),
      ),
      body: Form(
        key: key.value,
        child: SizedBox(
          width: double.maxFinite,
          child: ListView(
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
              if (pickedFile.value != null)
                kIsWeb
                    ? Image.network(pickedFile.value!.path)
                    : Image.file(File(pickedFile.value!.path)),
              ElevatedButton(
                  style: pickedFile.value != null
                      ? ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                        )
                      : null,
                  onPressed: () async {
                    pickedFile.value = await picker.value.pickImage(
                        source: ImageSource.gallery, imageQuality: 50);
                  },
                  child: const Text('Selecionar Imagem.')),
              if (mostrarErroImagemObrigatoria.value)
                const Text(
                  'Por favor, selecione uma imagem para o produto.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              const Text('Cupom de promoção:'),
              TextFormField(
                controller: cupom,
              ),
              const Text('Valor:'),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: valor,
                inputFormatters: [
                  MoneyHelper.inputFormatter,
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

// [
// ElevatedButton(
// onPressed: () {
// if (key.value.currentState!.validate()) {
// if (pickedFile.value == null && !_isEditar) {
// mostrarErroImagemObrigatoria.value = true;
// return;
// }
// if (pickedFile.value != null &&
// mostrarErroImagemObrigatoria.value) {
// mostrarErroImagemObrigatoria.value = false;
// }
//
// isLoading.value = true;
//
// final promocao = PromocaoModel(
// nome: nome.text,
// url: link.text,
// valor: valor.text,
// imagemUrl: '',
// cupom: cupom.text.isEmpty ? null : cupom.text,
// descricao:
// descricao.text.isEmpty ? null : descricao.text,
// );
//
// final promocoesService = ref.read(promoServiceProvider);
//
// final imageData = pickedFile.value!.readAsBytes();
// final imageExtension =
// pickedFile.value!.name.split('.').last;
//
// imageData.then((imgData) {
// return promocoesService.add(
// promocao: promocao,
// imageData: imgData,
// imageExtension: imageExtension,
// );
// }).whenComplete(() => Navigator.of(context).pop());
// }
// },
// child: Text(_isEditar ? 'Salvar' : 'Adicionar')),
// ],
