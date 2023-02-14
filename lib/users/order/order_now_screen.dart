import 'package:appshop/users/controller/order_now_controller.dart';
import 'package:appshop/users/order/order_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


class OrderNowScreen extends StatelessWidget
{
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final List<int>? selectedCartIDs;

  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNamesList = ["VNPost", "J&T Express", "Giao Hàng Nhanh"];
  List<String> paymentSystemNamesList = ["Apple Pay", "Wire Transfer", "Google Pay"];

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController noteToSellerController = TextEditingController();


  OrderNowScreen({
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.selectedCartIDs,
  });


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Order Now"
        ),
        titleSpacing: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white70,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        child: ListView(
          children: [

            //display selected items from cart list
            displaySelectedItemsFromUserCart(),

            const SizedBox(height: 30),

            //delivery system
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Dịch vụ giao hàng:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: deliverySystemNamesList.map((deliverySystemName)
                {
                  return Obx(()=>
                      RadioListTile<String>(
                        tileColor: Colors.black26,
                        dense: true,
                        activeColor: Colors.purpleAccent,
                        title: Text(
                          deliverySystemName,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        value: deliverySystemName,
                        groupValue: orderNowController.deliverySys,
                        onChanged: (newDeliverySystemValue)
                        {
                          orderNowController.setDeliverySystem(newDeliverySystemValue!);
                        },
                      )
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            //payment system
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Dịch vụ thanh toán:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 2),

                  Text(
                    'Số Tài Khoản / ID: \nY87Y-HJF9-CVBN-4321',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: paymentSystemNamesList.map((paymentSystemName)
                {
                  return Obx(()=>
                      RadioListTile<String>(
                        tileColor: Colors.black26,
                        dense: true,
                        activeColor: Colors.purpleAccent,
                        title: Text(
                          paymentSystemName,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        value: paymentSystemName,
                        groupValue: orderNowController.paymentSys,
                        onChanged: (newPaymentSystemValue)
                        {
                          orderNowController.setPaymentSystem(newPaymentSystemValue!);
                        },
                      )
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            //phone number
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Số điện thoại:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                style: const TextStyle(
                    color: Colors.black
                ),
                controller: phoneNumberController,
                decoration: InputDecoration(
                  hintText: 'số liên lạc..',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            //shipment address
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Địa chỉ giao hàng:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                style: const TextStyle(
                    color: Colors.black
                ),
                controller: shipmentAddressController,
                decoration: InputDecoration(
                  hintText: 'Địa chỉ giao hàng của bạn..',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            //note to seller
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Lưu ý cho người bán:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                style: const TextStyle(
                    color: Colors.black
                ),
                controller: noteToSellerController,
                decoration: InputDecoration(
                  hintText: 'Lưu ý bạn muốn viết cho người bán..',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            //pay amount now btn
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: ()
                  {
                    if(phoneNumberController.text.isNotEmpty && shipmentAddressController.text.isNotEmpty)
                    {
                      Get.to(OrderConfirmationScreen(
                        selectedCartIDs: selectedCartIDs,
                        selectedCartListItemsInfo: selectedCartListItemsInfo,
                        totalAmount: totalAmount,
                        deliverySystem: orderNowController.deliverySys,
                        paymentSystem: orderNowController.paymentSys,
                        phoneNumber: phoneNumberController.text,
                        shipmentAddress: shipmentAddressController.text,
                        note: noteToSellerController.text,
                      ));
                    }
                    else
                    {
                      Fluttertoast.showToast(msg: "Vui lòng hoàn thành biểu mẫu.");
                    }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [

                        Text(
                          totalAmount!.toStringAsFixed(2) + " đ",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Spacer(),

                        const Text(
                          "Thanh Toán Ngay",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }

  displaySelectedItemsFromUserCart()
  {
    return Column(
      children: List.generate(selectedCartListItemsInfo!.length, (index)
      {
        Map<String, dynamic> eachSelectedItem = selectedCartListItemsInfo![index];

        return Container(
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 16 : 8,
            16,
            index == selectedCartListItemsInfo!.length - 1 ? 16 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow:
            const [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 6,
                color: Colors.black38,
              ),
            ],
          ),
          child: Row(
            children: [

              //image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: FadeInImage(
                  height: 150,
                  width: 130,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage("images/place_holder.png"),
                  image: NetworkImage(
                    eachSelectedItem["image"],
                  ),
                  imageErrorBuilder: (context, error, stackTraceError)
                  {
                    return const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                      ),
                    );
                  },
                ),
              ),

              //name
              //size
              //price
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //name
                      Text(
                        eachSelectedItem["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      //size + color
                      Text(
                        eachSelectedItem["color"].replaceAll("[", "").replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      //price
                      Text(
                        eachSelectedItem["totalAmount"].toString() + " đ",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                          eachSelectedItem["price"].toString() + " x "
                              + eachSelectedItem["quantity"].toString()
                              + " = " + eachSelectedItem["totalAmount"].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),


                    ],
                  ),
                ),
              ),

              //quantity
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Q: " + eachSelectedItem["quantity"].toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),


            ],
          ),
        );
      }),
    );
  }
}
