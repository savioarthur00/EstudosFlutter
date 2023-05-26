import 'package:sqflite/sqflite.dart';

final String idColumn="idColumn";
final String nameColumn="nameColumn";
final String emailColumn="emailColumn";
final String phoneColumn="phoneColumn";
final String imgColumn="imgColumn";

class Contact_Helper{
  static final Contact_Helper _instance = Contact_Helper.internal();

  Contact_Helper.internal();

}

class Contact{

  int id = 0;
  String name= "";
  String email="";
  String phone="";
  String img="";

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email= map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn:img
    };

    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact (id: $id, name: $name, email: $email , phone: $phone , img: $img )";
  }


}