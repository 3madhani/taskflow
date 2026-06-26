class TextHelper {
  TextHelper._();

  static String shortId(String id, {int length = 8}) {
    if (id.length <= length) {
      return id;
    }
    return id.substring(0, length);
  }
}
