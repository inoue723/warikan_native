import 'package:firebase_auth/firebase_auth.dart';
import 'package:warikan_native/src/models/user.dart' as AppUserModel;
import 'package:warikan_native/src/services/api_path.dart';
import 'package:warikan_native/src/services/firestore_service.dart';

abstract class AuthBase {
  Stream<AppUserModel.User> get onAuthStateChanged;
  AppUserModel.User currentUser();
  Future<AppUserModel.User> signInWithEmailAndPassword(
      {String email, String password});
  Future<AppUserModel.User> createUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirestoreService.instance;

  AppUserModel.User _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return AppUserModel.User(uid: user.uid);
  }

  @override
  Stream<AppUserModel.User> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  AppUserModel.User currentUser() {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<AppUserModel.User> signInWithEmailAndPassword({
    String email,
    String password,
  }) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUserModel.User> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.setData(
      path: APIPath.user(authResult.user.uid),
      data: {},
    );
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
