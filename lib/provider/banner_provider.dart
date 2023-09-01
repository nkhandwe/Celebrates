import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/banner_model.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/data/repository/banner_repo.dart';
import 'package:flutter_grocery/helper/api_checker.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo? bannerRepo;

  BannerProvider({required this.bannerRepo});

  List<BannerModel>? _bannerList;
  final List<Product> _productList = [];
  List<String?>? _featuredBannerList;
  List<dynamic>? _featuredBannerDataList;
  int _currentIndex = 0;

  List<BannerModel>? get bannerList => _bannerList;
  List<String?>? get featuredBannerList => _featuredBannerList;
  List<dynamic>? get featuredBannerDataList => _featuredBannerDataList;
  List<Product> get productList => _productList;
  int get currentIndex => _currentIndex;

  Future<void> getFeaturedBanner(BuildContext context, bool reload) async {
    ApiResponse apiResponse = await bannerRepo!.getFeaturedBannerList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      print(apiResponse.response!.data);
      _featuredBannerList = [];
      _featuredBannerDataList = [];
      apiResponse.response!.data.forEach((category) {
        BannerModel bannerModel = BannerModel.fromJson(category);
        if (bannerModel.productId != null) {
          getProductDetails(context, bannerModel.productId.toString());
        }
        _bannerList!.add(bannerModel);
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getBannerList(BuildContext context, bool reload) async {
    if (bannerList == null || reload) {
      ApiResponse apiResponse = await bannerRepo!.getBannerList();
      print(apiResponse.response!.data);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bannerList = [];
        apiResponse.response!.data.forEach((category) {
          BannerModel bannerModel = BannerModel.fromJson(category);
          if (bannerModel.productId != null) {
            getProductDetails(context, bannerModel.productId.toString());
          }
          _bannerList!.add(bannerModel);
        });
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void getProductDetails(BuildContext context, String productID) async {
    ApiResponse apiResponse = await bannerRepo!.getProductDetails(productID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _productList.add(Product.fromJson(apiResponse.response!.data));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }
}
