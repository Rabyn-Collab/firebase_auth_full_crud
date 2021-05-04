class Users{
  String email;
  String userId;
  Users({this.email, this.userId});

  factory Users.fromJson(Map<String, dynamic> json){
    return Users(
      email: json['email'],
      userId: json['userId']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      email: 'email',
      userId: 'userId',
    };
  }


}