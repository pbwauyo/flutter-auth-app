class TestInvitationRepo {
  bool verifyInvitationCode(String invitationCode){
    final splitCode = invitationCode.split("-");
    if(splitCode.length != 2){
      return false;
    }else {
      if(double.tryParse(splitCode[0]) == null && double.tryParse(splitCode[1]) == null){
        return false;
      }
    }
    return true;
  }
}