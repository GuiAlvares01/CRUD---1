// Importa o arquivo 'container_all.dart', que contém um layout reutilizável para a interface.
import 'package:crud_teste1/container_all.dart';
// Importa o arquivo 'field_form.dart', que define o campo de formulário reutilizável.
import 'package:crud_teste1/field_form.dart';
// Importa os pacotes do Flutter necessários para a construção da interface.
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

// Importa os arquivos 'user.dart' e 'user_provider.dart' para acessar a classe User e gerenciar o estado.
import 'user.dart';
import 'user_provider.dart';

// Define a classe UserView como um StatelessWidget, pois não precisa de estado interno.
class UserView extends StatelessWidget {
  UserView({super.key});

  // Define o título da tela.
  String title = "Visualizar usuário";

  // Controladores para os campos de nome, e-mail e senha.
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerLogin = TextEditingController();
  TextEditingController controllerPerfil = TextEditingController();
  TextEditingController controllerEmpresa = TextEditingController();
  TextEditingController controllerSistema = TextEditingController();
  TextEditingController controllerExpira = TextEditingController();
  
  //get controllerLogin => null;

  @override
  Widget build(BuildContext context) {

    // Obtém a instância do UserProvider para acessar os dados do usuário selecionado.
    UserProvider userProvider = UserProvider.of(context) as UserProvider;

    int? index;

    // Se houver um usuário selecionado, preenche os campos com os dados dele.
    if (userProvider.indexUser != null) {
      index = userProvider.indexUser;
      controllerName.text = userProvider.userSelected!.name;
      controllerEmail.text = userProvider.userSelected!.email;
      controllerLogin.text = userProvider.userSelected!.login;
      controllerPerfil.text = userProvider.userSelected!.perfil;
      controllerEmpresa.text = userProvider.userSelected!.empresa;
      controllerSistema.text = userProvider.userSelected!.sistema;
      controllerExpira.text = userProvider.userSelected!.expira;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0), // Ajuste o valor conforme necessário
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            title: Text(this.title),
            backgroundColor: const Color.fromARGB(255, 27, 27, 27),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: ContainerAll(
        child: Center(
          child: Column(
            children: [
              // Campos de exibição de nome, e-mail e senha, desativados para edição.
              FieldForm(
                label: 'Login', 
                //isPassword: false, 
                controller: controllerLogin,
                isForm: false,
                isEmail: false,
              ),
              FieldForm(
                label: 'Nome', 
                //isPassword: false, 
                controller: controllerName,
                isForm: false,
                isEmail: false,
              ),
              FieldForm(
                label: 'Email', 
                //isPassword: false, 
                controller: controllerEmail,
                isForm: false,
                isEmail: false,
              ),
               FieldForm(
                label: 'Perfil', 
                //isPassword: false, 
                controller: controllerPerfil,
                isForm: false,
                isEmail: false,
              ),
              FieldForm(
                label: 'Empresa', 
                //isPassword: false, 
                controller: controllerEmpresa,
                isForm: false,
                isEmail: false,
              ),
              FieldForm(
                label: 'Sistema', 
                //isPassword: false, 
                controller: controllerSistema,
                isForm: false,
                isEmail: false,
              ),
              FieldForm(
                label: 'Expiração da Senha', 
                //isPassword: false, 
                controller: controllerExpira,
                isForm: false,
                isEmail: false,
              ),
              // Exibindo o checkbox como um item de visualização
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text('Sistêmico'),
                value: userProvider.userSelected?.isChecked ?? false, // Apenas exibe o valor
                onChanged: null, // Desabilita a interação (não permite mudar)
              ),
              // Botão para editar o usuário, redireciona para a tela de criação.
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/create");
                    },
                    child: Text('Editar'), 
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 27, 27, 27)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                  ),
                )
              ),
              // Botão para excluir o usuário, remove da lista e redireciona para a tela de criação.
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextButton(
                    onPressed: () {
                      userProvider.indexUser = null;
                      userProvider.users.removeAt(index!);
                      Navigator.popAndPushNamed(context, "/create");
                    },
                    child: Text('Deletar'), 
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}