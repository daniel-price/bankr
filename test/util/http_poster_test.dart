import 'package:bankr/util/http_poster.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

void main ()
{
  final client = MockClient();
  var httpPoster = HttpPoster(client);

  group('doPostAndGetJsonResponse', () {
    test('returns a Post if the http call completes successfully', () async {
      when(client.post('https://jsonplaceholder.typicode.com/posts/1',
          body: new Map<String, dynamic>()))
          .thenAnswer((_) async => Response('{"title": "Test"}', 200));

      expect(
          await httpPoster.doPostAndGetJsonResponse(
              'https://jsonplaceholder.typicode.com/posts/1',
              Map<String, dynamic>()),
          const TypeMatcher<Map>());
    });

    test('throws an exception if the http call completes with an error', () {
      when(client.post('https://jsonplaceholder.typicode.com/posts/1',
          body: new Map<String, dynamic>()))
          .thenAnswer((_) async => Response('Not Found', 404));

      expect(
          httpPoster.doPostAndGetJsonResponse(
              'https://jsonplaceholder.typicode.com/posts/1',
              new Map<String, dynamic>()),
          throwsException);
    });
  });
}
