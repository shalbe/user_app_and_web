class VendorModel {
  VendorModel({
    required this.id,
    required this.name,
    required this.slug,
    this.verified,
    this.verifiedText,
    this.rating,
    this.image,
    this.contactNumber,
  });

  int id;
  String name;
  String slug;
  bool? verified;
  String? verifiedText;
  String? rating;
  String? image;
  String? contactNumber;

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        verified: json["verified"],
        verifiedText: json["verified_text"],
        rating: json["rating"],
        image: json["image"],
        contactNumber: json["contact_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "verified": verified,
        "verified_text": verifiedText,
        "rating": rating,
        "image": image,
        "contact_number": contactNumber,
      };
}
