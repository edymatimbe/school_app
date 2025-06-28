import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider =
    FutureProvider<DocumentSnapshot<Map<String, dynamic>>>((ref) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Usuário não autenticado");
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    });
