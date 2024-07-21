import 'package:social_touch/utils/custom/stream_utils/stream_list.dart';

import '../firestore_services.dart';
import '../utils.dart';

mixin FirestoreStreamMethods on FirestoreServicesCore {
  Stream<T> asyncDocStream<T>(FirestoreAsyncDocParser<T> docParser) {
    try {
      var rawStream = docParser.ref.snapshots();
      var stream =
          rawStream.asyncMap((doc) => docParser.parser(doc.data() ?? {}));
      return stream;
    } catch (e) {
      rethrow;
    }
  }

  Stream<T> docStream<T>(FirestoreDocParser<T> docParser) {
    try {
      var rawStream = docParser.ref.snapshots();
      var stream = rawStream.map((doc) => docParser.parser(doc.data() ?? {}));
      return stream;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<T>> queryStream<T>(FirestoreQueryParser<T> queryParser) {
    try {
      var rawStream = queryParser.ref.snapshots();
      var stream = rawStream.map((dataList) =>
          dataList.docs.map((doc) => queryParser.parser(doc.data())).toList());
      return stream;
    } catch (e) {
      rethrow;
    }
  }

  Stream<T> queryListStream<T>(FirestoreListQueryParser<T> queryParser) {
    try {
      var rawStream = queryParser.ref.snapshots();
      var stream = rawStream.map((dataList) =>
          queryParser.parser(dataList.docs.map((doc) => doc.data()).toList()));
      return stream;
    } catch (e) {
      rethrow;
    }
  }

  StreamList<T> combineStreams<T>(
    Iterable<Stream<T>> streams, [
    bool broadcast = false,
  ]) {
    var combinedStream =
        broadcast ? StreamList<T>.broadcast() : StreamList<T>();
    for (var stream in streams) {
      combinedStream.add(stream);
    }
    return combinedStream;
  }
}
