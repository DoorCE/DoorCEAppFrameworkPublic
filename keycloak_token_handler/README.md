# doorce_keycloak_token_handler

Token handler for refreshing Keycloak tokens.

## Usage

```dart
final handler = KeycloakTokenService(
  keycloakUrl: const String.fromEnvironment("KEYCLOAK_PATH"),
  realm: const String.fromEnvironment("KEYCLOAK_REALM"),
  clientId: const String.fromEnvironment("KEYCLOAK_CLIENT")
  clientSecret: const String.fromEnvironment("KEYCLOAK_CLIENT_SECRET")
);

await handler.setRefreshToken(oldRefreshToken);
```