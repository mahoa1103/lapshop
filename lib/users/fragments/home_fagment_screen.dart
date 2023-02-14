import 'dart:convert';
import 'package:appshop/users/item/search_items.dart';
import 'package:appshop/api_connection/api_connection.dart';
import 'package:appshop/users/cart/cart_list_screen.dart';
import 'package:appshop/users/item/items_details_screen.dart';
import 'package:appshop/users/model/laptops.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomeFragmentScreen extends StatelessWidget
{
  TextEditingController searchController = TextEditingController();

  Future<List<Laptops>> getTrendingLaptopItem() async
  {
    List<Laptops> trendingItemList = [];

    try
    {
      var res = await http.post(
        Uri.parse(API.getTrendingItem)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfTrending = jsonDecode(res.body);
        if(responseBodyOfTrending["success"] == true)
        {
          (responseBodyOfTrending["itemData"] as List).forEach((eachRecord)
          {
            trendingItemList.add(Laptops.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(e)
    {
      print("Error1 :: " + e.toString());
    }

    return trendingItemList;
  }

  Future<List<Laptops>> getAllLaptopItem() async
  {
    List<Laptops> allItemList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.getAllItem)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfAllItems = jsonDecode(res.body);
        if(responseBodyOfAllItems["success"] == true)
        {
          (responseBodyOfAllItems["itemData"] as List).forEach((eachRecord)
          {
            allItemList.add(Laptops.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(e)
    {
      print("Error1 :: " + e.toString());
    }

    return allItemList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white70,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16,),

            //search bar
            showSearchBarWidget(),

            const SizedBox(height: 24,),

            //trending item
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Thịnh Hành",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            trendingLaptopItemWidget(context),

            const SizedBox(height: 24,),

            //all new collection/item
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Sản Phẩm Mới Nhất",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            allItemsWidget(context),

          ],
        ),
      ),
    );
  }

  Widget showSearchBarWidget()
  {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {
              Get.to(SearchItems(typedKeyWords: searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.deepPurple,
            ),
          ),
          hintText: "Tìm Laptop theo tên...",
          hintStyle: const TextStyle(
           color: Colors.black38,
           fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: ()
            {
              Get.to(CartListScreen());
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.deepPurple,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.blue,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.deepPurpleAccent,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget trendingLaptopItemWidget(context)
  {
    return FutureBuilder(
      future: getTrendingLaptopItem(),
      builder: (context, AsyncSnapshot<List<Laptops>> dataSnapshot)
      {
        if(dataSnapshot.connectionState == ConnectionState.waiting)
        {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(dataSnapshot.data == null)
        {
          return const Center(
            child: Text(
              "No Trending Item Found",
            ),
          );
        }
        if(dataSnapshot.data!.length > 0)
        {
          return Container(
            height: 260,
            child: ListView.builder(
              itemCount: dataSnapshot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index)
              {
                Laptops eachLaptopItemData = dataSnapshot.data![index];
                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(ItemDetailScreen(itemInfo: eachLaptopItemData));
                  },
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.fromLTRB(
                      index == 0 ? 16 : 8,
                      10,
                      index == dataSnapshot.data!.length - 1 ? 16 : 8,
                      10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black26,
                      boxShadow:const [
                        BoxShadow(
                          offset: Offset(0, -3),
                          blurRadius: 6,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        //item image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),
                          child: FadeInImage(
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage("images/Placeholder.png"),
                            image: NetworkImage(
                              eachLaptopItemData.image!,
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

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              //name and price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      eachLaptopItemData.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    eachLaptopItemData.price.toString() + " đ",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8,),

                              //rating stars and rating number
                              Row(
                                children: [

                                  //rating stars
                                  RatingBar.builder(
                                    initialRating: eachLaptopItemData.rating!,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemBuilder: (context, c)=> const Icon(
                                      Icons.star,
                                      color: Colors.amberAccent,
                                    ),
                                    onRatingUpdate: (updateRating){},
                                    ignoreGestures: true,
                                    unratedColor: Colors.white,
                                    itemSize: 20,
                                  ),

                                  const SizedBox(width: 8,),

                                  //rating number
                                  Text(
                                    "(" + eachLaptopItemData.rating.toString() + ")",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        else
        {
          return const Center(
            child: Text("Empty, No data."),
          );
        }
      },
    );
  }

  Widget allItemsWidget(context)
  {
    return FutureBuilder(
      future: getAllLaptopItem(),
      builder: (context, AsyncSnapshot<List<Laptops>> dataSnapshot)
      {
        if(dataSnapshot.connectionState == ConnectionState.waiting)
        {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(dataSnapshot.data == null)
        {
          return const Center(
            child: Text(
              "No New Item Found",
            ),
          );
        }
        if(dataSnapshot.data!.isNotEmpty)
        {
          return ListView.builder(
            itemCount: dataSnapshot.data!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index)
            {
              Laptops eachLaptopItemRecord = dataSnapshot.data![index];
              return GestureDetector(
                onTap: ()
                {
                  Get.to(ItemDetailScreen(itemInfo: eachLaptopItemRecord));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == dataSnapshot.data!.length - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black26,
                    boxShadow:const [
                      BoxShadow(
                        offset: Offset(0,0),
                        blurRadius: 6,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [

                      //name and price + tags
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              //name and price
                              Row(
                                children: [

                                  //name
                                  Expanded(
                                    child: Text(
                                      eachLaptopItemRecord.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  //price
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12, right: 12),
                                    child: Text(
                                      eachLaptopItemRecord.price.toString() + " đ",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16,),

                              //tags
                              Text(
                                "Tags :\n" + eachLaptopItemRecord.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                      //image laptop
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: FadeInImage(
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                          placeholder: const AssetImage("images/Placeholder.png"),
                          image: NetworkImage(
                            eachLaptopItemRecord.image!,
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
              );
            },
          );
        }
        else
        {
          return const Center(
            child: Text("Empty, No data."),
          );
        }
      },
    );
  }
}
