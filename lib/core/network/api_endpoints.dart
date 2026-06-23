class ApiEndpoints {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Albums (mapped to Projects)
  static const String albums = '/albums';

  // Photos (mapped to Tasks)
  static const String photos = '/photos';
  // Users
  static const String users = '/users';

  static const String currentUser = '/users/1';
  ApiEndpoints._();
  static String albumById(int id) => '/albums/$id';

  static String photoById(int id) => '/photos/$id';
  static String photosByAlbum(int albumId) => '/photos?albumId=$albumId';
  static String userById(int id) => '/users/$id';
}
