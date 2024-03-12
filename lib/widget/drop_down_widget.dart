import 'package:flutter/material.dart';


List<String>_category=['Bangles','Necklace','Ear rings','Rings'];

class DropdownWidget extends StatefulWidget {
  final Function(String) onItemSelected;

  const DropdownWidget({super.key, required this.onItemSelected});
  
  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();

}

class _DropdownWidgetState extends State<DropdownWidget> {

  String? dropdownValue;
  final TextEditingController _dropdownController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: DropdownButtonFormField<String>(
       value: dropdownValue ,            
        items: _category.map((String value) {
         return DropdownMenuItem<String>(
         value: value,        
         child: Text(value),);}).toList(),
      
      onChanged: (value) {
       setState(() {
        dropdownValue = value!;
       _dropdownController.clear();        
         widget.onItemSelected(dropdownValue!);
       });
       
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(                       
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none
        ),                      
        filled: true,
        fillColor: const Color.fromARGB(255, 206, 242, 242),                                                                             
        hintText: dropdownValue?.isEmpty ?? true ? 'Select Category' : null,
      ),
                                      
      validator: (value) {
       
       if(value==null || value.isEmpty){
         return 'Please Select a Category';
       }
       else
       { 
         return null;
       }
      },
    )
  );
     
  }
}