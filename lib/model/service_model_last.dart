class ServiceModel {
  String? serviceName;
  String? serviceCategory;
  String? servicePrice;
  String? imageURL;
  String? userImageURL;
  ServiceModel(
      {this.serviceName,
      this.serviceCategory,
      this.servicePrice,
      this.imageURL,
      this.userImageURL});

  // receiving data from server
  factory ServiceModel.fromMap(map) {
    return ServiceModel(
        serviceName: map['serviceName'],
        serviceCategory: map['serviceCategory'],
        servicePrice: map['servicePrice'],
        imageURL: map['imageURL'],
        userImageURL: map['userImageURL']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'serviceName': serviceName,
      'serviceCategory': serviceCategory,
      'servicePrice': servicePrice,
      'imageURL': imageURL,
      'userImageURL': userImageURL
    };
  }
}
