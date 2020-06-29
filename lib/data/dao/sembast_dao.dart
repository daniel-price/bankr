import 'package:bankr/data/dao/i_dao.dart';
import 'package:bankr/data/json/i_json_converter.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:sembast/sembast.dart';

//TODO - encrypt data
class SembastDao<E extends IPersist> extends IDao<E> {
	final StoreRef<String, Map<String, dynamic>> _store;
	final Database _db;
	final IJsonConverter<E> _jsonConverter;

	SembastDao(this._store, this._db, this._jsonConverter);

	@override
	void delete(E saveableI) async {
		final finder = Finder(filter: Filter.byKey(saveableI.uuid));
		await _store.delete(
			_db,
			finder: finder,
		);
	}

	@override
	Future<List<E>> getAll() async {
		final finder = Finder();
		return await _getAllForFinder(finder);
	}

	Future<List<E>> _getAllForFinder(Finder finder) async {
		final recordSnapshots = await _store.find(
			_db,
			finder: finder,
		);

		return recordSnapshots.map((snapshot) {
			return _getEntityFromSnapshot(snapshot);
		}).toList();
	}

	E _getEntityFromSnapshot (RecordSnapshot<String, Map<String, dynamic>> snapshot)
	{
		return _jsonConverter.fromMap(snapshot.value);
	}

	@override
	Future<E> get(String uuid) async {
		var filter = Filter.equals('uuid', uuid);
		return await getEntity(filter);
	}

	Future<E> getEntityForFinder (Finder finder)
	async {
		RecordSnapshot<String, Map<String, dynamic>> recordSnapshot = await _store.findFirst(_db, finder: finder);
		if (recordSnapshot == null)
		{
			return null;
		}
		return _getEntityFromSnapshot(recordSnapshot);
	}

	@override
	insert(E saveableI) async {
		var record = _store.record(saveableI.uuid);
		await record.put(_db, _jsonConverter.toMap(saveableI));
	}

	@override
	update(E saveableI) async {
		final finder = Finder(filter: Filter.byKey(saveableI.uuid));
		await _store.update(
			_db,
			_jsonConverter.toMap(saveableI),
			finder: finder,
		);
	}

	@override
	void insertIfNew (E saveableI)
	async {
		if (await isNew(saveableI.apiReferenceData))
		{
			await insert(saveableI);
		}
	}

	Future<bool> isNew (ColumnNameAndData apiReferenceData)
	async {
		if (apiReferenceData == null)
		{
			return true;
		}

		var filter = getFilter(apiReferenceData);
		var entity = await getEntity(filter);
		return entity == null;
	}

	@override
	Future<E> getLatestMatch (ColumnNameAndData filterOn, String dateTimeColumn)
	{
		var filter = getFilter(filterOn);
		var sortOrder = SortOrder(dateTimeColumn, false);
		return getEntity(filter, sortOrder: sortOrder);
	}

	Future<E> getEntity (Filter filter, {SortOrder sortOrder})
	{
		var finder = Finder(filter: filter, sortOrders: [sortOrder]);
		return getEntityForFinder(finder);
	}

	@override
	Future<E> getMatch (ColumnNameAndData filterOn)
	{
		var filter = getFilter(filterOn);
		return getEntity(filter);
	}

	@override
	Future<List<E>> getAllMatches (ColumnNameAndData filterOn)
	{
		var filter = getFilter(filterOn);
		var finder = Finder(filter: filter);
		return _getAllForFinder(finder);
	}
}

Filter getFilter (ColumnNameAndData filterOn)
{
	return Filter.equals(filterOn.name, filterOn.data);
}
