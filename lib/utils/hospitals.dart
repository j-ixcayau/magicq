import 'package:magiq/utils/service_location.dart';

class HospitalsInfo {
  List<ServiceLocation> build() {
    return _hospitals
        .map(
          (it) => ServiceLocation(
            coordinates: it['coordinates'] as AppLocation,
            name: it['name'] as String,
          ),
        )
        .toList();
  }

  final _hospitals = [
    {
      "coordinates":
          const AppLocation(lat: 15.311212609901624, lng: -91.48463748286714),
      "name": "Altuve"
    },
    {
      "coordinates":
          const AppLocation(lat: 15.528169101441524, lng: -89.33438698949656),
      "name": "CAIMI"
    },
    {
      "coordinates":
          const AppLocation(lat: 14.566617415092514, lng: -89.35099306617573),
      "name": "Centro Dental Esquipulas"
    },
    {
      "coordinates":
          const AppLocation(lat: 14.806664149027794, lng: -89.53912499034067),
      "name": "Centro Médico de Chiquimula"
    },
    {
      "coordinates":
          const AppLocation(lat: 14.743608587420862, lng: -91.15887557233752),
      "name": "Centro Médico San Francisco"
    },
    {
      "coordinates":
          const AppLocation(lat: 15.317172438901494, lng: -89.87609446201802),
      "name": "Hospital de Santa Catarina La Tinta"
    },
    {
      "coordinates":
          const AppLocation(lat: 15.030725083565796, lng: -91.1570422905057),
      "name": "Hospital de Santa Elena"
    }
  ];
}
