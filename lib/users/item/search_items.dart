import 'dart:convert';

import 'package:appshop/users/model/laptops.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../api_connection/api_connection.dart';
import '../cart/cart_list_screen.dart';
import 'package:http/http.dart' as http;

import 'items_details_screen.dart';


class SearchItems extends StatefulWidget
{
  final String? typedKeyWords;

  SearchItems({this.typedKeyWords,});

  @override
  State<SearchItems> createState() => _SearchItemsState();
}



class _SearchItemsState extends State<SearchItems>
{
  TextEditingController searchController = TextEditingController();


  Future<List<Laptops>> readSearchRecordsFound() async
  {
    List<Laptops> clothesSearchList = [];

    if(searchController.text != "")
    {
      try
      {
        var res = await http.post(
            Uri.parse(API.searchItems),
            body:
            {
              "typedKeyWords": searchController.text,
            }
        );

        if (res.statusCode == 200)
        {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          if (responseBodyOfSearchItems['success'] == true)
          {
            (responseBodyOfSearchItems['itemsFoundData'] as List).forEach((eachItemData)
            {
              clothesSearchList.add(Laptops.fromJson(eachItemData));
            });
          }
        }
        else
        {
          Fluttertoast.showToast(msg: "Status Code is not 200");
        }
      }
      catch(errorMsg)
      {
        Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
      }
    }

    return clothesSearchList;
  }

  @override
  void initState()
  {
    super.initState();

    searchController.text = widget.typedKeyWords!;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: ()
          {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: searchItemDesignWidget(context),
    );
  }

  Widget showSearchBarWidget()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {
              setState(() {
              });
            },
            icon: const Icon(
              Icons.search,
              color: Colors.deepPurple,
            ),
          ),
          hintText: "Tìm kiếm laptop theo tên...",
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: ()
            {
              searchController.clear();

              setState(() {
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.redAccent,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.deepPurple,
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

  searchItemDesignWidget(context)
  {
    return FutureBuilder(
        future: readSearchRecordsFound(),
        builder: (context, AsyncSnapshot<List<Laptops>> dataSnapShot)
        {
          if(dataSnapShot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(dataSnapShot.data == null)
          {
            return const Center(
              child: Text(
                "No Trending item found",
              ),
            );
          }
          if(dataSnapShot.data!.isNotEmpty)
          {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index)
              {
                Laptops eachClothItemRecord = dataSnapShot.data![index];

                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(ItemDetailScreen(itemInfo: eachClothItemRecord));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      16,
                      index == 0 ? 16 : 8,
                      16,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black38,
                      boxShadow:
                      const [
                        BoxShadow(
                          offset: Offset(0,0),
                          blurRadius: 6,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [

                        //name + price
                        //tags
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
                                        eachClothItemRecord.name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    //price
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 12),
                                      child: Text(
                                        eachClothItemRecord.price.toString() + " đ",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                                const SizedBox(height: 16,),

                                //tags
                                Text(
                                  "Tags: \n" + eachClothItemRecord.tags.toString().replaceAll("[", "").replaceAll("]", ""),
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

                        //image clothes
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: FadeInImage(
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage("images/place_holder.png"),
                            image: NetworkImage(
                              eachClothItemRecord.image!,
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
              child: Text("Empty, No Data."),
            );
          }
        }
    );
  }
}
