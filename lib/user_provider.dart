// Importa o arquivo 'user.dart', que contém a definição da classe User.
import 'package:crud_teste1/user.dart';
// Importa o pacote do Flutter para manipulação de widgets.
import 'package:flutter/cupertino.dart';

// Define a classe UserProvider como um InheritedWidget, permitindo o compartilhamento de estado na árvore de widgets.
class UserProvider extends InheritedWidget {
  // Widget filho que será envolvido pelo UserProvider.
  final Widget child;
  // Lista de usuários armazenada na aplicação.
  List<User> users = [];
  // Usuário atualmente selecionado (pode ser nulo).
  User? userSelected;
  // Índice do usuário selecionado na lista (pode ser nulo).
  int? indexUser;

  // Construtor da classe, exigindo um widget filho como parâmetro obrigatório.
  UserProvider({
    required this.child
  }) : super(child: child);

  // Método estático para obter a instância do UserProvider na árvore de widgets.
  static UserProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>();
  }

  // Método para alterar o estado do checkbox do usuário selecionado
  // Método para alterar o estado do checkbox do usuário selecionado
  void toggleUserCheckbox() {
    if (userSelected != null) {
      userSelected!.isChecked = !userSelected!.isChecked;
    }
  }

  // Atualiza a lista de usuários
  void updateUser(User user, int index) {
    users[index] = user;
  }

  // Define quando o widget deve ser reconstruído.
  @override
  bool updateShouldNotify(UserProvider widget) {
    return true; // Sempre notifica as mudanças para reconstrução dos widgets dependentes.
  }
}

//Esse código define um provedor de estado global para gerenciar a lista de usuários, permitindo que diferentes partes da aplicação acessem e modifiquem esses dados facilmente. 🚀