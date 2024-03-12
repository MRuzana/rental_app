import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_app/db/functions/product_fuctions.dart';
import 'package:rental_app/widget/button_widget.dart';
import 'package:rental_app/widget/drop_down_widget.dart';
import 'package:rental_app/screens/home_screen.dart';
import 'package:rental_app/db/model/add_product_model.dart';
import 'package:rental_app/widget/text_form_widget.dart';

class EditProduct extends StatefulWidget {
 final AddProductmodel addProductModel; 
 const EditProduct({super.key, required this.addProductModel});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  final _formKey = GlobalKey<FormState>();
  final _productNameController=TextEditingController();
  final _productPriceController=TextEditingController();
  final _productDetailsController=TextEditingController();
  String selectedValue='';
  String imgPath='';
  final ImagePicker _imagePicker = ImagePicker();
  File? pickedImage;
  String pickedImagePath='';


@override
  void initState() {
   super.initState();
    _productNameController.text=widget.addProductModel.name;
    _productPriceController.text=widget.addProductModel.price;
    _productDetailsController.text=widget.addProductModel.details;
    selectedValue=widget.addProductModel.category;   
    imgPath=widget.addProductModel.imagePath;
    print('Image Path: $imgPath');
  
  }

  @override
  void dispose() {
 
    _productNameController.dispose();
    _productPriceController.dispose();
    _productDetailsController.dispose();
    super.dispose();
  }
 @override
  Widget build(BuildContext context) {
    int id = widget.addProductModel.id!;
    return Scaffold(
      //backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 206, 242, 242),    
        title: const Center(child: Text('Edit Product')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:  Column(
              children: [
                
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20 ),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: pickedImage!=null?
                      FileImage(File(pickedImagePath)):
                      FileImage(File(imgPath))
                    ),
                  ), 
                ),
                textField(
                controller: _productNameController,
                keyboardType: TextInputType.name,
                hintText: 'Item name', 
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Product name should not be empty';
                  }
                  else{
                    return null;
                  }
                }),

              const SizedBox(height: 15),
              textField(
                controller: _productPriceController,
                keyboardType: TextInputType.number,
                hintText: 'Price',
                validator: (value){
                  if(value==null || value.isEmpty){
                   return 'Price should not be empty';
                  }
                  else if(!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)){
                    return 'Enter valid price';
                  }
                  else{
                    return null;
                  }
                }),

              const SizedBox(height: 15),
              textField(
                controller:  _productDetailsController,
                keyboardType: TextInputType.multiline,               
                hintText: 'Product Details',
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Product details should not be empty';
                  }
                  else{
                    return null;
                  }
                }),                                                                             
            const SizedBox(height: 15),

          DropdownWidget(
            onItemSelected: (value) {
              setState(() {
                selectedValue = value;  
              });
            },            
          ),
          button(
            buttonText: 'UPDATE',
            buttonPressed: (){
              if(_formKey.currentState!.validate()){
                onUpdateButtonClicked(context,id);
              }
            })                      
        ],
       )
      ),

    )
   
    ),
  );     
}

pickImage()async {
  final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
   if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
        pickedImagePath = pickedFile.path;
        print('picked $pickedImagePath');
      });   
    }
}
  Future <void>onUpdateButtonClicked(BuildContext context,int id)async{
  
  final itemName=_productNameController.text.trim();
  final itemPrice=_productPriceController.text.trim();
  final itemDetails=_productDetailsController.text.trim();
  final itemCategory=selectedValue.trim();
  final String imagePath;
  if(pickedImage==null){
   imagePath=imgPath;
  }
  else{
    imagePath=pickedImagePath;
  }
 // final imagePath=pickedImagePath;
  if(itemName.isEmpty||itemPrice.isEmpty||itemDetails.isEmpty||itemCategory.isEmpty||imagePath.isEmpty){
    return;
  }
 
  final updatedProduct=AddProductmodel(id: id, name: itemName, price: itemPrice, category: itemCategory, details: itemDetails, imagePath: imagePath);
  await editProduct(updatedProduct,id);
  //(mounted){
   
     Navigator.of(context).pushReplacement(MaterialPageRoute(
   builder: (context)=> const HomeScreen()));
//  };

  }
}

