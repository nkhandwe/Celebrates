import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/data/model/body/place_order_body.dart';
import 'package:flutter_grocery/data/model/body/review_body.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/helper/date_converter.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class OrderRepo {
  final DioClient? dioClient;
  OrderRepo({required this.dioClient});

  Future<ApiResponse> getOrderList() async {
    try {
      final response = await dioClient!.get(AppConstants.orderListUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponse> getOrderDetails(String orderID, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.orderDetailsUri}$orderID',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> cancelOrder(String orderID) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['order_id'] = orderID;
      data['_method'] = 'put';
      final response = await dioClient!.post(AppConstants.orderCancelUri, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> trackOrder(String? orderID) async {
    try {
      final response = await dioClient!.get('${AppConstants.trackUri}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> placeOrder(PlaceOrderBody orderBody) async {

    try {
      final response = await dioClient!.post(AppConstants.placeOrderUri, data: orderBody.toJson());
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

  Future<ApiResponse> getDeliveryManData(String? orderID) async {
    try {
      final response = await dioClient!.get('${AppConstants.lastLocationUri}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getTimeSlot() async {
    try {
      final response = await dioClient!.get(AppConstants.timeslotUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String> getDates(BuildContext context) {
    List<String> dates = [];
    dates.add(DateConverter.slotDate(DateTime.now()));
    dates.add(DateConverter.slotDate(DateTime.now().add(const Duration(days: 1))));
    dates.add(DateConverter.slotDate(DateTime.now().add(const Duration(days: 2))));

    return dates;
  }

  Future<ApiResponse> updatePaymentMethod(String orderID) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['order_id'] = orderID;
      data['_method'] = 'put';
      data['payment_method'] = 'cash_on_delivery';
      final response = await dioClient!.post(AppConstants.updatePaymentMethodUri, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitReview(ReviewBody reviewBody) async {
    try {
      final response = await dioClient!.post(AppConstants.reviewUri, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitDeliveryManReview(ReviewBody reviewBody) async {
    try {
      final response = await dioClient!.post(AppConstants.deliveryManReviewUri, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    try {
      Response response = await dioClient!.get('${AppConstants.distanceMatrixUri}'
          '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
          '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}

class MultipartBody {
  String key;
  XFile? file;

  MultipartBody(this.key, this.file);
}