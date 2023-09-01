class BannerModel {
  int? _id;
  String? _title;
  String? _image;
  int? _productId;
  int? _status;
  int? _featured;
  String? _createdAt;
  String? _updatedAt;
  int? _categoryId;

  BannerModel(
      {int? id,
        String? title,
        String? image,
        int? productId,
        int? status,
        int? featured,
        String? createdAt,
        String? updatedAt,
        int? categoryId}) {
    _id = id;
    _title = title;
    _image = image;
    _productId = productId;
    _status = status;
    _featured = featured;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _categoryId = categoryId;
  }

  int? get id => _id;
  String? get title => _title;
  String? get image => _image;
  int? get productId => _productId;
  int? get status => _status;
  int? get featured => _featured;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get categoryId => _categoryId;


  BannerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _productId = json['product_id'];
    _status = json['status'];
    _featured = json['featured'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['image'] = _image;
    data['product_id'] = _productId;
    data['status'] = _status;
    data['featured'] = _featured;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['category_id'] = _categoryId;
    return data;
  }
}
