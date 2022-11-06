import 'dart:io';

import 'package:elas_promocoes/core/helpers/currency_helper.dart';
import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:elas_promocoes/features/promocoes/provider/promocoes_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditorPromocao extends HookConsumerWidget {
  EditorPromocao.adicionar({super.key}) {
    promocaoProvider =
        AutoDisposeFutureProvider((ref) => PromocaoModel.empty());
  }
  EditorPromocao.editar({super.key, required String promocaoId}) {
    promocaoProvider = singlePromocaoProvider(promocaoId);
  }
  late final AutoDisposeFutureProvider<PromocaoModel> promocaoProvider;

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
    final isEditar = useState(false);
    final promocaoToEdit = useState<PromocaoModel?>(null);
    final mostrarErroImagemObrigatoria = useState(false);
    ref.listen(promocaoProvider, (previous, next) {
      next.whenData((promocao) {
        if (promocao.isNotEmpty) {
          promocaoToEdit.value = promocao;
          isEditar.value = true;
          nome.text = promocao.nome;
          link.text = promocao.url;
          cupom.text = promocao.cupom ?? '';
          descricao.text = promocao.descricao ?? '';
          valor.text = promocao.valor;
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditar.value ? 'Editar Promoção' : 'Adicionar Promoção'),
        actions: isLoading.value
            ? const [Center(child: CircularProgressIndicator())]
            : [
                IconButton(
                  icon: const Icon(Icons.done),
                  onPressed: () {
                    if (key.value.currentState!.validate()) {
                      if (pickedFile.value == null && !isEditar.value) {
                        mostrarErroImagemObrigatoria.value = true;
                        return;
                      }
                      if (pickedFile.value != null &&
                          mostrarErroImagemObrigatoria.value) {
                        mostrarErroImagemObrigatoria.value = false;
                      }

                      isLoading.value = true;

                      late final PromocaoModel promocao;
                      if (isEditar.value) {
                        promocao = promocaoToEdit.value!.copyWith(
                          nome: nome.text,
                          url: link.text,
                          valor: valor.text,
                          cupom: cupom.text.isEmpty ? null : cupom.text,
                          descricao:
                              descricao.text.isEmpty ? null : descricao.text,
                        );
                      } else {
                        promocao = PromocaoModel(
                          nome: nome.text,
                          url: link.text,
                          valor: valor.text,
                          imagemUrl: '',
                          cupom: cupom.text.isEmpty ? null : cupom.text,
                          descricao:
                              descricao.text.isEmpty ? null : descricao.text,
                        );
                      }

                      final promocoesService = ref.read(promoServiceProvider);

                      if (pickedFile.value == null) {
                        promocoesService
                            .update(promocao)
                            .whenComplete(() => context.pop());
                        return;
                      }
                      final imageData = pickedFile.value!.readAsBytes();
                      final imageExtension =
                          pickedFile.value!.name.split('.').last;

                      imageData.then((imgData) {
                        if (isEditar.value) {
                          return promocoesService.update(
                            promocao,
                            imageData: imgData,
                            imageExt: imageExtension,
                          );
                        }
                        return promocoesService.add(
                          promocao,
                          imageData: imgData,
                          imageExtension: imageExtension,
                        );
                      }).whenComplete(() => context.pop());
                    }
                  },
                ),
              ],
      ),
      body: Form(
        key: key.value,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: [
                const Text('Nome do produto:'),
                TextFormField(
                  controller: nome,
                  validator: _emptyValidator,
                ),
                const SizedBox(height: 8),
                const Text('Link:'),
                TextFormField(
                  controller: link,
                  keyboardType: TextInputType.url,
                  validator: _emptyValidator,
                ),
                const SizedBox(height: 8),
                const Text('Imagem:'),
                const SizedBox(height: 8),
                if (pickedFile.value != null)
                  kIsWeb
                      ? Image.network(pickedFile.value!.path)
                      : Image.file(File(pickedFile.value!.path)),
                if (promocaoToEdit.value?.imagemUrl != null &&
                    pickedFile.value == null)
                  Image.network(promocaoToEdit.value!.imagemUrl),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment:
                      (isEditar.value && pickedFile.value != null)
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.center,
                  children: [
                    if (isEditar.value && pickedFile.value != null)
                      ElevatedButton(
                          onPressed: () => pickedFile.value = null,
                          child: const Text('Desfazer alteração')),
                    ElevatedButton(
                        onPressed: () async {
                          pickedFile.value = await picker.value.pickImage(
                              source: ImageSource.gallery, imageQuality: 50);
                        },
                        child: isEditar.value
                            ? const Text('Alterar Imagem')
                            : const Text('Selecionar Imagem.')),
                  ],
                ),
                if (mostrarErroImagemObrigatoria.value)
                  const Text(
                    'Por favor, selecione uma imagem para o produto.',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                const SizedBox(height: 8),
                const Text('Cupom de promoção:'),
                TextFormField(
                  controller: cupom,
                ),
                const SizedBox(height: 8),
                const Text('Valor:'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: valor,
                  inputFormatters: [
                    MoneyHelper.inputFormatter,
                  ],
                  validator: _emptyValidator,
                ),
                const SizedBox(height: 8),
                const Text('Descrição:'),
                TextFormField(
                  controller: descricao,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
