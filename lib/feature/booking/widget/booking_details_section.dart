import 'package:demandium/components/image_dialog.dart';
import 'package:demandium/feature/booking/widget/booking_otp_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/booking/widget/booking_summery_widget.dart';
import 'package:demandium/feature/booking/widget/provider_info.dart';
import 'package:demandium/feature/booking/widget/service_man_info.dart';
import 'booking_screen_shimmer.dart';

class BookingDetailsSection extends StatelessWidget {

  const BookingDetailsSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BookingDetailsController>( builder: (bookingDetailsTabController) {

        if(bookingDetailsTabController.bookingDetailsContent != null){

          BookingDetailsContent? bookingDetailsContent =  bookingDetailsTabController.bookingDetailsContent;
          String bookingStatus = bookingDetailsContent?.bookingStatus ?? "";
          bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

            return SingleChildScrollView( physics: const BouncingScrollPhysics(), child: Center(
              child: Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                  const SizedBox(height: Dimensions.paddingSizeEight),
                  BookingInfo(bookingDetailsContent: bookingDetailsContent!, bookingDetailsTabController: bookingDetailsTabController),

                  (Get.find<SplashController>().configModel.content!.confirmationOtpStatus! && (bookingStatus == "accepted" || bookingStatus== "ongoing")) ?
                  BookingOtpWidget(bookingDetailsContent: bookingDetailsContent) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeEight),

                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)), boxShadow: searchBoxShadow
                    ),//boxShadow: shadow),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('payment_method'.tr, style:ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!, decoration: TextDecoration.none,
                        )),
                        const SizedBox(height: Dimensions.radiusDefault),

                        Text(
                            bookingDetailsContent.paymentMethod!.tr,
                            style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: Dimensions.radiusDefault),

                        Text(
                            '${'transaction_id'.tr} : ${bookingDetailsContent.transactionId ?? ''}',
                            style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)),
                            overflow: TextOverflow.ellipsis),
                      ],
                      ),

                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text( '${bookingDetailsContent.isPaid == 0 ? 'unpaid'.tr: 'paid'.tr} ',
                            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault,
                                color: bookingDetailsContent.isPaid == 0?Theme.of(context).colorScheme.error : Colors.green, decoration: TextDecoration.none)
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),


                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                              PriceConverter.convertPrice(bookingDetailsContent.totalBookingAmount!.toDouble(),isShowLongPrice: true),
                              style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).colorScheme.primary,)),
                        ),
                      ]),
                    ]),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  BookingSummeryWidget(bookingDetailsContent: bookingDetailsContent),

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  bookingDetailsContent.provider != null ? ProviderInfo(provider: bookingDetailsContent.provider!) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  bookingDetailsContent.serviceman != null ? ServiceManInfo(user: bookingDetailsContent.serviceman!.user!) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  bookingDetailsContent.photoEvidence != null && bookingDetailsContent.photoEvidence!.isNotEmpty ?
                  Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      Text('completed_service_picture'.tr,  style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Container(
                        height: 90,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: bookingDetailsContent.photoEvidence?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                child: GestureDetector(
                                  onTap: () => showDialog(context: context, builder: (ctx)  =>
                                    ImageDialog(
                                      imageUrl:"${Get.find<SplashController>().configModel.content?.imageBaseUrl}/booking/evidence/${bookingDetailsContent.photoEvidence?[index]??""}",
                                      title: "completed_service_picture".tr,
                                      subTitle: "",
                                    )
                                  ),
                                  child: CustomImage(
                                    image: "${Get.find<SplashController>().configModel.content?.imageBaseUrl}/booking/evidence/${bookingDetailsContent.photoEvidence?[index]??""}",
                                    height: 70, width: 120,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),


                    ],
                    ),
                  ): const SizedBox(),

                  bookingDetailsTabController.isCancelling ? const Center(child: CircularProgressIndicator()) : isLoggedIn && (bookingStatus == 'pending' || bookingStatus== 'accepted') ?
                  Align( alignment: Alignment.center, child: InkWell( onTap: () =>  Get.dialog(
                    ConfirmationDialog(
                      icon: Images.deleteProfile,
                      title: 'are_you_sure_to_cancel_your_order'.tr, description: 'your_order_will_be_cancel'.tr,
                      descriptionTextColor: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
                      onYesPressed: () {
                        bookingDetailsTabController.bookingCancel(bookingId: bookingDetailsContent.id!);
                        Get.back();
                        },
                    ), useSafeArea: false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.error.withOpacity(.2),
                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                        ),
                        child: Padding(padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                          child: Text('cancel'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).colorScheme.error,),
                          ),
                        ),
                    )
                  )) : const SizedBox(),

                  SizedBox(height: bookingStatus == "completed" && isLoggedIn ? Dimensions.paddingSizeExtraLarge * 3 : Dimensions.paddingSizeExtraLarge ),

                ]),
              ),
            ),
          );
        }else{
          return const SingleChildScrollView(child: BookingScreenShimmer());
        }
      }),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Get.find<AuthController>().isLoggedIn() ?
      GetBuilder<BookingDetailsController>(builder: (bookingDetailsController){
        if(bookingDetailsController.bookingDetailsContent !=null ){
          return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Expanded(child: SizedBox()),
            Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault,),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [

                FloatingActionButton( hoverColor: Colors.transparent, elevation: 0.0,
                  backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () {
                    BookingDetailsContent bookingDetailsContent = bookingDetailsController.bookingDetailsContent!;

                    if (bookingDetailsContent.provider != null ) {
                      showModalBottomSheet( useRootNavigator: true, isScrollControlled: true,
                        backgroundColor: Colors.transparent, context: context, builder: (context) => CreateChannelDialog(
                          customerID: bookingDetailsContent.customerId,
                          providerId: bookingDetailsContent.provider?.userId ,
                          serviceManId:  bookingDetailsContent.serviceman?.userId,
                          referenceId: bookingDetailsContent.readableId.toString(),
                        ),
                      );
                    } else {
                      customSnackBar('provider_or_service_man_assigned'.tr);
                    }
                  },
                  child: Icon(Icons.message_rounded, color: Theme.of(context).primaryColorLight),
                ),
              ]),
            ),

            bookingDetailsController.bookingDetailsContent!.bookingStatus == 'completed' ?
            Row(
              children: [
                Expanded(
                  child: CustomButton (radius: 0, buttonText: 'review'.tr, onPressed: () {
                    showModalBottomSheet(context: context,
                      useRootNavigator: true, isScrollControlled: true,
                      backgroundColor: Colors.transparent, builder: (context) => ReviewRecommendationDialog(
                        id: bookingDetailsController.bookingDetailsContent!.id!,
                      ),
                    );},
                  ),
                ),

                Container(
                  width: 3, height: 50,
                  color: Theme.of(context).disabledColor,
                ),

                GetBuilder<ServiceBookingController>(
                  builder: (serviceBookingController) {
                    return Expanded(
                      child: CustomButton(
                        radius: 0,
                        isLoading: serviceBookingController.isLoading,
                        buttonText: "rebook".tr,
                        onPressed: () {
                          serviceBookingController.checkCartSubcategory(bookingDetailsController.bookingDetailsContent!.id!, bookingDetailsController.bookingDetailsContent!.subCategoryId!);
                        },
                      ),
                    );
                  }
                ),
              ],
            )
            : const SizedBox()

          ]);
        }else{
          return const SizedBox();
        }
      }) : null,
    );
  }
}
