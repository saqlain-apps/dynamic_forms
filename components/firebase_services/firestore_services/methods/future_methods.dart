import '../firestore_services.dart';
import '../utils.dart';

mixin FirestoreFutureMethods on FirestoreServicesCore {
  Future<T> docFuture<T>(FirestoreDocParser<T> docParser) async {
    try {
      var rawData = await docParser.ref.get();
      var data = docParser.parser(rawData.data() ?? {});
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> asyncDocFuture<T>(FirestoreAsyncDocParser<T> docParser) async {
    try {
      var rawData = await docParser.ref.get();
      var data = await docParser.parser(rawData.data() ?? {});
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<T>> queryFuture<T>(FirestoreQueryParser<T> queryParser) async {
    try {
      var rawData = await queryParser.ref.get();
      var data =
          rawData.docs.map((doc) => queryParser.parser(doc.data())).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> queryListFuture<T>(FirestoreListQueryParser<T> queryParser) async {
    try {
      var rawData = await queryParser.ref.get();
      var data =
          queryParser.parser(rawData.docs.map((doc) => doc.data()).toList());

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
