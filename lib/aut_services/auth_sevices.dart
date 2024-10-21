import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class  AuthServices{
  AuthServices._pc();
  static final AuthServices instance = AuthServices._pc();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> anonymousLogin() async{
    UserCredential credential = await auth.signInAnonymously();
    return credential.user;
  }

  Future<User?> register ({required String email , required String psw}) async{
    User? user ;
    try{
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: psw);
      user = credential.user;
    }catch(error){
      Logger().e("Exception : ${error.toString()}");
    }
    return user;
  }

  Future<User?> signIn({required email, required String psw}) async{
    User? user ;
    try{
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: psw);
      user = credential.user;
    }catch(error){
      Logger().e("Exception : ${error.toString()}");
    }
    return user;
  }

  Future<UserCredential> signInWithGoogle() async{
    // trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // details gather
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // create a credential
    final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken,idToken: googleAuth?.idToken);

    return await auth.signInWithCredential(credential);
  }

  Future<void> logOut() async{
    await auth.signOut();
    await GoogleSignIn().signOut();
  }




}