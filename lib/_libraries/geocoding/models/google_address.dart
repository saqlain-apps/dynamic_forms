import '/_libraries/extensions.dart';
import 'coordinates.dart';

class GoogleAddress extends GoogleAddressComponent {
  const GoogleAddress({
    required super.coordinates,
    required super.address,
    super.plusCode,
    super.subpremise,
    super.premise,
    super.establishment,
    super.landmark,
    super.streetNumber,
    super.route,
    super.intersection,
    super.neighborhood,
    super.postalTown,
    super.sublocality,
    super.locality,
    super.political,
    super.administrativeAreaLevel7,
    super.administrativeAreaLevel6,
    super.administrativeAreaLevel5,
    super.administrativeAreaLevel4,
    super.administrativeAreaLevel3,
    super.administrativeAreaLevel2,
    super.administrativeAreaLevel1,
    super.postalCode,
    super.country,
  });

  @override
  GoogleAddress copyWith({
    Coordinates? coordinates,
    String? address,
    String? plusCode,
    String? subpremise,
    String? premise,
    String? establishment,
    String? landmark,
    String? streetNumber,
    String? route,
    String? intersection,
    String? neighborhood,
    String? postalTown,
    String? sublocality,
    String? locality,
    String? political,
    String? administrativeAreaLevel7,
    String? administrativeAreaLevel6,
    String? administrativeAreaLevel5,
    String? administrativeAreaLevel4,
    String? administrativeAreaLevel3,
    String? administrativeAreaLevel2,
    String? administrativeAreaLevel1,
    String? postalCode,
    String? country,
  }) {
    return GoogleAddress(
      coordinates: coordinates ?? this.coordinates,
      address: address ?? this.address,
      plusCode: plusCode ?? this.plusCode,
      subpremise: subpremise ?? this.subpremise,
      premise: premise ?? this.premise,
      establishment: establishment ?? this.establishment,
      landmark: landmark ?? this.landmark,
      streetNumber: streetNumber ?? this.streetNumber,
      route: route ?? this.route,
      intersection: intersection ?? this.intersection,
      neighborhood: neighborhood ?? this.neighborhood,
      postalTown: postalTown ?? this.postalTown,
      sublocality: sublocality ?? this.sublocality,
      locality: locality ?? this.locality,
      political: political ?? this.political,
      administrativeAreaLevel7:
          administrativeAreaLevel7 ?? this.administrativeAreaLevel7,
      administrativeAreaLevel6:
          administrativeAreaLevel6 ?? this.administrativeAreaLevel6,
      administrativeAreaLevel5:
          administrativeAreaLevel5 ?? this.administrativeAreaLevel5,
      administrativeAreaLevel4:
          administrativeAreaLevel4 ?? this.administrativeAreaLevel4,
      administrativeAreaLevel3:
          administrativeAreaLevel3 ?? this.administrativeAreaLevel3,
      administrativeAreaLevel2:
          administrativeAreaLevel2 ?? this.administrativeAreaLevel2,
      administrativeAreaLevel1:
          administrativeAreaLevel1 ?? this.administrativeAreaLevel1,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'coordinates': {
        "lat": coordinates.latitude,
        "lng": coordinates.longitude,
      },
      'address': address,
      ...super.toMap(),
    };
  }

