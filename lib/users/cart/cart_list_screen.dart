import 'package:appshop/api_connection/api_connection.dart';
import 'package:appshop/users/controller/cart_list_controller.dart';
import 'package:appshop/users/item/items_details_screen.dart';
import 'package:appshop/users/model/cart.dart';
import 'package:appshop/users/model/laptops.dart';
import 'package:appshop/users/model/userPreferences/current_user.dart';
import 'package:appshop/users/order/order_now_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartListScreen extends StatefulWidget
{


  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen>
{
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async
  {
    List<Cart> cartListOfCurrentUser = [];

    try
    {
      var res = await http.post(
        Uri.parse(API.getCartList),
        body:
        {
          "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
        }
      );

      if(res.statusCode == 200) // connection with api to server - success
      {
        var resBodyOfCurrentUserCartItem = jsonDecode(res.body);

        if(resBodyOfCurrentUserCartItem['success'] == true)
        {
          (resBodyOfCurrentUserCartItem['currentUserCartData'] as List).forEach((eachCurrentUserCartItem)
          {
            cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItem));
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Error,Occurred while executing query");
        }

        cartListController.setList(cartListOfCurrentUser);
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(e)
    {
      Fluttertoast.showToast(msg: "Error cart1 :: " + e.toString());
    }
    calculateTotalAmount();
  }

  calculateTotalAmount()
  {
    cartListController.setTotal(0);

    if(cartListController.seclectItemList.length > 0)
    {
      cartListController.cartList.forEach((itemInCart)
      {
        if(cartListController.seclectItemList.contains(itemInCart.cart_id))
        {
          double eachItemTotalAmount = (itemInCart.price!) * (double.parse(itemInCart.quantity.toString()));


          cartListController.setTotal(cartListController.total + eachItemTotalAmount);
        }
      });
    }
  }

  deleteItemToCartList(int cartId) async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.deleteToCart),
        body:
        {
          "cart_id" : cartId.toString(),
        }
      );

      if(res.statusCode == 200)
      {
        var resBodyFromDeleteCart = jsonDecode(res.body);
        if(resBodyFromDeleteCart["success"] == true)
        {
          getCurrentUserCartList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }

    }
    catch(e)
    {
      Fluttertoast.showToast(msg: "Error delete :: "+ e.toString());
      print("Error delete :: "+ e.toString());
    }
  }

  updateQuantityInUserCart(int cartId, int updateQuantity) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(API.updateToCart),
          body:
          {
            "cart_id" : cartId.toString(),
            "quantity" : updateQuantity.toString(),
          }
      );

      if(res.statusCode == 200)
      {
        var resBodyFromUpdateCart = jsonDecode(res.body);
        if(resBodyFromUpdateCart["success"] == true)
        {
          getCurrentUserCartList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }

    }
    catch(e)
    {
      Fluttertoast.showToast(msg: "Error update :: "+ e.toString());
      print("Error update :: "+ e.toString());
    }
  }

  List<Map<String, dynamic>> getSelectedCartListItemsInformation()
  {
    List<Map<String, dynamic>> selectedCartListItemsInformation = [];

    if(cartListController.seclectItemList.length > 0)
    {
      cartListController.cartList.forEach((selectedCartListItem)
      {
        if(cartListController.seclectItemList.contains(selectedCartListItem.cart_id))
        {
          Map<String, dynamic> itemInformation =
          {
            "item_id": selectedCartListItem.item_id,
            "name": selectedCartListItem.name,
            'image': selectedCartListItem.image,
            'color': selectedCartListItem.color,
            'size': selectedCartListItem.size,
            'quantity': selectedCartListItem.quantity,
            'totalAmount': selectedCartListItem.price! * selectedCartListItem.quantity!,
            'price': selectedCartListItem.price!,
          };

          selectedCartListItemsInformation.add(itemInformation);
        }
      });
    }

    return selectedCartListItemsInformation;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "My Cart",
        ),
        actions: [
          Obx(() =>
              //To select all item
              IconButton(
                  onPressed: ()
                  {
                    cartListController.setIsSelectAll();
                    cartListController.clearSelectItem();

                    if(cartListController.isSelectAll)
                    {
                      cartListController.cartList.forEach((eachItem)
                      {
                        cartListController.addSelectItem(eachItem.cart_id!);
                      });
                    }

                    calculateTotalAmount();
                  },
                  icon: Icon(
                    cartListController.isSelectAll ? Icons.check_box : Icons.check_box_outline_blank,
                    color: cartListController.isSelectAll ? Colors.white: Colors.grey,
                  )
              ),
          ),

          // delete select item
          GetBuilder(
            init: CartListController(),
            builder: (c)
            {
              if(cartListController.seclectItemList.length > 0)
              {
                return IconButton(
                    onPressed: () async
                    {
                      var responseFormDiablogBox = await Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.grey,
                          title: const Text("Xóa"),
                          content: const Text("Bạn có chắc chắn Xóa các mục đã chọn khỏi danh sách Giỏ hàng của mình không?"),
                          actions:
                          [
                            TextButton(
                                onPressed: ()
                                {
                                  Get.back();
                                },
                                child: const Text(
                                  "Không",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                            ),

                            TextButton(
                              onPressed: ()
                              {
                                Get.back(result: "yesDelete");
                              },
                              child: const Text(
                                "Có",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if(responseFormDiablogBox == "yesDelete")
                      {
                        cartListController.seclectItemList.forEach((eachSelectCartID)
                        {
                          //delete select item now
                          deleteItemToCartList(eachSelectCartID);
                        });
                      }

                      calculateTotalAmount();
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      size: 20,
                      color: Colors.redAccent,
                    )
                );
              }
              else
              {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Obx(()=>
          cartListController.cartList.length > 0
              ? ListView.builder(
                  itemCount: cartListController.cartList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index)
                  {
                    Cart cartModel =  cartListController.cartList[index];

                    Laptops laptopsModel = Laptops(
                      item_id: cartModel.item_id,
                      colors: cartModel.colors,
                      image: cartModel.image,
                      name: cartModel.name,
                      price: cartModel.price,
                      rating: cartModel.rating,
                      sizes: cartModel.sizes,
                      description: cartModel.description,
                      tags: cartModel.tags,
                    );

                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [

                          //check box
                          GetBuilder(
                            init: CartListController(),
                            builder: (c)
                            {
                              return IconButton(
                                  onPressed: ()
                                  {
                                    if(cartListController.seclectItemList.contains(cartModel.cart_id))
                                    {
                                      cartListController.deleteSelectItem(cartModel.cart_id!);
                                    }
                                    else
                                    {
                                      cartListController.addSelectItem(cartModel.cart_id!);
                                    }

                                    calculateTotalAmount();
                                  },
                                  icon: Icon(
                                    cartListController.seclectItemList.contains(cartModel.cart_id) ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: cartListController.isSelectAll ? Colors.deepPurpleAccent : Colors.deepPurple,
                                  ),
                              );
                            },
                          ),

                          //name
                          //color size + price
                          //quantity +/-
                          //image
                          Expanded(
                            child: GestureDetector(
                              onTap: ()
                              {
                                Get.to(ItemDetailScreen(itemInfo: laptopsModel));
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                  0,
                                  index == 0 ? 16 : 8,
                                  16,
                                  index == cartListController.cartList.length - 1 ? 16 : 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 6,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [

                                    //name
                                    //color size + price
                                    //quantity +/-
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            //name
                                            Text(
                                              laptopsModel.name.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.deepPurple,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(height: 20,),

                                            //color size + price
                                            Row(
                                              children: [

                                                //color size
                                                Expanded(
                                                  child: Text(
                                                    "Màu : ${cartModel.color!.replaceAll('[', '').replaceAll(']', '')}",
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),

                                                //price
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8, right: 8),
                                                  child: Text(
                                                    laptopsModel.price.toString() + " đ",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blueAccent,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 20,),

                                            //quantity +/-
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: ()
                                                  {
                                                    if(cartModel.quantity! - 1 >= 1)
                                                    {
                                                      updateQuantityInUserCart(
                                                        cartModel.cart_id!,
                                                        cartModel.quantity! - 1,
                                                      );
                                                    }
                                                  },
                                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.black,size: 30,),
                                                ),

                                                const SizedBox(width: 10,),

                                                Text(
                                                  cartModel.quantity.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.blueAccent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(width: 10,),

                                                IconButton(
                                                  onPressed: ()
                                                  {
                                                    updateQuantityInUserCart(
                                                      cartModel.cart_id!,
                                                      cartModel.quantity! + 1,
                                                    );
                                                  },
                                                  icon: const Icon(Icons.add_circle_outline, color: Colors.black,size: 30,),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    //image
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      child: FadeInImage(
                                        height: 188,
                                        width: 155,
                                        fit: BoxFit.cover,
                                        placeholder: const AssetImage("images/Placeholder.png"),
                                        image: NetworkImage(
                                          cartModel.image!,
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

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("Cart is Emty"),
                ),
      ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c)
        {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white24,
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [

                //Total Amount
                const Text(
                  "Total Amount: ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 4,),

                Obx(() =>
                  Text(
                    cartListController.total.toStringAsFixed(2) + " đ",
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                //oder now btn
                Material(
                  color: cartListController.seclectItemList.length > 0
                      ? Colors.deepPurpleAccent : Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: ()
                    {
                      cartListController.seclectItemList.length > 0
                          ? Get.to(OrderNowScreen(
                        selectedCartListItemsInfo: getSelectedCartListItemsInformation(),
                        totalAmount: cartListController.total,
                        selectedCartIDs: cartListController.seclectItemList,
                      ))
                          : null;
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        "Đơn Hàng",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      ),

    );
  }
}
