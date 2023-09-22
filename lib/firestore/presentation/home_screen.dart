import 'package:firebase_alura/authentication/component/show_confirmation_dialog.dart';
import 'package:firebase_alura/authentication/services/auth_service.dart';
import 'package:firebase_alura/firestore/services/listin_service.dart';
import 'package:firebase_alura/firestore_produtos/presentation/produto_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/listin.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Listin> listListins = [];
  final ListinServicie _listinServicie = ListinServicie();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
              ),
              accountName: Text(widget.user.displayName ?? ''),
              accountEmail: Text('${widget.user.email}'),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Excluir Conta'),
              onTap: () {
                showConfirmationPasswordDialog(email: '', context: context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                AuthService().logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Listin - Feira Colaborativa",
          style: TextStyle(),
        ),
        // backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (listListins.isEmpty)
          ? const Center(
              child: Text(
                "Nenhuma lista ainda.\nVamos criar a primeira?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: ListView(
                children: List.generate(
                  listListins.length,
                  (index) {
                    Listin model = listListins[index];
                    return Dismissible(
                      key: ValueKey<Listin>(model),
                      onDismissed: (direction) {
                        remove(model);
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: const EdgeInsets.only(right: 15),
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.list_alt_rounded),
                        title: Text(model.name),
                        // subtitle: Text(model.id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdutoScreen(
                                listin: model,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          showFormModal(model: model);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  showFormModal({Listin? model}) {
    // Labels à serem mostradas no Modal
    String title = "Adicionar Listin";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    // Controlador do campo que receberá o nome do Listin
    TextEditingController nameController = TextEditingController();
    if (model != null) {
      title = 'Editando ${model.name}';
      nameController.text = model.name;
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      context: context,

      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),

          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(label: Text("Nome do Listin")),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Listin listin = Listin(
                          id: model != null ? model.id : const Uuid().v1(),
                          name: nameController.text,
                        );

                        _listinServicie.newListin(listin: listin);
                        refresh();

                        Navigator.pop(context);
                      },
                      child: Text(confirmationButton)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  refresh() async {
    List<Listin> temp = await _listinServicie.refresh();
    setState(() {
      listListins = temp;
    });
  }

  void remove(Listin model) {
    _listinServicie.removeListin(model: model);
    refresh();
  }
}