  factory GoogleAddress.fromMap(
    Map<String, dynamic> map, {
    Coordinates? coordinates,
  }) {
    var results = (map['results'] as List)
        .cast<Map<String, dynamic>>()
        .map(GoogleAddressComponent.fromMap)
        .toList();

    String? findComponent(
      String? Function(GoogleAddressComponent? address) finder,
    ) {
      return finder(results.findWhere((e) => finder(e) != null));
    }

    final components = GoogleAddressComponents(
      plusCode: findComponent((address) => address?.plusCode),
      subpremise: findComponent((address) => address?.subpremise),
      premise: findComponent((address) => address?.premise),
      establishment: findComponent((address) => address?.establishment),
      landmark: findComponent((address) => address?.landmark),
      streetNumber: findComponent((address) => address?.streetNumber),
      route: findComponent((address) => address?.route),
      intersection: findComponent((address) => address?.intersection),
      neighborhood: findComponent((address) => address?.neighborhood),
      postalTown: findComponent((address) => address?.postalTown),
      sublocality: findComponent((address) => address?.sublocality),
      locality: findComponent((address) => address?.locality),
      political: findComponent((address) => address?.political),
      administrativeAreaLevel7:
          findComponent((address) => address?.administrativeAreaLevel7),
      administrativeAreaLevel6:
          findComponent((address) => address?.administrativeAreaLevel6),
      administrativeAreaLevel5:
          findComponent((address) => address?.administrativeAreaLevel5),
      administrativeAreaLevel4:
          findComponent((address) => address?.administrativeAreaLevel4),
      administrativeAreaLevel3:
          findComponent((address) => address?.administrativeAreaLevel3),
      administrativeAreaLevel2:
          findComponent((address) => address?.administrativeAreaLevel2),
      administrativeAreaLevel1:
          findComponent((address) => address?.administrativeAreaLevel1),
      postalCode: findComponent((address) => address?.postalCode),
      country: findComponent((address) => address?.country),
    );

    return GoogleAddress(
      coordinates: results.first.coordinates,
      address: (components.componentsMap()..remove('plusCode'))
          .entries
          .map((e) => e.value)
          .whereNotNull
          .join(', '),
      plusCode: components.plusCode,
      subpremise: components.subpremise,
      premise: components.premise,
      establishment: components.establishment,
      landmark: components.landmark,
      streetNumber: components.streetNumber,
      route: components.route,
      intersection: components.intersection,
      neighborhood: components.neighborhood,
      postalTown: components.postalTown,
      sublocality: components.sublocality,
      locality: components.locality,
      political: components.political,
      administrativeAreaLevel7: components.administrativeAreaLevel7,
      administrativeAreaLevel6: components.administrativeAreaLevel6,
      administrativeAreaLevel5: components.administrativeAreaLevel5,
      administrativeAreaLevel4: components.administrativeAreaLevel4,
      administrativeAreaLevel3: components.administrativeAreaLevel3,
      administrativeAreaLevel2: components.administrativeAreaLevel2,
      administrativeAreaLevel1: components.administrativeAreaLevel1,
      postalCode: components.postalCode,
      country: components.country,
    );
  }
}

class GooglePlace extends GoogleAddressComponent {
  const GooglePlace({
    required this.id,
    required this.name,
    required this.url,
    required super.coordinates,
    required super.address,
    super.plusCode,
    super.subpremise,
    super.premise,
    super.establishment,
    super.landmark,
    super.streetNumber,
    super.route,
    super.intersection,
    super.neighborhood,
    super.postalTown,
    super.sublocality,
    super.locality,
    super.political,
    super.administrativeAreaLevel7,
    super.administrativeAreaLevel6,
    super.administrativeAreaLevel5,
    super.administrativeAreaLevel4,
    super.administrativeAreaLevel3,
    super.administrativeAreaLevel2,
    super.administrativeAreaLevel1,
    super.postalCode,
    super.country,
  });

  final String id;
  final String name;
  final String url;

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      ...super.toMap(),
    };
  }

  factory GooglePlace.fromMap(Map<String, dynamic> map) {
    final address = GoogleAddressComponent.fromMap(map);
    return GooglePlace(
      id: map['id'] ?? '',
      address: address.address,
      name: map['displayName']?['text'] ?? map['shortFormattedAddress'] ?? '',
      url: map['googleMapsUri'] ?? '',
      coordinates: address.coordinates,
      plusCode: address.plusCode,
      subpremise: address.subpremise,
      premise: address.premise,
      establishment: address.establishment,
      landmark: address.landmark,
      streetNumber: address.streetNumber,
      route: address.route,
      intersection: address.intersection,
      neighborhood: address.neighborhood,
      postalTown: address.postalTown,
      sublocality: address.sublocality,
      locality: address.locality,
      political: address.political,
      administrativeAreaLevel7: address.administrativeAreaLevel7,
      administrativeAreaLevel6: address.administrativeAreaLevel6,
      administrativeAreaLevel5: address.administrativeAreaLevel5,
      administrativeAreaLevel4: address.administrativeAreaLevel4,
      administrativeAreaLevel3: address.administrativeAreaLevel3,
      administrativeAreaLevel2: address.administrativeAreaLevel2,
      administrativeAreaLevel1: address.administrativeAreaLevel1,
      postalCode: address.postalCode,
      country: address.country,
    );
  }
}

