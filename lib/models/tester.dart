class Tester {
  String name;
  String email;
  String phone;
  String invitationCode;

  Tester({this.name, this.email, this.phone, this.invitationCode});

  factory Tester.fromMap(Map<String, dynamic> map){
    return Tester(
      name: map["name"],
      email: map["email"],
      phone: map["phone"],
      invitationCode: map["invitationCode"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "name" : name,
      "email" : email,
      "phone" : phone,
      "invitationCode" : ""
    };
  }
}