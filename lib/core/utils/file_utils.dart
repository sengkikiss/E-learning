class FileUtils {
  FileUtils._();

  static const int maxFileSizeInBytes = 10 * 1024 * 1024; // 10 MB

  static const List<String> allowedDocumentExtensions = [
    'pdf',
    'doc',
    'docx',
    'zip',
    'rar',
    'txt',
  ];

  static bool isAllowedExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return allowedDocumentExtensions.contains(extension);
  }

  static bool isFileSizeValid(int sizeInBytes) {
    return sizeInBytes <= maxFileSizeInBytes;
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
