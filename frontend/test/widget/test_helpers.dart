import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Registers a mock method channel for flutter_secure_storage so that
/// AuthRepository.getToken() and similar calls don't throw
/// MissingPluginException during widget tests.
void setupMockSecureStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    // Return null for reads (no token), success for writes/deletes
    return null;
  });
}

/// A mock HTTP client that immediately returns a 404 for all requests.
/// This prevents tests from hanging on real network calls in singleton services.
class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    print('Debug: MockHttpOverrides.createHttpClient called');
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}
  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {}
  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String realm)? f) {}
  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String realm)? f) {}
  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) {}
  @override
  set findProxy(String Function(Uri url)? f) {}
  @override
  set connectionFactory(Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) {}
  @override
  set keyLog(void Function(String line)? callback) {}
  @override
  void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) => _mockRequest();
  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => _mockRequest();
  @override
  Future<HttpClientRequest> get(String host, int port, String path) => _mockRequest();
  @override
  Future<HttpClientRequest> getUrl(Uri url) => _mockRequest();
  @override
  Future<HttpClientRequest> head(String host, int port, String path) => _mockRequest();
  @override
  Future<HttpClientRequest> headUrl(Uri url) => _mockRequest();
  @override
  Future<HttpClientRequest> patch(String host, int port, String path) => _mockRequest();
  @override
  Future<HttpClientRequest> patchUrl(Uri url) => _mockRequest();
  @override
  Future<HttpClientRequest> post(String host, int port, String path) => _mockRequest();
  @override
  Future<HttpClientRequest> postUrl(Uri url) => _mockRequest();
  @override
  Future<HttpClientRequest> put(String host, int port, String path) => _mockRequest();
  @override
  Future<HttpClientRequest> putUrl(Uri url) => _mockRequest();
  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) => _mockRequest();
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) => _mockRequest();

  Future<HttpClientRequest> _mockRequest() async => _MockHttpClientRequest();
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  bool followRedirects = true;
  @override
  int maxRedirects = 5;
  @override
  bool persistentConnection = true;
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  void add(List<int> data) {}
  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
  @override
  Future<void> addStream(Stream<List<int>> stream) async {}
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
  @override
  void write(Object? obj) {}
  @override
  void writeAll(Iterable objects, [String separator = ""]) {}
  @override
  void writeCharCode(int charCode) {}
  @override
  void writeln([Object? obj = ""]) {}
  @override
  Future<HttpClientResponse> get done async => _MockHttpClientResponse();
  @override
  Future flush() async {}
  @override
  Encoding encoding = utf8;
  @override
  final Uri uri = Uri.parse('http://mock');
  @override
  final String method = 'GET';
  @override
  bool get bufferOutput => true;
  @override
  set bufferOutput(bool value) {}
  @override
  set contentLength(int value) {}
  @override
  int get contentLength => 0;
  @override
  void abort([Object? exception, StackTrace? stackTrace]) {}
  @override
  set cookies(List<Cookie> value) {}
  @override
  List<Cookie> get cookies => [];
  @override
  HttpConnectionInfo? get connectionInfo => null;
}

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  int get statusCode => 404;
  @override
  String get reasonPhrase => 'Not Found';
  @override
  int get contentLength => 0;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override
  final HttpHeaders headers = _MockHttpHeaders();
  @override
  bool get isRedirect => false;
  @override
  List<RedirectInfo> get redirects => [];
  @override
  List<Cookie> get cookies => [];
  @override
  X509Certificate? get certificate => null;
  @override
  HttpConnectionInfo? get connectionInfo => null;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.empty().listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followRedirects]) async => this;
  @override
  Future<Socket> detachSocket() async => throw UnimplementedError();
  @override
  bool get persistentConnection => true;
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  List<String>? operator [](String name) => null;
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void clear() {}
  @override
  void forEach(void Function(String name, List<String> values) f) {}
  @override
  void noFolding(String name) {}
  @override
  void remove(String name, Object value) {}
  @override
  void removeAll(String name) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  String? value(String name) => null;
  @override
  set chunkedTransferEncoding(bool value) {}
  @override
  bool get chunkedTransferEncoding => false;
  @override
  set contentLength(int value) {}
  @override
  int get contentLength => 0;
  @override
  set contentType(ContentType? value) {}
  @override
  ContentType? get contentType => null;
  @override
  set date(DateTime? value) {}
  @override
  DateTime? get date => null;
  @override
  set expires(DateTime? value) {}
  @override
  DateTime? get expires => null;
  @override
  set host(String? value) {}
  @override
  String? get host => null;
  @override
  set ifModifiedSince(DateTime? value) {}
  @override
  DateTime? get ifModifiedSince => null;
  @override
  set port(int? value) {}
  @override
  int? get port => null;
  @override
  bool get persistentConnection => true;
  @override
  set persistentConnection(bool value) {}
}
