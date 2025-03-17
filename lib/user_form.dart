import 'package:crud_teste1/container_all.dart';
import 'package:crud_teste1/field_form.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'user_provider.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  String? selectedPerfil;
  String? selectedEmpresa;
  String? selectedSistema;

  String title = "Criar usuário";

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerLogin = TextEditingController();
  TextEditingController controllerPerfil = TextEditingController();
  TextEditingController controllerEmpresa = TextEditingController();
  TextEditingController controllerSistema = TextEditingController();
  TextEditingController controllerExpira = TextEditingController();

  bool _isChecked = false;

  GlobalKey<FormState> _key = GlobalKey();

  Future<void> save() async {
    final isValidate = _key.currentState?.validate();

    controllerPerfil.text = selectedPerfil ?? '';
    controllerEmpresa.text = selectedEmpresa ?? '';
    controllerSistema.text = selectedSistema ?? '';

    if (isValidate == false) {
      return;
    }

    try {
      final date = DateFormat('dd/MM/yyyy').parseStrict(controllerExpira.text);
      final today = DateTime.now();

      if (date.isBefore(DateTime(today.year, today.month, today.day))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('A data de expiração não pode ser no passado')),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Digite uma data válida no formato dd/MM/yyyy')),
      );
      return;
    }

    _key.currentState?.save();

    User user = User(
      name: controllerName.text,
      email: controllerEmail.text,
      login: controllerLogin.text,
      perfil: controllerPerfil.text,
      empresa: controllerEmpresa.text,
      sistema: controllerSistema.text,
      expira: controllerExpira.text,
      isChecked: _isChecked,
    );

    UserProvider userProvider = UserProvider.of(context) as UserProvider;

    // **Chamada da API para adicionar o usuário**
    

    if (userProvider.indexUser != null) {
      // Se for uma edição, enviamos a atualização para a API
      final result = await ApiService.addUser(user);  // Isso poderia ser uma atualização no caso de edição

      if (result != null) {
        userProvider.users[userProvider.indexUser!] = user;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário atualizado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar usuário.')),
        );
      }
    } else {
        // Se for um novo cadastro
        final result = await ApiService.addUser(user);
        if (result != null) {
          userProvider.users.add(user);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuário cadastrado com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao cadastrar usuário.')),
          );
        }
      }
      Navigator.popAndPushNamed(context, "/list");
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = UserProvider.of(context) as UserProvider;
    int? index;

    if (userProvider.indexUser != null) {
      index = userProvider.indexUser;

      controllerName.text = userProvider.userSelected!.name;
      controllerEmail.text = userProvider.userSelected!.email;
      controllerLogin.text = userProvider.userSelected!.login;
      controllerPerfil.text = userProvider.userSelected!.perfil;
      controllerEmpresa.text = userProvider.userSelected!.empresa;
      controllerSistema.text = userProvider.userSelected!.sistema;
      controllerExpira.text = userProvider.userSelected!.expira;

      setState(() {
        this.title = "Editar usuário";
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        foregroundColor: Colors.white,
        actions: [
          Container(
            child: TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.black),
              ),
              child: Text('Lista de usuários'),
              onPressed: () {
                Navigator.popAndPushNamed(context, "/list");
              },
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            margin: EdgeInsets.all(8),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: ContainerAll(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      FieldForm(label: 'Login', controller: controllerLogin, isEmail: false),
                      FieldForm(label: 'Nome', controller: controllerName, isEmail: false),
                      FieldForm(label: 'Email', controller: controllerEmail, isEmail: true),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedPerfil,
                              decoration: InputDecoration(labelText: 'Perfil', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                              items: ['Admin', 'Usuário', 'Gerente']
                                  .map((perfil) => DropdownMenuItem<String>(value: perfil, child: Text(perfil)))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedPerfil = newValue;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedEmpresa,
                              decoration: InputDecoration(labelText: 'Empresa', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                              items: ['Skymed', 'Nelógica', 'Gerdau']
                                  .map((empresa) => DropdownMenuItem<String>(value: empresa, child: Text(empresa)))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedEmpresa = newValue;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedSistema,
                              decoration: InputDecoration(labelText: 'Sistema', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                              items: ['Visual Studio Code', 'Anesthesia SX', 'SAP']
                                  .map((sistema) => DropdownMenuItem<String>(value: sistema, child: Text(sistema)))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSistema = newValue;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FieldForm(label: 'Expiração da Senha', controller: controllerExpira, isEmail: false, inputType: TextInputType.datetime, placeholder: 'dd/mm/yyyy'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      CheckboxListTile(
                        title: Text('Sistêmico'),
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextButton(
                            onPressed: save,
                            child: Text('Cadastrar'),
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 27, 27, 27)),
                              foregroundColor: WidgetStateProperty.all(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}