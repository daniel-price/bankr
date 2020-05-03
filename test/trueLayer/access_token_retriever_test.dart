import 'package:bankr/model/access_token.dart';
import 'package:bankr/trueLayer/access_token_retriever.dart';
import 'package:bankr/util/http_poster.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

main() {
  final client = MockClient();
  var httpPoster = HttpPoster(client);
  var tlAccessTokenRetriever = TLAccessTokenRetriever(httpPoster);

  group('retrieve', () {
    test('returns a Post if the http call completes successfully', () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.post(any, body: anyNamed("body"))).thenAnswer((_) async =>
          Response(
              '{"access_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjE0NTk4OUIwNTdDOUMzMzg0MDc4MDBBOEJBNkNCOUZFQjMzRTk1MTAiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJGRm1Kc0ZmSnd6aEFlQUNvdW15NV9yTS1sUkEifQ.eyJuYmYiOjE1ODg0MTA2NDAsImV4cCI6MTU4ODQxNDI0MCwiaXNzIjoiaHR0cHM6Ly9hdXRoLnRydWVsYXllci5jb20iLCJhdWQiOlsiaHR0cHM6Ly9hdXRoLnRydWVsYXllci5jb20vcmVzb3VyY2VzIiwiZGF0YV9hcGkiXSwiY2xpZW50X2lkIjoiZGFuaWVscHJpY2UtMzE1NzMzIiwic3ViIjoiK2tmS2UyMnovOXpJY3gvWi9yR2RYSlMyVWVLdDBCYURVVEJsMGpQMFFsMD0iLCJhdXRoX3RpbWUiOjE1ODg0MTA2MjEsImlkcCI6ImxvY2FsIiwiY29ubmVjdG9yX2lkIjoib2ItbW9uem8iLCJjcmVkZW50aWFsc19rZXkiOiJlMDdmNDRmZjljNzc3MWE2NTRjYjExNmE4YmQ4ZGQ0NjhmMjY0MTEwNjUyNzYzMzNjZDNjMTUzNzVhZmQ1Y2JiIiwicHJpdmFjeV9wb2xpY3kiOiJGZWIyMDE5IiwiY29uc2VudF9pZCI6ImM3YTlkZjRmLTc4MGEtNGRmZi05MWM4LWNkYzY0ODVhZTE3OSIsInByb3ZpZGVyX2FjY2Vzc190b2tlbl9leHBpcnkiOiIyMDIwLTA1LTAzVDE1OjEwOjIwWiIsInByb3ZpZGVyX3JlZnJlc2hfdG9rZW5fZXhwaXJ5IjoiMjAyMC0wNy0zMVQwOToxMDoyMVoiLCJzb2Z0d2FyZV9zdGF0ZW1lbnRfaWQiOiIzYXQ2TFZIbTVWYWlEUmZUb2hpS2dQIiwiYWNjb3VudF9yZXF1ZXN0X2lkIjoib2JhaXNwYWNjb3VudGluZm9ybWF0aW9uY29uc2VudF8wMDAwOXVkRDJoOTFxZXhxd3BxVW1QIiwic2NvcGUiOlsiaW5mbyIsImFjY291bnRzIiwiY2FyZHMiLCJ0cmFuc2FjdGlvbnMiLCJiYWxhbmNlIiwiZGlyZWN0X2RlYml0cyIsInN0YW5kaW5nX29yZGVycyIsIm9mZmxpbmVfYWNjZXNzIl0sImFtciI6WyJwd2QiXX0.4e7fRIu264ILxKO4-SrSZvPH3Zlg-Fg0dMZl6RIvehUBsMZcNSuFHpSN04qm1wlpsSzDW1g06IsVs26sT8zXjvGrrJV4ii8doboJh7cVIHYDq4LByvRm7G58xsCCMD4l7oDzD4ELfMgaPF8c2dJ1780tBlK4629VdJ5xB-W-94zIemqrAuqbz33aT_-P56lYPq9xMLOdy3NqZic0xYURNqtLmAuPlauyOECbkmfOPOyIEGutaBWrAIv0k6yKGX7HiltQAGBEl8s3-GhkpQu3lzn-MBsyasPywMAE5KtCSrc0jmJ-a0OmK9__NVl4dSGsMa81NODdTOXw8jbpc9MX_A","expires_in":3600,"token_type":"Bearer","refresh_token":"WMxSWhA86B7whmd7nl95LmH6QexRAqntJ7jmhwnlCj4","scope":"info accounts balance cards transactions direct_debits standing_orders offline_access"}',
              200));

      expect(await tlAccessTokenRetriever.retrieve('whatever'),
          const TypeMatcher<AccessToken>());
    });

    test('throws an exception if the http call completes with an error',
        () async {
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.post(any, body: anyNamed("body")))
          .thenAnswer((_) async => Response('{"error":"invalid_grant"}', 200));

      expect(await tlAccessTokenRetriever.retrieve('whatever'), null);
    });
  });
}
