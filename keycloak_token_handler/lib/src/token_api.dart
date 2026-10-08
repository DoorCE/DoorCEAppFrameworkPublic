import 'dart:convert';

import 'package:doorce_keycloak_token_handler/doorce_keycloak_token_handler.dart';
import 'package:logging/logging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

abstract interface class TokenAPI {
  Future<void> setRefreshToken(String tokenFromMainApp);
  Future<void> refresh();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<bool> isAuthenticated();
  Future<bool> isNotExpired();
}

class KeycloakTokenService implements TokenAPI {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final String? keycloakUrl;
  final String? realm;
  final String? clientId;
  final String? clientSecret;

  KeycloakTokenService({this.keycloakUrl, this.realm, this.clientId, this.clientSecret}); 

  /// Keycloak server settings
  /// - keycloakUrl: Base endpoint of the Keycloak server
  /// - realm: Tenant realm
  /// - clientId: OAuth2 client identifier

  @override
  Future<void> setRefreshToken(String tokenFromMainApp) async {
    try {
      Logger.root.fine("[TokenAPI setRefreshToken] setting refresh token...");

      final response = await http.post(
        Uri.parse('$keycloakUrl/realms/$realm/protocol/openid-connect/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': tokenFromMainApp,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final refreshToken = data["refresh_token"];

        if (null == refreshToken || (refreshToken as String).isEmpty) {
          Logger.root.severe("[TokenAPI setRefreshToken] Keycloak returned null/empty token\nFull token response: ${response.body}");
          throw AuthenticationException("No refresh token found");
        }

        Logger.root.fine("[TokenAPI setRefreshToken] received refresh token: $refreshToken");
        await _secureStorage.write(key: 'access_token', value: data['access_token']);
        await _secureStorage.write(key: 'refresh_token', value: data['refresh_token']);
        Logger.root.fine("[TokenAPI setRefreshToken] token set successfully");
        return;
      } else {
        Logger.root.fine('[TokenAPI setRefreshToken] token refresh failed: ${response.body}');
        await _secureStorage.delete(key: 'access_token');
        await _secureStorage.delete(key: 'refresh_token');
        throw AuthenticationException('Token set failed');
      }
    } catch (e) {
      Logger.root.severe('[TokenAPI setRefreshToken] token refresh error: $e');
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      throw AuthenticationException('Token set error');
    }
  }

  @override
  Future<void> refresh() async { 
    try {
      Logger.root.fine("[TokenAPI refresh] refreshing access token...");

      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null || refreshToken.isEmpty) {
        Logger.root.fine("[TokenAPI refresh] no refresh token found, re-authentication required");
        throw AuthenticationException('No refresh token found');
      } else {
        Logger.root.fine("[TokenAPI refresh] found refresh token: $refreshToken");
      }

      final response = await http.post(
        Uri.parse('$keycloakUrl/realms/$realm/protocol/openid-connect/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newRefreshToken = data["refresh_token"];

        if (null == newRefreshToken || (newRefreshToken as String).isEmpty) {
          Logger.root.severe("[TokenAPI refresh] Keycloak returned null/empty token\nFull token response: ${response.body}");
          throw AuthenticationException("No refresh token found");
        }

        Logger.root.fine("[TokenAPI refresh] received refresh token: $newRefreshToken");
        await _secureStorage.write(key: 'access_token', value: data['access_token']);
        await _secureStorage.write(key: 'refresh_token', value: data['refresh_token']);
        Logger.root.fine("[TokenAPI refresh] token refreshed successfully");
        return;
      } else {
        Logger.root.fine('[TokenAPI refresh] token refresh failed: ${response.body}');
        await _secureStorage.delete(key: 'access_token');
        await _secureStorage.delete(key: 'refresh_token');
        throw AuthenticationException('Token refresh failed');
      }
    } catch (e) {
      Logger.root.severe('[TokenAPI refresh] token refresh error: $e');
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      throw AuthenticationException('Token refresh error');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: 'access_token');
    return token != null;
  }

  @override
  Future<bool> isNotExpired() async {
    final token = await _secureStorage.read(key: 'access_token');
    if (token == null) return false;

    // Check token expiration
    final payload;
    try {
      payload = JwtDecoder.decode(token);
    } catch (e) {
      Logger.root.severe('[TokenAPI isNotExpired] Failed to decode JWT payload: $e');
      return false;
    }
    if (payload.isEmpty) return false;
    final exp = payload['exp'];
    if (exp == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return exp > now;
  }
}