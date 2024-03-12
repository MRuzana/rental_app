import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/db/functions/bill_functions.dart';
import 'package:rental_app/db/model/cart_model.dart';
import 'package:rental_app/screens/bills/bill_details.dart';
import 'package:rental_app/db/model/customer_details_model.dart';
import 'package:rental_app/widget/button_widget.dart';
import 'package:rental_app/widget/text_form_widget.dart';
import 'package:rental_app/widget/textform_calender_widget.dart';

class CustomerInfo extends StatefulWidget {
  final double sum;
  final List<CartModel>cartItems;

  const CustomerInfo({super.key,required this.cartItems,required this.sum});
 
  @override
  State<CustomerInfo> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController=TextEditingController();
  final _customerAddressController=TextEditingController();
  final _customerPlaceController=TextEditingController();
  final _customerMobileController=TextEditingController();
  final _eventDateController=TextEditingController();
   Widget divider = const SizedBox(height: 10);
  
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
     // backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 206, 242, 242),    
        title: const Center(child: Text('Customer Details')),        
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [                 
                  textField(
                    controller: _customerNameController,
                    keyboardType: TextInputType.name,
                    hintText: 'Name',        
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Customer name should not be empty';
                      }
                      else{
                        return null;
                      }              
                    }),

                    divider,             
                    textField(
                    controller:  _customerAddressController,
                    keyboardType: TextInputType.multiline,
                    hintText: 'Address',    
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Address should not be empty';
                      }
                      else{
                        return null;
                      }             
                    }),
                    divider,
              
                    textField(
                    controller: _customerPlaceController,
                    keyboardType: TextInputType.name,
                    hintText: 'Place',  
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Place should not be empty';
                      }
                      else{
                        return null;
                      }            
                    }),
                    divider,
              
                    textField(                     
                    controller: _customerMobileController,
                    keyboardType: TextInputType.number,                   
                    hintText: 'Mobile no', 
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Mobile number should not be empty';
                      }
                      else if(!RegExp(r"^(?:\+91)?[0-9]{10}$").hasMatch(value)) {
                        return 'Enter valid mobile number';
                      }
                      else{
                        return null;
                      }             
                    }),
                    divider,
              
                    textFormCalender(
                      controller: _eventDateController, 
                      onTapCaleneder: ()async{
                      DateTime? pickedDate = await showDatePicker(context: context,
                        initialDate: DateTime.now(),
                        firstDate:DateTime(2001),
                         //firstDate:DateTime.now(), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101), 
                      );
                      if(pickedDate!=null){
                        String eventDate = DateFormat('MMM d, yyyy').format(pickedDate); 
                        setState(() {
                          _eventDateController.text=eventDate;
                        });
                      }
                      },
                      hinttext: 'Event date',
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return 'Event date should not be empty';
                        }
                        else{
                          return null;
                        }              
                      }), 
                      button(
                        buttonText: 'SUBMIT',
                        buttonPressed: (){
                          if(_formKey.currentState!.validate()){
                            onSubmitButtonClicked(context);
                          }
                        })                                                                                                                                                                                                                               
                ],
              ),
            ),
          ),
        )),
    );
  }
  Future<void>onSubmitButtonClicked(BuildContext context)async{
    int currentBillNo=await nextBillNo();
    final customerName=_customerNameController.text.trim();
    final customerAddress=_customerAddressController.text.trim();
    final customerPlace=_customerPlaceController.text.trim();
    final customerMobileNo=_customerMobileController.text.trim();
    final eventDate=_eventDateController.text.trim();

    if(customerName.isEmpty || customerAddress.isEmpty ||customerPlace.isEmpty || customerMobileNo.isEmpty ||eventDate.isEmpty){
      return;
    }
     final customerInfo=CustomerDetailsModel(name: customerName, address: customerAddress, place: customerPlace, mobileNo: customerMobileNo, eventDate: eventDate);
    // AddCustomerDetails(customerDetails);
    
    Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context)=> BillDetails(sum:widget.sum,eventDate: eventDate,cartItems: widget.cartItems,billNo: currentBillNo,customerdetails: customerInfo)));

  }  
}