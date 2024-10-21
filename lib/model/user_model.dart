class UserModel {
  var uid;
  var displayName;
  var email;
  var photoUrl;
  var phoneNumber;
  List<UserModel> friends = [];
  UserModel(
      this.uid, this.displayName, this.email, this.phoneNumber, this.photoUrl) {
    load();
  }

  factory UserModel.fromMap(Map data) => UserModel(
        data["uid"],
        data['displayName'],
        data['email'],
        data["phoneNumber"],
        data['photoUrl'],
      );

  Future<void> load()async{
    // if(uid == FireStoreServices.instance.currentUser!.ui){
    //   friends = await FireStoreServices.instance,getFriends();
    // }
  }

  Map<String , dynamic> get toMap=>{
    'uid' :uid,
    'displayName' : displayName ?? "DEMO USER",
    'email' : email ?? "DEMO MAIL",
    'phoneNumber' : phoneNumber ?? "NO DATA",
    "photoUrl" :photoUrl ?? "https://media.istockphoto.com/id/2149530993/photo/digital-human-head-concept-for-ai-metaverse-and-facial-recognition-technology.webp?a=1&b=1&s=612x612&w=0&k=20&c=nyP4c-s5cSZy1nv1K0xn1ynC-Xuc1sY4Y29ZQqcrztA=",
  };

}
