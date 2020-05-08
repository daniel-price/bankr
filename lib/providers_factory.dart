import 'package:bankr/repository/access_token_json_converter.dart';
import 'package:bankr/repository/access_token_repositoryI.dart';
import 'package:bankr/repository/access_token_sembast_repository.dart';
import 'package:bankr/trueLayer/access_token_retriever.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ProvidersFactory {
  static List<SingleChildWidget> providers;

  static Future<List<SingleChildWidget>> initialize ()
  async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, 'demo.db');

    final database = await databaseFactoryIo.openDatabase(dbPath);

    var store = intMapStoreFactory.store('access_token');

    var accessTokenJsonConverter = AccessTokenJsonConverter();

    final AccessTokenRepositoryI accessTokenRepositoryI =
    AccessTokenDatabaseRepository(store, database, accessTokenJsonConverter);
    //final TLAccessTokenRetrieverI tlAccessTokenRetrieverI = TLAccessTokenRetriever(new HttpPoster(new IOClient()))),
    final TLAccessTokenRetrieverI tlAccessTokenRetrieverI =
    TLAccessTokenRetrieverMock();

    providers = [
      Provider<AccessTokenRepositoryI>(
          create: (context)
          => accessTokenRepositoryI),
      Provider<TLAccessTokenRetrieverI>(
          create: (context)
          => tlAccessTokenRetrieverI),
    ];

    return providers;
  }
}
