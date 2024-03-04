import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/db/functions/bill_functions.dart';
import 'package:rental_app/db/functions/cart_functions.dart';
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/db/model/cart_model.dart';
import 'package:rental_app/db/model/customer_details_model.dart';
import 'package:rental_app/widget/button_widget.dart';

class BillDetails extends StatefulWidget {
  final double sum;
  final String eventDate;
  final List<CartModel>cartItems;
  final int billNo;
  final CustomerDetailsModel customerdetails;
 
  const BillDetails({super.key,required this.sum, required this.eventDate,required this.cartItems,required this.billNo,required this.customerdetails});

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  Widget text({required String text}){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(text,                 
      style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _advanceAmountController = TextEditingController();
  final ValueNotifier<double> balanceNotifier = ValueNotifier<double>(0.0);
  late String formattedReturnDate;

  @override
  build(BuildContext context) {

    DateTime eventdate = DateFormat('dd-MM-yyyy').parse(widget.eventDate);
    DateTime returnDate = eventdate.add(const Duration(days: 3));
    formattedReturnDate = DateFormat('dd-MM-yyyy').format(returnDate);
    balanceNotifier.value = widget.sum;

    return Scaffold(
    //  backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor: const Color(0xff8ECFCB),
        title: const Center(child: Text('Bill Details')),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0 ),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30.0,),
              text(text: 'Bill No : ${widget.billNo}'),            
              const SizedBox(height: 20.0,),

              // text(text: 'Customer details'),
              // text(text: 'Name : ${customerdetails.name}'),
              // text(text: 'Address : ${customerdetails.address}'),
              // text(text: 'Place : ${customerdetails.place}'),
              // text(text: 'Mobile No : ${customerdetails.mobileNo}'),
              // text(text: 'Event date : ${customerdetails.eventDate}'),
              

              Padding(
                padding: const EdgeInsets.all(12.0 ),
                child: DataTable(
                  border: TableBorder.all(color: Colors.black),
                  columns: const [
                    DataColumn(label: Expanded(child: Text('Item')),),
                    DataColumn(label: Expanded(child: Text('Qty '))),
                    DataColumn(label: Expanded(child: Text('Unit price',overflow: TextOverflow.ellipsis,maxLines: 2,))),
                    DataColumn(label: Expanded(child: Text('Total'))),
                  ],
                  rows: widget.cartItems.map((cartItem) {
                    double price=cartItem.quantity!*double.parse(cartItem.price);                
                                    
                    return DataRow(                   
                      cells: [                    
                      DataCell(Text(cartItem.name)),
                      DataCell(Center(child: Text(cartItem.quantity.toString()))),
                      DataCell(Center(child: Text(cartItem.price))),
                      DataCell(Center(child: Text(price.toString()))),
                
                    ]);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20.0 ),
              text(text: 'Return Date : $formattedReturnDate'),              
              const SizedBox(height: 15.0 ),
              text(text: 'Total Amount : ₹${widget.sum}'),
             
              Row(
                children: [                
                 text(text: 'Advance paid : '),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: InputBorder.none
                        ),
                        controller: _advanceAmountController,
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Advance amount should not empty';
                          }                                                
                          else if (!RegExp(r"^[1-9]\d*$").hasMatch(value)) {
                            return 'Enter valid amount';
                          }
                          else if (int.parse(value) > widget.sum) {
                            return 'Advance amount not exceed total price';
                          } 
                          else{
                            return null;
                          }                                                  
                        },
                        onChanged: (value){
                          double balance = calculateBalance();
                          balanceNotifier.value = balance;
                        },
                      ),
                    ),
                  )
                ],
              ),
                       
              ValueListenableBuilder(
                valueListenable: balanceNotifier,
                builder: (context, value, child) {
                  return text(text: 'Balance Amount : ₹${balanceNotifier.value}');                 
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    button(
                      buttonText: 'OK',                     
                      buttonPressed: (){
                        if (_formKey.currentState!.validate()){
                          onOKbuttonClicked(context);                          
                        }
                      })                  
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  double calculateBalance() {
    double advance;
    if (_advanceAmountController.text.isEmpty) {
      return 0.0;
    } else {
      advance = double.parse(_advanceAmountController.text);
    }
    balanceNotifier.value = widget.sum - advance;
    return balanceNotifier.value;
  }

 Future<void>onOKbuttonClicked(BuildContext context)async{
  final currentBillNo=widget.billNo;
  final returndate=formattedReturnDate;
  final double totalAmt=widget.sum;
  final double advanceAmtPaid=double.parse(_advanceAmountController.text);
  final double balance=balanceNotifier.value;

  List<Map<String, dynamic>> cartItemData = [];
  widget.cartItems.forEach((cartItem) {
  Map<String, dynamic> itemData = {
    "name": cartItem.name,
    "quantity": cartItem.quantity,
    "unit_price": cartItem.price,
    "total_price": cartItem.quantity! * double.parse(cartItem.price),
  };
  cartItemData.add(itemData);
});
 
  final bill=BillDetailsModel(
    customerName: widget.customerdetails.name,
    customerAddress: widget.customerdetails.address,
    customerMobileNo: widget.customerdetails.mobileNo,
    customerPlace: widget.customerdetails.place,
    eventDate: widget.customerdetails.eventDate,
    billNo: currentBillNo,
    returnDate: returndate,
    totalAmount: totalAmt,
    advancePaid: advanceAmtPaid,
    balanceAmount: balance,
    cartItems: cartItemData,
  );
    addBill(bill);
    clearCart();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (HomeScreen) => false);
 }
}





