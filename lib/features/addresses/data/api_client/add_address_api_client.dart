import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/addresses/data/models/add_address_request_model.dart';
import 'package:flowrist/features/addresses/data/models/get_cities_response_model.dart';
import 'package:flowrist/features/addresses/data/models/get_governorates_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'add_address_api_client.g.dart';

@singleton
@RestApi()
abstract class AddAddressApiClient {
  @factoryMethod
  factory AddAddressApiClient(Dio dio) = _AddAddressApiClient;

  @GET(Endpoints.governorates)
  Future<GetGovernoratesResponseModel> getGovernorates();

  @GET(Endpoints.cities)
  Future<GetCitiesResponseModel> getCities(
    @Path("governorateId") int governorateId,
  );

  @POST(Endpoints.saveAddress)
  Future<void> saveAddress(@Body() AddAddressRequestModel request);
}
