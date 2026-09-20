class ProfileUsecase {
  static List<Map<String, String>> parseTitleandDescription(String raw) {
    if (raw.trim().isEmpty) return [];

    // Split into sections on blank lines (\r\n\r\n or \n\n)
    final sections = raw.split(RegExp(r'\r?\n\r?\n'));

    final result = <Map<String, String>>[];

    for (final section in sections) {
      final trimmed = section.trim();
      if (trimmed.isEmpty) continue;

      // The first line is the title; the rest is the body
      final newlineIndex = trimmed.indexOf(RegExp(r'\r?\n'));
      if (newlineIndex == -1) {
        // No newline found – treat the whole block as a title with no body
        result.add({'title': trimmed, 'content': ''});
      } else {
        final title = trimmed.substring(0, newlineIndex).trim();
        final content = trimmed.substring(newlineIndex).trim();
        result.add({'title': title, 'content': content});
      }
    }

    return result;
  }
}
