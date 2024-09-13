import 'dart:ui';

import 'package:custom_marker/marker_icon.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/core/helper/map_bound_helper.dart';
import 'package:demandium/feature/area/model/zone_model.dart';
import 'package:demandium/feature/area/repository/service_area_repository.dart';
import 'package:get/get.dart';


class ServiceAreaController extends GetxController implements GetxService{
  ServiceAreaRepo serviceAreaRepo;
  ServiceAreaController({required this.serviceAreaRepo});

  List<ZoneModel>? _zoneList;
  //bool _isLoading = false;
  Set<Marker> _markers = {};
  Set<Polygon> _polygone = {};

  //bool get isLoading => _isLoading;
  List<ZoneModel>? get zoneList => _zoneList;
  Set<Marker> get markers => _markers;
  Set<Polygon> get polygone => _polygone;


  Future<void> getZoneList({Map<String, GlobalKey>? globalKeyMap, bool reload = true}) async {

    LatLng currentLocation = const LatLng(0, 0);
    Response response = await serviceAreaRepo.getZoneList();
    if (response.statusCode == 200) {
      _zoneList = [];
      response.body['content']['data'].forEach((zone) => _zoneList!.add(ZoneModel.fromJson(zone)));

      List<Polygon> polygonList = [];
      List<LatLng> currentLocationList = [];


      for (int index = 0; index < _zoneList!.length; index++) {

        List<LatLng> zoneLatLongList = [];
        for (int subIndex = 0; subIndex < _zoneList![index].coordinates!.length; subIndex++) {
          zoneLatLongList.add(LatLng(_zoneList![index].coordinates![subIndex].lat!, _zoneList![index].coordinates![subIndex].lng!));
        }

        LatLng position =  computeCentroid(points: zoneLatLongList);
        currentLocation = LatLng(position.latitude, position.longitude);

        polygonList.add(
          Polygon(
            polygonId: PolygonId('zone$index'),
            points: zoneLatLongList,
            strokeWidth: 2,
            strokeColor: Get.theme.colorScheme.primary,
            fillColor: Get.theme.colorScheme.primary.withOpacity(.2),
          ),
        );

        currentLocationList.add(currentLocation);

      }

      _polygone = HashSet<Polygon>.of(polygonList);

    } else {
      ApiChecker.checkApi(response);
    }

    update();

  }

  Future<void> setMarker(List<ZoneModel> zoneList, Map<String, GlobalKey> globalKeymap) async {

    List<Marker> markerList = [];
   // Uint8List? markerImage = await convertAssetToUnit8List(Images.marker, width: 50,);

    for (int index = 0; index < zoneList.length; index++) {
      List<LatLng> zoneLatLongList = [];
      for (int subIndex = 0; subIndex < zoneList[index].coordinates!.length; subIndex++) {
        zoneLatLongList.add(LatLng(zoneList[index].coordinates![subIndex].lat!, zoneList[index].coordinates![subIndex].lng!));
      }

      markerList.add(Marker(
        infoWindow: GetPlatform.isWeb || GetPlatform.isIOS ? InfoWindow(
          title: zoneList[index].name
        ) : InfoWindow.noText,
        markerId: MarkerId('provider$index'),
      //  icon: BitmapDescriptor.fromBytes(markerImage!),
        icon: GetPlatform.isWeb || GetPlatform.isIOS ? BitmapDescriptor.defaultMarker : await MarkerIcon.widgetToIcon(globalKeymap[index.toString()]!) ,
        position: computeCentroid(coordinates : zoneList[index].coordinates!),
      ));
    }

    _markers = HashSet<Marker>.of(markerList);

  }


  LatLng computeCentroid({List<Coordinates> ? coordinates, Iterable<LatLng>? points}) {
    double latitude = 0;
    double longitude = 0;
    int n = 1;

    if(points !=null){
     n = points.length;

     for (LatLng point in points) {
       latitude += point.latitude;
       longitude += point.latitude;
     }

    } else if(coordinates !=null ){
      n = coordinates.length;

      for (Coordinates point in coordinates) {
        latitude += point.lat!;
        longitude += point.lng!;
      }

    }else{
      n = 1;
    }

    return LatLng(latitude / n, longitude / n);
  }


  Future<Uint8List?> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))?.buffer.asUint8List();
  }


  void mapBound(GoogleMapController controller) async {
    List<LatLng> latLongList = [];
    for (int index = 0; index < _zoneList!.length; index++) {
      if (_zoneList![index].coordinates != null) {
        for (int subIndex = 0; subIndex < _zoneList![index].coordinates!.length; subIndex++) {
          latLongList.add(LatLng(_zoneList![index].coordinates![subIndex].lat!, _zoneList![index].coordinates![subIndex].lng!));
        }
      }
    }
    await controller.getVisibleRegion();
    Future.delayed(const Duration(milliseconds: 100), () {
      controller.animateCamera(CameraUpdate.newLatLngBounds(
        MapBoundHelper.boundsFromLatLngList(latLongList),
        100.5,
      ));
    });

    update();
  }



}