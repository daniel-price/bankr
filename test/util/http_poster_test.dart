import 'package:bankr/util/http_poster.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

main() {
  final client = MockClient();
  var httpPoster = HttpPoster(client);

  group('doPostAndGetJsonResponse', () {
    test('returns a Post if the http call completes successfully', () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.post('https://jsonplaceholder.typicode.com/posts/1',
              body: new Map()))
          .thenAnswer((_) async => Response('{"title": "Test"}', 200));

      expect(
          await httpPoster.doPostAndGetJsonResponse(
              'https://jsonplaceholder.typicode.com/posts/1', new Map()),
          const TypeMatcher<Map>());
    });

    test('throws an exception if the http call completes with an error', () {
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.post('https://jsonplaceholder.typicode.com/posts/1',
              body: new Map()))
          .thenAnswer((_) async => Response('Not Found', 404));

      expect(
          httpPoster.doPostAndGetJsonResponse(
              'https://jsonplaceholder.typicode.com/posts/1', new Map()),
          throwsException);
    });
  });
}
