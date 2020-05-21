import 'package:bankr/util/http.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

void main() {
  final mockClient = MockClient();
  var httpPoster = Http(mockClient);

  group('doPostAndGetJsonResponse', () {
	  test('returns a map if the http call completes successfully', ()
	  async {
		  when(mockClient.post('https://jsonplaceholder.typicode.com/posts/1', body: new Map<String, dynamic>())).thenAnswer(
					  (_)
			  async => Response('{"title": "Test"}', 200),
		  );

		  expect(
			  await httpPoster.doPostAndGetJsonResponse('https://jsonplaceholder.typicode.com/posts/1', Map<String, dynamic>()),
			  const TypeMatcher<Map>(),
		  );
	  });

	  test('returns null if the http call completes with an error', ()
	  async {
		  when(mockClient.post('https://jsonplaceholder.typicode.com/posts/1', body: new Map<String, dynamic>())).thenAnswer((_)
		  async => Response('Not Found', 404));

		  expect(
			  await httpPoster.doPostAndGetJsonResponse('https://jsonplaceholder.typicode.com/posts/1', new Map<String, dynamic>()),
			  null,
		  );
	  });
  });

  group('doGetAndGetJsonResponse', ()
  {
	  test('returns a map if the http call completes successfully', ()
	  async {
		  when(mockClient.get('https://jsonplaceholder.typicode.com/posts/1', headers: anyNamed("headers"))).thenAnswer((_)
		  async => Response('{"title": "Test"}', 200));

		  expect(
			  await httpPoster.doGetAndGetJsonResponse('https://jsonplaceholder.typicode.com/posts/1', Map<String, String>()),
			  const TypeMatcher<Map>(),
		  );
	  });

	  test('returns null if the http call completes with an error', ()
	  async {
		  when(mockClient.get('https://jsonplaceholder.typicode.com/posts/1', headers: anyNamed("headers"))).thenAnswer((_)
		  async => Response('Not Found', 404));

		  expect(
			  await httpPoster.doGetAndGetJsonResponse('https://jsonplaceholder.typicode.com/posts/1', new Map<String, String>()),
			  null,
		  );
    });
  });
}
