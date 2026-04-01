import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleAuthService {
  static final _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar',
    ],
  );

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyAccessToken = 'google_access_token';
  static const _keyIdToken = 'google_id_token';
  static const _keyConnected = 'google_connected';

   // Signs in with Google and saves everything securely on device.
  static Future<bool> connectGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return false;

      final auth = await account.authentication;
      if (auth.accessToken == null) return false;

      await _storage.write(key: _keyAccessToken, value: auth.accessToken);
      await _storage.write(key: _keyIdToken, value: auth.idToken);
      await _storage.write(key: _keyConnected, value: 'true');

      return true;
    } catch (e) {
      return false;
    }
  }
 
  
  static Future<bool> isConnected() async {
    final value = await _storage.read(key: _keyConnected);
    return value == 'true';
  }

  
  static Future<String?> getAccessToken() async {
    final account = _googleSignIn.currentUser
        ?? await _googleSignIn.signInSilently();

    if (account != null) {
      final auth = await account.authentication;
      if (auth.accessToken != null) {
        await _storage.write(key: _keyAccessToken, value: auth.accessToken);
        return auth.accessToken;
      }
    }

    
    return await _storage.read(key: _keyAccessToken);
  }

  
  static Future<void> disconnect() async {
    await _googleSignIn.signOut();
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyIdToken);
    await _storage.delete(key: _keyConnected);
  }
}