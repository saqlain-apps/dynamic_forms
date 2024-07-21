import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_services.dart';

typedef ParserMethod<T> = T Function(Map<String, dynamic> data);
typedef AsyncParserMethod<T> = FutureOr<T> Function(Map<String, dynamic> data);
typedef ListParserMethod<T> = T Function(List<Map<String, dynamic>> list);

abstract class FirestoreQueryInterface<T> {
  const FirestoreQueryInterface();

  Stream<T> stream(FirestoreServices firestore);
  Future<T> get(FirestoreServices firestore);
}

sealed class Parser<T> {
  const Parser(this.parser);
  final ParserMethod<T> parser;
}

sealed class AsyncParser<T> {
  const AsyncParser(this.parser);
  final AsyncParserMethod<T> parser;
}

sealed class ListParser<T> {
  const ListParser(this.parser);
  final ListParserMethod<T> parser;
}

sealed class DocRef {
  const DocRef(this.ref);
  final DocumentReference<Map<String, dynamic>> ref;
}

sealed class QueryRef {
  const QueryRef(this.ref);
  final Query<Map<String, dynamic>> ref;
}

class FirestoreDocParser<T>
    implements FirestoreQueryInterface<T>, Parser<T>, DocRef {
  const FirestoreDocParser({required this.ref, required this.parser});

  @override
  final DocumentReference<Map<String, dynamic>> ref;

  @override
  final ParserMethod<T> parser;

  @override
  Stream<T> stream(FirestoreServices firestore) => firestore.docStream(this);

  @override
  Future<T> get(FirestoreServices firestore) => firestore.docFuture(this);
}

class FirestoreAsyncDocParser<T>
    implements FirestoreQueryInterface<T>, AsyncParser<T>, DocRef {
  const FirestoreAsyncDocParser({required this.ref, required this.parser});

  @override
  final DocumentReference<Map<String, dynamic>> ref;

  @override
  final AsyncParserMethod<T> parser;

  @override
  Stream<T> stream(FirestoreServices firestore) =>
      firestore.asyncDocStream(this);

  @override
  Future<T> get(FirestoreServices firestore) => firestore.asyncDocFuture(this);
}

class FirestoreQueryParser<T>
    implements FirestoreQueryInterface<List<T>>, Parser<T>, QueryRef {
  const FirestoreQueryParser({required this.ref, required this.parser});
  @override
  final Query<Map<String, dynamic>> ref;
  @override
  final ParserMethod<T> parser;

  @override
  Stream<List<T>> stream(FirestoreServices firestore) =>
      firestore.queryStream(this);

  @override
  Future<List<T>> get(FirestoreServices firestore) =>
      firestore.queryFuture(this);
}

class FirestoreListQueryParser<T>
    implements FirestoreQueryInterface<T>, ListParser<T>, QueryRef {
  const FirestoreListQueryParser({required this.ref, required this.parser});
  @override
  final Query<Map<String, dynamic>> ref;
  @override
  final ListParserMethod<T> parser;

  @override
  Stream<T> stream(FirestoreServices firestore) =>
      firestore.queryListStream(this);

  @override
  Future<T> get(FirestoreServices firestore) => firestore.queryListFuture(this);
}

class FirestoreQuery<T> {
  FirestoreQuery({
    required this.firestore,
    required this.parser,
  });

  final FirestoreServices firestore;
  final FirestoreQueryInterface<T> parser;

  Stream<T> stream() => parser.stream(firestore);
  Future<T> get() => parser.get(firestore);
}
