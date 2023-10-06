import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthService with ChangeNotifier {
  bool _autenticando = false;
  String? _token;

  bool get autenticando => _autenticando;
  String? get token => _token;

  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  Future<String?> login(String username, String password) async {
    try {
      autenticando = true;

      final HttpLink httpLink = HttpLink(
        "http://127.0.0.1:8000/graphql/",
      );

      final GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );

      final MutationOptions options = MutationOptions(
        document: gql('''
          mutation TokenAuth(\$username: String!, \$password: String!) {
            tokenAuth(username: \$username, password: \$password) {
              token
            }
          }
        '''),
        variables: <String, dynamic>{
          'username': username,
          'password': password,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        // Manejar errores aquí
        print(result.exception.toString());
        return null;
      }

      _token = result.data?['tokenAuth']['token'];
      autenticando = false;
      return _token;
    } catch (error) {
      print(error.toString());
      autenticando = false;
      return null;
    }
  }
}

class SignUpService with ChangeNotifier {
  Future<List<Map<String, dynamic>>> getUsers() async {
    final HttpLink httpLink = HttpLink(
      "http://127.0.0.1:8000/graphql/",
    );

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    final QueryOptions options = QueryOptions(
      document: gql('''
      query {
        users {
          username
          email
        }
      }
    '''),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception('Failed to load users');
    }

    List<Map<String, dynamic>> users =
        List<Map<String, dynamic>>.from(result.data?['users'] ?? []);

    return users;
  }

  Future<Map<String, Object>> createUser(
      String name, String password, String email) async {
    final HttpLink httpLink = HttpLink(
      "http://127.0.0.1:8000/graphql/",
    );

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation CreateUser(\$username: String!, \$password: String!, \$email: String!) {
        createUser(username: \$username, password: \$password, email: \$email) {
          user {
            username
            email
          }
        }
      }
    '''),
      variables: <String, dynamic>{
        'username': name,
        'password': password,
        'email': email,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      return {"success": false, "message": 'Failed to create user'};
    }

    bool userCreated = result.data?['createUser']['user'] != null;
    if (userCreated) {
      return {"success": true, "message": 'User created successfully'};
    } else {
      return {"success": false, "message": 'Failed to create user'};
    }
  }

  Future<Map<String, dynamic>?> getMe(String token) async {
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    final HttpLink httpLink = HttpLink(
      "http://127.0.0.1:8000/graphql/",
    );

    final Link link = authLink.concat(httpLink);

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );

    final QueryOptions options = QueryOptions(
      document: gql('''
      query {
        me {
          username
          email
        }
      }
    '''),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception('Failed to load current user');
    }

    return result.data?['me'];
  }
}