class GoogleAddressComponent extends GoogleAddressComponents {
  const GoogleAddressComponent({
    required this.coordinates,
    required this.address,
    super.plusCode,
    super.subpremise,
    super.premise,
    super.establishment,
    super.landmark,
    super.streetNumber,
    super.route,
    super.intersection,
    super.neighborhood,
    super.postalTown,
    super.sublocality,
    super.locality,
    super.political,
    super.administrativeAreaLevel7,
    super.administrativeAreaLevel6,
    super.administrativeAreaLevel5,
    super.administrativeAreaLevel4,
    super.administrativeAreaLevel3,
    super.administrativeAreaLevel2,
    super.administrativeAreaLevel1,
    super.postalCode,
    super.country,
  });

  final Coordinates coordinates;
  final String address;

  @override
  Map<String, dynamic> toMap() {
    return {
      'coordinates': {
        "lat": coordinates.latitude,
        "lng": coordinates.longitude,
      },
      'address': address,
      ...super.toMap(),
    };
  }

  factory GoogleAddressComponent.fromMap(Map<String, dynamic> map) {
    map = parseRaw(map);
    var components = map['components'];
    return GoogleAddressComponent(
      coordinates: Coordinates(
        latitude: map['coordinates']['lat'],
        longitude: map['coordinates']['lng'],
      ),
      address: map['address'] ?? '',
      plusCode: components['plus_code'],
      subpremise: components['subpremise'],
      premise: components['premise'],
      establishment: components['establishment'],
      landmark: components['landmark'],
      streetNumber: components['street_number'],
      route: components['route'],
      intersection: components['intersection'],
      neighborhood: components['neighborhood'],
      postalTown: components['postal_town'],
      sublocality: components['sublocality'],
      locality: components['locality'],
      political: components['political'],
      administrativeAreaLevel7: components['administrative_area_level_7'],
      administrativeAreaLevel6: components['administrative_area_level_6'],
      administrativeAreaLevel5: components['administrative_area_level_5'],
      administrativeAreaLevel4: components['administrative_area_level_4'],
      administrativeAreaLevel3: components['administrative_area_level_3'],
      administrativeAreaLevel2: components['administrative_area_level_2'],
      administrativeAreaLevel1: components['administrative_area_level_1'],
      postalCode: components['postal_code'],
      country: components['country'],
    );
  }

  static Map<String, dynamic> parseRaw(
    Map<String, dynamic> raw, {
    bool shortNames = false,
  }) {
    return {
      "id": raw['id'] ?? raw['place_id'],
      "components": Map.fromEntries(
          ((raw['address_components'] ?? raw['addressComponents']) as List)
              .cast<Map<String, dynamic>>()
              .map(
                (e) => MapEntry(
                  e['types'][0],
                  shortNames
                      ? (e['short_name'] ?? e['shortText'])
                      : (e['long_name'] ?? e['longText']),
                ),
              )),
      "address": raw['formatted_address'] ?? raw['formattedAddress'],
      "coordinates": raw['geometry']?['location'] ??
          {
            "lat": raw['location']['latitude'],
            "lng": raw['location']['longitude'],
          },
    };
  }
}

class GoogleAddressComponents {
  const GoogleAddressComponents({
    this.plusCode,
    this.subpremise,
    this.premise,
    this.establishment,
    this.landmark,
    this.streetNumber,
    this.route,
    this.intersection,
    this.neighborhood,
    this.postalTown,
    this.sublocality,
    this.locality,
    this.political,
    this.administrativeAreaLevel7,
    this.administrativeAreaLevel6,
    this.administrativeAreaLevel5,
    this.administrativeAreaLevel4,
    this.administrativeAreaLevel3,
    this.administrativeAreaLevel2,
    this.administrativeAreaLevel1,
    this.postalCode,
    this.country,
  });

