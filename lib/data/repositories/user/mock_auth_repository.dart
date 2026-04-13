import 'package:velotoulouse/data/repositories/user/user_repository.dart';
import 'package:velotoulouse/model/user/user.dart';

class MockAuthRepository implements AuthRepository {
  AppUser? _currentUser;

  final AppUser _mockUser = AppUser(
    id: 'user_1',
    email: 'user@example.com',
    displayName: 'Mock User',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Future<AppUser?> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = _mockUser;
    return _currentUser;
  }

  @override
  Future<AppUser> registerWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = AppUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@')[0],
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = null;
  }

  @override
  Stream<AppUser?> watchAuthState() async* {
    await Future.delayed(const Duration(milliseconds: 600));
    yield _mockUser;
  }
}
