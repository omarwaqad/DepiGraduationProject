import 'package:delleni_app/main.dart';
class AuthService {

  Future<bool> register(String firstname, String lastname, String email, String phonenumber, String address, String password) async {
    try {
      final response = await global.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userId = response.user!.id;

        final profileResponse = await global.from('users').insert({
          'id': userId,
          'first_name': firstname,
          'last_name': lastname,
          'email': email,
          'phone_number': phonenumber,
          'address': address,
        });

        if (profileResponse.error != null) {
          throw profileResponse.error!;
        }

        return true; // Registration successful
      } else {
        throw Exception('User registration failed.');
      }
    } catch (e) {
      print('Error during registration: $e');
      return false; // Registration failed
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await global.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await global.auth.signOut();
      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }


}