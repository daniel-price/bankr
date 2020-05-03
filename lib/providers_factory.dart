import 'package:bankr/repository/access_token_memory_repository.dart';
import 'package:bankr/repository/access_token_repositoryI.dart';
import 'package:bankr/trueLayer/access_token_retriever.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProvidersFactory {
  static List<SingleChildWidget> initialize() {
    return [
      ChangeNotifierProvider<AccessTokenRepositoryI>(
          create: (context) => AccessTokenMemoryRepository()),
      Provider<TLAccessTokenRetrieverI>(
          create: (context) =>
              //TLAccessTokenRetriever(new HttpPoster(new IOClient()))),
              TLAccessTokenRetrieverMock()),
    ];
  }
}