  final String? plusCode;
  final String? subpremise;
  final String? premise;
  final String? establishment;
  final String? landmark;
  final String? streetNumber;
  final String? route;
  final String? intersection;
  final String? neighborhood;
  final String? postalTown;
  final String? sublocality;
  final String? locality;
  final String? political;
  final String? administrativeAreaLevel7;
  final String? administrativeAreaLevel6;
  final String? administrativeAreaLevel5;
  final String? administrativeAreaLevel4;
  final String? administrativeAreaLevel3;
  final String? administrativeAreaLevel2;
  final String? administrativeAreaLevel1;
  final String? postalCode;
  final String? country;

  String? get consolidatedState =>
      administrativeAreaLevel1 ?? administrativeAreaLevel2;
  String? get consolidatedCounty =>
      administrativeAreaLevel2 ?? administrativeAreaLevel3;
  String? get consolidatedCity =>
      locality ??
      administrativeAreaLevel3 ??
      sublocality ??
      postalTown ??
      administrativeAreaLevel4 ??
      administrativeAreaLevel5;

  Map<String, dynamic> componentsMap() {
    return {
      'plusCode': plusCode,
      'subpremise': subpremise,
      'premise': premise,
      'establishment': establishment,
      'landmark': landmark,
      'streetNumber': streetNumber,
      'route': route,
      'intersection': intersection,
      'neighborhood': neighborhood,
      'postalTown': postalTown,
      'sublocality': sublocality,
      'locality': locality,
      'political': political,
      'administrativeAreaLevel7': administrativeAreaLevel7,
      'administrativeAreaLevel6': administrativeAreaLevel6,
      'administrativeAreaLevel5': administrativeAreaLevel5,
      'administrativeAreaLevel4': administrativeAreaLevel4,
      'administrativeAreaLevel3': administrativeAreaLevel3,
      'administrativeAreaLevel2': administrativeAreaLevel2,
      'administrativeAreaLevel1': administrativeAreaLevel1,
      'postalCode': postalCode,
      'country': country,
    };
  }

  Map<String, dynamic> toMap() =>
      componentsMap()..removeWhere((key, value) => value == null);

  GoogleAddressComponents copyWith({
    String? plusCode,
    String? subpremise,
    String? premise,
    String? establishment,
    String? landmark,
    String? streetNumber,
    String? route,
    String? intersection,
    String? neighborhood,
    String? postalTown,
    String? sublocality,
    String? locality,
    String? political,
    String? administrativeAreaLevel7,
    String? administrativeAreaLevel6,
    String? administrativeAreaLevel5,
    String? administrativeAreaLevel4,
    String? administrativeAreaLevel3,
    String? administrativeAreaLevel2,
    String? administrativeAreaLevel1,
    String? postalCode,
    String? country,
  }) {
    return GoogleAddressComponents(
      plusCode: plusCode ?? this.plusCode,
      subpremise: subpremise ?? this.subpremise,
      premise: premise ?? this.premise,
      establishment: establishment ?? this.establishment,
      landmark: landmark ?? this.landmark,
      streetNumber: streetNumber ?? this.streetNumber,
      route: route ?? this.route,
      intersection: intersection ?? this.intersection,
      neighborhood: neighborhood ?? this.neighborhood,
      postalTown: postalTown ?? this.postalTown,
      sublocality: sublocality ?? this.sublocality,
      locality: locality ?? this.locality,
      political: political ?? this.political,
      administrativeAreaLevel7:
          administrativeAreaLevel7 ?? this.administrativeAreaLevel7,
      administrativeAreaLevel6:
          administrativeAreaLevel6 ?? this.administrativeAreaLevel6,
      administrativeAreaLevel5:
          administrativeAreaLevel5 ?? this.administrativeAreaLevel5,
      administrativeAreaLevel4:
          administrativeAreaLevel4 ?? this.administrativeAreaLevel4,
      administrativeAreaLevel3:
          administrativeAreaLevel3 ?? this.administrativeAreaLevel3,
      administrativeAreaLevel2:
          administrativeAreaLevel2 ?? this.administrativeAreaLevel2,
      administrativeAreaLevel1:
          administrativeAreaLevel1 ?? this.administrativeAreaLevel1,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }
}
