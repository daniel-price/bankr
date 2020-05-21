import 'package:bankr/auth/access_token_store.dart';
import 'package:bankr/data/data_downloader.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/repository/i_dao.dart';

class AccountsScreenController {
  final IDao<Account> accountDao;
  final AccessTokenStore accessTokenStore;
  final DataDownloader dataHandler;

  AccountsScreenController(this.accountDao, this.accessTokenStore, this.dataHandler);

  Future<List<Account>> getAllAccounts() {
    return accountDao.getAll();
  }

  Future<bool> addAccessToken() async {
    var keyAccessToken = await accessTokenStore.addAccessToken();
    if (keyAccessToken == null) {
      return false;
    }
    return dataHandler.downloadData(keyAccessToken);
  }
}
