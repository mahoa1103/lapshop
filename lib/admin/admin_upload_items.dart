import 'dart:convert';
import 'dart:io';

import 'package:appshop/admin/admin_get_all_orders.dart';
import 'package:appshop/api_connection/api_connection.dart';
import 'package:appshop/users/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class AdminUploadItemScreen extends StatefulWidget
{

  @override
  State<AdminUploadItemScreen> createState() => _AdminUploadItemScreenState();
}

class _AdminUploadItemScreenState extends State<AdminUploadItemScreen>
{
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;

  var formkey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizesController = TextEditingController();
  var colorsController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";


  captureImagePhoneCamera() async
  {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    Get.back();

    setState(() => pickedImageXFile);
  }

  pickImageFormPhoneGallery() async
  {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    Get.back();

    setState(() => pickedImageXFile);
  }

  showDialogBoxForImagePicking()
  {
    return showDialog(
        context: context,
        builder: (context)
        {
          return SimpleDialog(
            backgroundColor: Colors.black,
            title: const Text(
              "Item Image",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: ()
                {
                  captureImagePhoneCamera();
                },
                child: const Text(
                  "Chụp bằng Camera",
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  pickImageFormPhoneGallery();
                },
                child: const Text(
                  "Chọn hình ảnh từ thư viện",
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  Get.back();
                },
                child: const Text(
                  "Thoát",
                  style: TextStyle(
                      color: Colors.red
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  Widget defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.deepPurple,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: ()
          {
            Get.to(AdminGetAllOrdersScreen());
          },
          child: const Text(
            "Hóa Đơn Mới Nhất",
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: ()
            {
              Get.to(LoginScreen());
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black54,
              Colors.deepPurple,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.white54,
                size: 200,
              ),

              //Button
              Material(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: ()
                  {
                    showDialogBoxForImagePicking();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 28,
                    ),
                    child: Text(
                      "Thêm Sản Phẩm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //uploadItemFormScreen Methods
  uploadItemImage() async
  {
    var requestImgurApi = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgur.com/3/image")
    );

    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " + "1ba9d21025811bf";

    var imageFile = await http.MultipartFile.fromPath(
      "image",
      pickedImageXFile!.path,
      filename: imageName,
    );

    requestImgurApi.files.add(imageFile);
    var responseFormImgurApi = await requestImgurApi.send();

    var responseDataFormImgurApi = await responseFormImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFormImgurApi);

    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();

    saveItemInfotoData();
  }

  saveItemInfotoData() async
  {
    List<String> tagsList = tagsController.text.split(',');
    List<String> sizesList = sizesController.text.split(',');
    List<String> colorsList = colorsController.text.split(',');

    try
    {
      var response = await http.post(
        Uri.parse(API.uploadNewItem),
        body:
        {
          'id': '1',
          'name': nameController.text.trim().toString(),
          'rating': ratingController.text.trim().toString(),
          'tags': tagsList.toString(),
          'price': priceController.text.trim().toString(),
          'sizes': sizesList.toString(),
          'colors': colorsList.toString(),
          'description': descriptionController.text.trim().toString(),
          'image': imageLink.toString(),

        },
      );

      if(response.statusCode == 200)
      {
        var resBodyOfUploadItem = jsonDecode(response.body);

        if(resBodyOfUploadItem['success'] == true)
        {
          Fluttertoast.showToast(msg: "New item upload sucessfully");

          setState(() {
            pickedImageXFile=null;
            nameController.clear();
            ratingController.clear();
            tagsController.clear();
            priceController.clear();
            sizesController.clear();
            colorsController.clear();
            descriptionController.clear();
          });

          Get.to(AdminUploadItemScreen());
        }
        else
        {
          Fluttertoast.showToast(msg: "Item not uploaded");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(e)
    {
      print("Error :: "+ e.toString());
    }
  }

  //uploadItemFormScreen Methods and there
  Widget uploadItemFormScreen()
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.deepPurple,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
            "Upload Form"
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: ()
          {
            setState(() {
              pickedImageXFile=null;
              nameController.clear();
              ratingController.clear();
              tagsController.clear();
              priceController.clear();
              sizesController.clear();
              colorsController.clear();
              descriptionController.clear();
            });
            Get.to(AdminUploadItemScreen());
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        actions: [
          TextButton(
              onPressed: ()
              {
                Fluttertoast.showToast(msg: "Uploading now...");

                uploadItemImage();
              },
              child: const Text(
                "Done",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
          ),
        ],
      ),

      body: ListView(
        children: [

          //image
          Container(
            height: MediaQuery.of(context).size.width * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(pickedImageXFile!.path),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //upload item form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(
                  Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child:  Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                child: Column(
                  children: [

                    //email-password-login btn
                    Form(
                      key: formkey,
                      child: Column(
                        children: [

                          //item name
                          TextFormField(
                            controller: nameController,
                            validator: (val) => val == "" ? "Please write item name": null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "item name...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding:const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //rating
                          TextFormField(
                            controller: ratingController,
                            validator: (val) => val == "" ? "Please write item rating": null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.rate_review,
                                color: Colors.black,
                              ),
                              hintText: "item rating...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding:const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //tags
                          TextFormField(
                            controller: tagsController,
                            validator: (val) => val == "" ? "Please write item tags": null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.tag,
                                color: Colors.black,
                              ),
                              hintText: "item tags...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding:const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //price
                          TextFormField(
                            controller: priceController,
                            validator: (val) => val == "" ? "Please write item price": null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.price_change_outlined,
                                color: Colors.black,
                              ),
                              hintText: "item price...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding:const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //sizes
                          TextFormField(
                            controller: sizesController,
                            validator: (val) => val == "" ? "Please write item sizes": null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.picture_in_picture,
                                color: Colors.black,
                              ),
                              hintText: "item sizes...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding:const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //color
                          TextFormField(
                            controller: colorsController,
                            validator: (val) => val == "" ? "Please write item colors": null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.color_lens,
                                color: Colors.black,
                              ),
                              hintText: "item colors...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding:const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //description
                          TextFormField(
                            controller: descriptionController,
                            validator: (val) => val == "" ? "Please write item description": null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                              hintText: "item description...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding:const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //Button
                          Material(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: ()
                              {
                                if(formkey.currentState!.validate())
                                {
                                  Fluttertoast.showToast(msg: "Uploading now...");

                                  uploadItemImage();
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28,
                                ),
                                child: Text(
                                  "Upload Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16,),

                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context)
  {
    return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen();
  }
}
