import 'package:api_vania_paml/app/models/user.dart';
import 'package:vania/vania.dart';

class Authcontroller extends Controller {
  Future<Response> login(Request request) async {
    try {
      final email = request.input('email');
      final password = request.input('password');

      if (email == null || password == null) {
        return Response.json({
          'success': false,
          'message': 'Masukan Email dan Password',
        });
      }

      final user = await User().query().where('email', '=', email).first();

      if (user == null) {
        return Response.json({
          'success': false,
          'message': 'Email dan password salah',
        });
      }

      final isPasswordMatch = Hash().verify(password, user['password']);

      if (!isPasswordMatch) {
        return Response.json({
          'success': false,
          'message': 'Email dan password benar',
        });
      }

      final token = await Auth()
          .login(user)
          .createToken(expiresIn: Duration(hours: 24), withRefreshToken: true);

      return Response.json({
        'success': true,
        'message': 'Anda Berhasil Login',
        'data': {
          'user': user,
          'token': token,
        },
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Gagal Login',
        'error': e.toString(),
      });
    }
  }

  Future<Response> register(Request request) async {
    try{
      var name = request.input('name');
      var email = request.input('email');
      var password = request.input('password');

      if (name == null || email == null || password == null) {
        return Response.json({
          'success' : false,
          'message' : 'silahkan masukan nama, email dan passeord'
        });
      }

      var isEmailExist = await User().query().where('email', '=', email).first();
      if (isEmailExist !=null) {
        return Response.json({
          'success' : false,
          'message' : 'Email sudah ada, Harap gunakan email lain'
        });
      }

      final passwordHashed = Hash().make(password);
      var user = await User().query().create({
        'name' : name,
        'email' : email,
        'password' : passwordHashed,
        'created_at' : DateTime.now().toIso8601String(),
        'updated_at' : DateTime.now().toIso8601String(),
      });
      return Response.json({
        'success' : true,
        'message' : 'Berhasil Register',
        'data' : user
      });
    } catch (e) {
      return Response.json({
        'success' : false,
        'message' : 'Gagal Register',
        'error' : e.toString()
      });
    }
  }

  Future<Response> logout(Request request) async {
    try {
      final token = request.header('Authorization');
      if (token == null) {
        return Response.json({
          'success' : false,
          'message' : 'membutuhkan token',
        });
      }

      final isValidToken = await Auth().check(token);
      if (!isValidToken) {
        return Response.json({
          'success' : false,
          'message' : 'token valid',
        });
      }

      await Auth().deleteTokens();
      return Response.json({
        'success' : true,
        'message' : 'Berhasil Logout',
      });
    }catch (e) {
      return Response.json({
        'success' : false,
        'message' : 'Telah logout',
        'error' : e.toString()
      });
    }
  }
}

final Authcontroller authcontroller = Authcontroller();
