import 'package:get/get_connect/http/src/response/response.dart';
import 'package:quickad_it_solutions/data/api/api_client.dart';
import 'package:quickad_it_solutions/util/app_constants.dart';

class ParcelRepo {
  final ApiClient apiClient;
  ParcelRepo({required this.apiClient});

  Future<Response> getParcelCategory() {
    return apiClient.getData(AppConstants.parcelCategoryUri);
  }

  Future<Response> getPlaceDetails(String? placeID) async {
    return await apiClient
        .getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
  }

  Future<Response> getWhyChooseDetails() async {
    return await apiClient.getData(AppConstants.whyChooseUri);
  }

  //get video content uri
  Future<Response> getVideoContentDetails() async {
    return await apiClient.getData(AppConstants.videoContentUri);
  }
}
