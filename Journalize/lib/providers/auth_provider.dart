import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthStateProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isSignedUp = true;
  bool _hasError = false;

  String? _errorCode;
  //instances
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _currentUser;
  late final String? _userEmail;
  late final String? _userPassword;

  //usercredentials
  String? _email;
  String? _name;
  String? _uid;

  //Getters here!
  bool get signedState => _isSignedUp;
  bool get hasError => _hasError;
  bool get isloggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  String? get errorCode => _errorCode;
  String? get userEmail => _userEmail;
  String? get userPassword => _userPassword;
  String? get email => _email;
  String? get name => _name;
  String? get uid => _uid;

  AuthStateProvider() {
    // checkAuthState();
  }

  Future<void> checkAuthState() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _currentUser = user;
        _email = _currentUser!.email;
        _name = _currentUser!.displayName;
        _uid = _currentUser!.uid;
      }
      _isLoggedIn = user != null;
    } catch (e) {
      _isLoggedIn = false;
      throw ('Error checking authentication state: $e');
    }

    notifyListeners();
  }

  Future setAuthState(user) async {
    _isLoggedIn = true;
    _currentUser = user;
    _email = _currentUser!.email;
    _name = _currentUser!.displayName;
    _uid = _currentUser!.uid;
    notifyListeners();
  }

  // void toggleAuthState(User? user) {
  //   _currentUser = user;
  //   _isLoggedIn = user != null;
  //   notifyListeners();
  // }

  void toggleSigned() {
    _isSignedUp = !_isSignedUp;
    notifyListeners();
  }

  Future<void> signUp(userEmail, userPassword, userName) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      await userCredential.user?.updateDisplayName(userName);
      await userCredential.user?.reload();
      _currentUser = FirebaseAuth.instance.currentUser;

      _email = _currentUser!.email;
      _name = _currentUser?.displayName;
      _uid = _currentUser!.uid;
      setAuthState(_currentUser);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          _hasError = true;
          _errorCode = e.message;
          break;
        case "account-exists-with-different-credentials":
          _errorCode = "Account already Exists";
          _hasError = true;
          notifyListeners();
          break;
        case "null":
          _hasError = true;
          _errorCode = "unexpected Error please try again later";
          notifyListeners();
          break;
        default:
          _errorCode = e.message;
          _hasError = true;
          notifyListeners();
          break;
      }
    }
  }

  Future<void> signInWithEmailAndPassword(userEmail, userPassword) async {
    try {
      _currentUser = FirebaseAuth.instance.currentUser;
      _email = _currentUser!.email;
      _name = _currentUser!.displayName;
      _uid = _currentUser!.uid;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          _hasError = true;
          _errorCode = e.message;
          notifyListeners();
          break;
        case "INVALID_LOGIN_CREDENTIALS":
          _hasError = true;
          _errorCode = "invalid credentials!";
          notifyListeners();
          break;
        case "user-not-found":
          _hasError = true;
          _errorCode = e.code;
          notifyListeners();
          break;
        case "account-exists-with-different-credentials":
          _errorCode = "Account already Exists";
          _hasError = true;
          notifyListeners();
          break;
        case "null":
          _hasError = true;
          _errorCode = "unexpected Error please try again later";
          notifyListeners();
          break;
        default:
          _errorCode = e.message;
          _hasError = true;
          notifyListeners();
          break;
      }
    }
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('úsers').doc(_uid).get();
    if (snap.exists) {
      return true;
    }
    return false;
  }

  Future getUserDataFromFireStore() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot["uid"],
              _name = snapshot["name"],
              _email = snapshot["email"],
            });
  }

  Future saveDataToFireStore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
    });
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();

      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
