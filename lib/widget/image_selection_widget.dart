import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImageSelectionWidget extends StatefulWidget {
  final void Function(File?, String?) onImageSelected;
  const ImageSelectionWidget({super.key, required this.onImageSelected});
 
  @override
  State<ImageSelectionWidget> createState() => _ImageSelectionWidgetState();
}

class _ImageSelectionWidgetState extends State<ImageSelectionWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  File? pickedImage;
  String pickedImagePath='';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
          
      child: GestureDetector(
        onTap: () {
          pickImage();
        },
        child: CircleAvatar(
          radius: 100,
          backgroundImage: pickedImage!=null
          ?FileImage(pickedImage!) as ImageProvider
          :const AssetImage('assets/images/logo.png'),
          backgroundColor: Colors.black,          
        ),
        
      ),    
    );     
  }

pickImage()async {
 
  final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
   if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
        pickedImagePath = pickedFile.path;
      });

    widget.onImageSelected(pickedImage, pickedImagePath);  
    }
  //  else{       
  //   return null;
  //  }
  }
  
}