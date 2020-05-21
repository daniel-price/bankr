abstract class IJsonConverter<E> {
  E fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap(E model);
}
