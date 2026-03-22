class CsRequest {
  final String? problemType;
  final String? location;
  final String? publishType;
  final String header;
  final String statement;
  final String? uploadedFileName;

  const CsRequest({
    this.problemType,
    this.location,
    this.publishType,
    required this.header,
    required this.statement,
    this.uploadedFileName,
  });

  Map<String, dynamic> toJson() {
    return {
      'problem_type': problemType,
      'location': location,
      'publish_type': publishType,
      'header': header,
      'statement': statement,
      'uploaded_file_name': uploadedFileName,
    };
  }
}
