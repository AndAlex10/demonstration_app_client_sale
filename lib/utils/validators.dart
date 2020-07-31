

class FieldValidator{

  static String validateEmail(String email){
    if(email.isEmpty || !email.contains("@")) return "E-mail inválido!";
  }

  static String validatePassword(String pass){
    if(pass.isEmpty || pass.length < 6) return "Senha inválida!";
  }

  static String validateName(String name){
    if(name.isEmpty) return "Nome Inválido!";
  }

  static String validatePhone(String phone){
    if(phone.isEmpty) return "Telefone obrigatório!";
  }

  static String validateReason(String text){
    if(text.isEmpty) return "Informe o motivo!";
  }

}