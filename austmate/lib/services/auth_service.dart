import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user != null) {
      await supabase.from('students').insert({
        'id': user.id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      });
    }

    return response;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
