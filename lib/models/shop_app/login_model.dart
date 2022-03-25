class ShopLoginModel {
  bool status ;
  String message ;
 UserData data ;
  ShopLoginModel.fromJson(Map<String, dynamic> json ){
    status = json['status'] ;
    message = json['message'] ;
    data = json['data'] != null ? UserData.fromJson(json['data']) : null ;

  }
}

class UserData {
  int id ;
  String email ;
  String phone ;
  String name ;
  String image ;
  String token ;
  int points ;
  int credit ;
//   UserData({
//     this.id,
//     this.email,
//     this.name,
//     this.phone,
//     this.image,
//     this.token,
//     this.points,
//     this.credit,
// });
  // named_Constructor
UserData.fromJson(Map<String, dynamic> json ){
  id = json['id'] ;
  name = json['name'] ;
  email = json['email'] ;
  phone= json['phone'] ;
  image = json['image'] ;
  token = json['token'] ;
  points = json['points'] ;
  credit = json['credit'] ;
}
}