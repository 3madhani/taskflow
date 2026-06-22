class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Albums (mapped to Projects)
  static const String albums = '/albums';
  static String albumById(int id) => '/albums/$id';

  // Photos (mapped to Tasks)
  static const String photos = '/photos';
  static String photosByAlbum(int albumId) => '/photos?albumId=$albumId';
  static String photoById(int id) => '/photos/$id';

  // Users
  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  static const String currentUser = '/users/1';
}
