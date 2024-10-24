import 'package:chat/model/user_model.dart';
import 'package:chat/services/auth_sevices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../model/chat_model.dart';
import '../model/todo_model.dart';

class FirebaseStoreServices {
  FirebaseStoreServices._();

  static final FirebaseStoreServices instance = FirebaseStoreServices._();

  // Initilize
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collectionPath = "Todo";
  String userCollection = "allUsers";

  UserModel? currentUser;

  // add user
  Future<void> addUser({required User user}) async {
    Map<String, dynamic> data = {
      'uid': user.uid,
      "displayName": user.displayName ?? "DEMO NAME",
      "email": user.email ?? "DEMO EMAIL",
      "phoneNumber": user.phoneNumber ?? "NO DATA",
      "photoUrl": user.photoURL ??
          "https://media.istockphoto.com/id/2149530993/photo/digital-human-head-concept-for-ai-metaverse-and-facial-recognition-technology.webp?a=1&b=1&s=612x612&w=0&k=20&c=nyP4c-s5cSZy1nv1K0xn1ynC-Xuc1sY4Y29ZQqcrztA=",
    };
    await firestore.collection(userCollection).doc(user.uid).set(data);
  }

  Future<void> getUser() async {
    DocumentSnapshot snapshot = await firestore
        .collection(userCollection)
        .doc(AuthServices.instance.auth.currentUser!.uid)
        .get();
    currentUser = UserModel.fromMap(snapshot.data() as Map);
  }

  // add data
  Future<void> addTodo({required ToDoModel todoModel}) async {
    // Auto ID
    // await firestore.collection(collectionPath).add(todoModel.toMap);

    // Custom ID
    await firestore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(collectionPath)
        .doc(todoModel.id)
        .set(
          todoModel.toMap,
        );
  }

  Future<List<ToDoModel>> getData() async {
    List<ToDoModel> allTodo = [];

    // get snapshot
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(collectionPath)
        .get();

    // get Docs
    List<QueryDocumentSnapshot> docs = snapshot.docs;

    // parse data
    allTodo = docs
        .map(
          (e) => ToDoModel.fromMap(e.data() as Map),
        )
        .toList();

    return allTodo;
  }

  // data Stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    return firestore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(collectionPath)
        .snapshots();
  }

  // Data update
  Future<void> updateStatus({required ToDoModel todoModel}) async {
    await firestore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(collectionPath)
        .doc(todoModel.id)
        .update(todoModel.toMap);
  }

  // Get all users
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore.collection(userCollection).snapshots();
  }

  // Add friend
  Future<void> addFriend({required UserModel userModel}) async {
    await firestore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection("friends")
        .doc(userModel.uid)
        .set(userModel.toMap)
        .then((value) => Logger().i("Added"))
        .onError(
          (error, stackTree) => Logger().e("Error : ${error.toString()}"),
        );

    await firestore
        .collection(userCollection)
        .doc(userModel.uid)
        .collection("friends")
        .doc(currentUser!.uid)
        .set(currentUser!.toMap);
  }

  // get friends
  Future<List<UserModel>> getFriends() async {
    List<UserModel> friends = [];
    friends = (await firestore
            .collection(userCollection)
            .doc(currentUser!.uid)
            .collection("friends")
            .get())
        .docs
        .map((e) => UserModel.fromMap(e.data()))
        .toList();
    return friends;
  }

  // get friends stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getFriendsStream() {
    return firestore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection("friends")
        .snapshots();
  }

  // get chat stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(
      {required UserModel userModel}) {
    return firestore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection("friends")
        .doc(userModel.uid)
        .collection("chats")
        .snapshots();
  }

  Future<void> sendMap(
      {required ChatModel chat, required UserModel user}) async {
    await firestore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection("friends")
        .doc(user.uid)
        .collection("chats")
        .doc(chat.time.microsecondsSinceEpoch.toString())
        .set(chat.toMap);
  }
}
