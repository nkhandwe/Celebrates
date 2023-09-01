import 'package:dio/dio.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/helper/product_type.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';

class ProductRepo {
  final DioClient? dioClient;

  ProductRepo({required this.dioClient});

  Future<ApiResponse> getPopularProductList(String offset, String languageCode) async {
    try {
      final response = await dioClient!.get('${AppConstants.popularProductURI}?limit=10&&offset=$offset',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);

    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLatestProductList(String offset) async {
    try {
      final response = await dioClient!.get('${AppConstants.latestProductURI}?limit=10&&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getItemList(String offset, String? languageCode, String? productType) async {
    try {
      String? apiUrl;
      if(productType == ProductType.featuredItem){
        apiUrl = AppConstants.featuredProduct;
      }else if(productType == ProductType.dailyItem){
        apiUrl = AppConstants.dailyItemUri;
      } else if(productType == ProductType.popularProduct){
        apiUrl = AppConstants.popularProductURI;
      }else if(productType == ProductType.mostReviewed){
        apiUrl = AppConstants.mostReviewedProduct;
      }
      else if(productType == ProductType.recommendProduct){
        apiUrl = AppConstants.recommendProduct;
      } else if(productType == ProductType.trendingProduct){
        apiUrl = AppConstants.trendingProduct;
      }
      //_apiUrl = AppConstants.popularProductURI;

      final response = await dioClient!.get('$apiUrl?limit=10&&offset=$offset',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(String productID, String languageCode, bool searchQuery) async {
    try {
      String params = productID;
      if(searchQuery) {
        params = '$productID?attribute=product';
      }
      final response = await dioClient!.get('${AppConstants.productDetailsUri}$params',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> placeOrderWith(List<XFile>imagesList,String message,String id) async {
    FormData formData = FormData();
    print(id);
    if(imagesList.isNotEmpty)
    {
      for (int i = 0; i < imagesList.length; i++) {
        String fileName = 'image_$i.jpg';
        formData.files.add(MapEntry(
          'customimg[]',
          await MultipartFile.fromFile(imagesList[i].path, filename: fileName),
        ));
      }
    }
    formData.fields.add(MapEntry('id', id));

    if(message.isNotEmpty)
    {
      formData.fields.add(MapEntry('custommsg', message.toString()));
    }
    else
    {
      formData.fields.add(MapEntry('message', ""));
    }

    for(int i=0; i<formData.fields.length; i++)
    {
      print(formData.fields[i].key);
      print(formData.fields[i].value);
    }

    for(int i=0; i<formData.files.length; i++)
    {
      print(formData.files[i].key);
      print(formData.files[i].value);
    }

    try {
      final response = await dioClient!.post(AppConstants.placeOrderMessageUri, data: formData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchProduct(String productId, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.searchProductUri}$productId',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBrandOrCategoryProductList(String id, String languageCode) async {
    try {
      String uri = '${AppConstants.categoryProductUri}$id';

      final response = await dioClient!.get(uri, options: Options(headers: {'X-localization': languageCode}));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
