import 'package:velotoulouse/model/user/user.dart';

abstract class AuthRepository {
  Future<AppUser?> signInWithEmail(String email, String password);

  Future<AppUser> registerWithEmail(String displayName,String email, String password);

  Future<void> signOut();

  Stream<AppUser?> watchAuthState();

  AppUser? get currentUser;
}
