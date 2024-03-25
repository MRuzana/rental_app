import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_app/db/functions/product_fuctions.dart';
import 'package:rental_app/widget/button_widget.dart';
import 'package:rental_app/widget/drop_down_widget.dart';
import 'package:rental_app/screens/home_screen.dart';
import 'package:rental_app/db/model/add_product_model.dart';
import 'package:rental_app/widget/text_form_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  final _stockController=TextEditingController();
  String selectedValue='';
  String imgPath='';
  final ImagePicker _imagePicker = ImagePicker();
  File? pickedImage;
  FilePickerResult? result;
  PlatformFile? _imagefile;
  late XFile? pickedFile;

@override
  void initState() {
   super.initState();
    _productNameController.text=widget.addProductModel.name;
    _productPriceController.text=widget.addProductModel.price;
    _productDetailsController.text=widget.addProductModel.details;
    _stockController.text=widget.addProductModel.stockNumber.toString();
    selectedValue=widget.addProductModel.category;   
    imgPath=widget.addProductModel.imagePath;
   

    if (imgPath.isNotEmpty) {
    if (kIsWeb) {
      // For web platform
      String base64Image = imgPath.split(',').last;
       Uint8List bytes = base64Decode(base64Image);
      setState(() {
       _imagefile = PlatformFile(name: 'image.jpg', bytes: bytes, size: imgPath.length);
      });
    } else {
      // For mobile platforms
      setState(() {
        pickedImage = File(imgPath);
      });
    }
  } else {
    // If imgPath is empty, you might want to set a default image or do nothing.
    // For example:
    // pickedImage = File('assets/default_image.png');
    // OR you can leave it as it is if you want to show no image.
  }

}

  @override
  void dispose() {
 
    _productNameController.dispose();
    _productPriceController.dispose();
    _productDetailsController.dispose();
    _stockController.dispose();
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
                  onTap: () async{
                    if (kIsWeb) {
                      pickimage();                     
                    } 
                     if(!kIsWeb){
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
                            BoxShape.circle, // This makes the container circular
                        color: Colors
                            .black, // Background color of the circular container
                      ),
                      child: ClipOval(              
                        child: kIsWeb
                          ? _imagefile != null && _imagefile!.bytes != null
                            ? Image.memory(
                             Uint8List.fromList(_imagefile!.bytes!), // Use _imagefile!.bytes directly
                              width: 150,height: 150,fit: BoxFit.cover,)
                            : Image.asset('assets/images/logo.png',
                              width: 150,height: 150,fit: BoxFit.cover,)
                          : pickedImage != null
                            ? Image.file(pickedImage!,width: 150,height: 150,fit: BoxFit.cover,)
                            : Image.asset('assets/images/logo.png',width: 150,height: 150,fit: BoxFit.cover,),)
                                              
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
                },
                autovalidateMode: AutovalidateMode.always,
                ),

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
                },
                autovalidateMode: AutovalidateMode.always,
                ),

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
                },
                autovalidateMode: AutovalidateMode.always,
                ),                                                                             
            const SizedBox(height: 15),
            textField(
                controller:  _stockController,
                keyboardType: TextInputType.number,               
                hintText: 'Quantity',
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Quantity should not be empty';
                  }
                  else{
                    return null;
                  }
                },
                autovalidateMode: AutovalidateMode.always,
                ),                                                                             
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

Future <void>pickimage()async{
    try{
      result=await FilePicker.platform.pickFiles(
        type: FileType.image);

      if(result==null)return;
      
        if(result!=null){
          setState(() {
             _imagefile=result!.files.first;
          });
        }          
    }catch(e){
    }
  }
  Future <void>onUpdateButtonClicked(BuildContext context,int id)async{
  
  final itemName=_productNameController.text.trim();
  final itemPrice=_productPriceController.text.trim();
  final itemDetails=_productDetailsController.text.trim();
  final itemStock=int.parse(_stockController.text.trim());
  final itemCategory=selectedValue.trim();
  
  String? imagePath;
  if (kIsWeb) {
    if (result != null && result!.files.isNotEmpty) {
      Uint8List? bytes = result!.files.single.bytes; // Access bytes asynchronously
      String base64Image = base64Encode(bytes!);
      imagePath = 'data:image/jpeg;base64,$base64Image';
    }
    else{
       imagePath = pickedImage?.path ?? imgPath;
    }
   
  } else {
      // For non-web platforms, use pickedImage path
      imagePath = pickedImage!.path;
    }
  if(itemName.isEmpty||itemPrice.isEmpty||itemDetails.isEmpty||itemCategory.isEmpty||imagePath.isEmpty){
    return;
  }
 
  final updatedProduct=AddProductmodel(id: id, name: itemName, price: itemPrice, category: itemCategory, details: itemDetails, imagePath: imagePath,stockNumber: itemStock);
  await editProduct(updatedProduct,id);
  
   
     Navigator.of(context).pushReplacement(MaterialPageRoute(
   builder: (context)=> const HomeScreen()));
  

  }
}

