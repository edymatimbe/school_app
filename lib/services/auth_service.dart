import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signup({
    required String username,
    required String email,
    required String password,
    String? role,
  }) async {
    FirebaseApp? tempApp;

    try {
      // Inicializar um app Firebase secundário
      tempApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      // Usar o app secundário para autenticação
      final tempAuth = FirebaseAuth.instanceFor(app: tempApp);

      // Criar o usuário no app secundário (sem afetar sessão atual)
      UserCredential userCredential = await tempAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      // Salvar dados no Firestore principal
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'username': username.trim(),
        'email': email.trim(),
        'role': role,
      });

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      // Remover app secundário da memória
      if (tempApp != null) {
        await tempApp.delete();
      }
    }
  }

  Future<String?> signin({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      DocumentSnapshot userDoc =
          await _firestore
              .collection("users")
              .doc(userCredential.user!.uid)
              .get();
      return userDoc['role'];
    } catch (e) {
      return e.toString();
    }
  }
}
