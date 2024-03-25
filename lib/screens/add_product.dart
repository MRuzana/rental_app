import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_app/db/functions/product_fuctions.dart';
import 'package:rental_app/widget/button_widget.dart';
import 'package:rental_app/widget/drop_down_widget.dart';
import 'package:rental_app/screens/home_screen.dart';
import 'package:rental_app/db/model/add_product_model.dart';
import 'package:rental_app/widget/text_form_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productDetailsController = TextEditingController();
  final _quantityController = TextEditingController();
  String selectedValue = '';
  Widget divider = const SizedBox(height: 10);
  final ImagePicker _imagePicker = ImagePicker();
  File? pickedImage;
  late XFile? pickedFile;
  PlatformFile? _imagefile;
  FilePickerResult? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 206, 242, 242),
        title: const Center(child: Text('Add Product')),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (kIsWeb) {
                      pickimage();
                    }
                    if (!kIsWeb) {
                      pickedFile = await _imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          pickedImage = File(pickedFile!.path);
                        });
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        shape:
                            BoxShape.circle, 
                        color: Colors.black, 
                      ),
                      child: ClipOval(              
                        child: kIsWeb
                            ? _imagefile != null
                                ? Image.memory(
                                  width: 150,
                                  height: 150,fit: BoxFit.cover,
                                  Uint8List.fromList(_imagefile!.bytes!))
                                : Image.asset('assets/images/logo.png',width: 150,height: 150,fit: BoxFit.cover,)
                            : pickedImage != null
                                ? Image.file(pickedImage!,width: 150,height: 150,fit: BoxFit.cover,)
                                : Image.asset('assets/images/logo.png',width: 150,height: 150,fit: BoxFit.cover,)
                      ),
                    ),
                  ),        
                ),
                textField(
                    controller: _productNameController,
                    keyboardType: TextInputType.name,
                    hintText: 'Product name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product name should not be empty';
                      } else {
                        return null;
                      }
                    
                    },
                    autovalidateMode: AutovalidateMode.always,
                   
                ),
                divider,
                textField(
                    controller: _productPriceController,
                    keyboardType: TextInputType.number,
                    hintText: 'Price',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price should not be empty';
                      } else if (!RegExp(r'^\d+(\.\d{1,2})?$')
                          .hasMatch(value)) {
                        return 'Enter valid price';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.always,),
                divider,
                textField(
                    controller: _productDetailsController,
                    keyboardType: TextInputType.multiline,
                    hintText: 'Product Details',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product details should not be empty';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.always,
                  ),
                divider,
                textField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    hintText: 'Quantity',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Quantity should not be empty';
                      }else if (!RegExp(r'^[1-9]\d*$')
                        .hasMatch(value)) {
                        return 'Enter valid quantity ';
                      } 
                      else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.always,
                  ),
                divider,
                DropdownWidget(
                  onItemSelected: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
                button(
                    buttonText: 'SUBMIT',
                    buttonPressed: () {
                      if (_formKey.currentState!.validate()) {
                        onSubmitButtonClicked(context);
                      }
                    }),
              ],
            )),
      )),
    );
  }

  Future<void> pickimage() async {
    try {
      result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result == null) return;

      if (result != null) {
        setState(() {
          _imagefile = result!.files.first;
        });
      }
    } catch (e) {
       print(e);
    }
  }

  Future<void> onSubmitButtonClicked(BuildContext context) async {
    final itemName = _productNameController.text.trim();
    final itemPrice = _productPriceController.text.trim();
    final itemDetails = _productDetailsController.text.trim();
    final itemQuantity = _quantityController.text.trim();
    final itemCategory = selectedValue.trim();

    String? imagePath;
    if (kIsWeb) {
      Uint8List? bytes =
          result!.files.single.bytes; // Access bytes asynchronously
      String base64Image = base64Encode(bytes!);
      imagePath = 'data:image/jpeg;base64,$base64Image';
    } else {
      // For non-web platforms, use pickedImage path
      imagePath = pickedImage!.path;
    }

    if (itemName.isEmpty ||
        itemPrice.isEmpty ||
        itemDetails.isEmpty ||
        itemCategory.isEmpty ||
        itemQuantity.isEmpty ||
        imagePath.isEmpty) {
      return;
    }

    final product = AddProductmodel(
        name: itemName,
        price: itemPrice,
        category: itemCategory,
        details: itemDetails,
        stockNumber: int.parse(itemQuantity),
        imagePath: imagePath);

    addProduct(product);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
