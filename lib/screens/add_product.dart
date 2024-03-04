import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rental_app/db/functions/product_fuctions.dart';
import 'package:rental_app/widget/button_widget.dart';
import 'package:rental_app/widget/image_selection_widget.dart';
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
  String selectedValue = '';
  String imgPath = '';
  Widget divider = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor: const Color(0xff8ECFCB),
        title: const Center(child: Text('Add Product')),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                ImageSelectionWidget(
                  onImageSelected:
                      (File? pickedImage, String? pickedImagePath) {
                    imgPath = pickedImagePath!;
                    //print('Image selected: $pickedImage, Image path: $pickedImagePath');
                  },
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
                    }),
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
                    }),
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
                    }),
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

  Future<void> onSubmitButtonClicked(BuildContext context) async {
    final itemName = _productNameController.text.trim();
    final itemPrice = _productPriceController.text.trim();
    final itemDetails = _productDetailsController.text.trim();
    final itemCategory = selectedValue.trim();
    final imagePath = imgPath;
    print('image path is $imgPath');

    if (itemName.isEmpty ||
        itemPrice.isEmpty ||
        itemDetails.isEmpty ||
        itemCategory.isEmpty ||
        imgPath.isEmpty) {
      return;
    }

    final product = AddProductmodel(
        name: itemName,
        price: itemPrice,
        category: itemCategory,
        details: itemDetails,
        imagePath: imagePath);
    addProduct(product);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
