import 'dart:convert';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/server_constants.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  //Signup Function
  Future<Either<AppFailure, UserModel>> signup({
    required final name,
    required final email,
    required final password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverURL}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right((UserModel.fromMap(resBodyMap)));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  //Login Function
  Future<Either<AppFailure, UserModel>> login({
    required final email,
    required final password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverURL}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(
        (UserModel.fromMap(
          resBodyMap['user'],
        ).copyWith(token: resBodyMap['token'])),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  //get current user
  Future<Either<AppFailure, UserModel>> getCurrentUser({
    required final token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstants.serverURL}/auth/'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(UserModel.fromMap(resBodyMap).copyWith(token: token));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
