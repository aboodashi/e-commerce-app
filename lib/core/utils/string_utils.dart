class StringUtils {
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length > 1) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}
