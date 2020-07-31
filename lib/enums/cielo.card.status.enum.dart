

class CieloStatusReturn {

    static bool verifyProcess(String status){
      if(status == "4" || status == "6"){
        return true;
      } else{
        return false;
      }
    }
    static String messageReturn(String status){
      switch (status) {
        case "6":
          {
            return "Pagamento autorizado";
          }
          break;
        case "4":
          {
            return "Pagamento autorizado";
          }
          break;
        case "05":
          {
            return "Pagamento não autorizado";
          }
          break;
        case "57":
          {
            return "Cartão Expirado";
          }
          break;
        case "78":
          {
            return "Este cartão está Bloqueado";
          }
          break;
        case "99":
          {
            return "Erro no processamento do pagamento do cartão. Time Out";
          }
          break;
        case "77":
          {
            return "Este cartão está cancelado";
          }
          break;
        case "70":
          {
            return "Problemas com o Cartão de Crédito";
          }
          break;
        default:
          {
            return "Erro no processamento do pagamento do cartão.";
          }
          break;
      }
    }
}