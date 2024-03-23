import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthStateProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isSignedUp = true;
  bool _hasError = false;

  String? _errorCode;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _currentUser;
  late final String? _userEmail;
  late final String? _userPassword;

  String? _email;
  String? _name;
  String? _uid;

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

  AuthStateProvider({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

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
      handleAuthException(e);
    }
  }

  Future<void> signInWithEmailAndPassword(userEmail, userPassword) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
      _currentUser = userCredential.user;
      _email = _currentUser!.email;
      _name = _currentUser!.displayName;
      _uid = _currentUser!.uid;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      handleAuthException(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        _currentUser = userCredential.user;
        _email = _currentUser!.email;
        _name = _currentUser!.displayName;
        _uid = _currentUser!.uid;
        notifyListeners();
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  Future<void> handleAuthException(FirebaseAuthException e) async {
    String errorMessage = 'An unexpected error occurred. Please try again.';
    switch (e.code) {
      case "invalid-email":
        errorMessage = e.message!;
        break;
      case "INVALID_LOGIN_CREDENTIALS":
        errorMessage = 'Invalid credentials!';
        break;
      case "user-not-found":
        errorMessage = e.code;
        break;
      default:
        errorMessage = e.message!;
        break;
    }
    _errorCode = errorMessage;
    _hasError = true;
    notifyListeners();
  }

  Future<void> getUserDataFromFireStore() async {
    try {
      final DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      _uid = snapshot["uid"];
      _name = snapshot["name"];
      _email = snapshot["email"];
    } catch (e) {
      print('Error fetching user data: $e');
    }
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
