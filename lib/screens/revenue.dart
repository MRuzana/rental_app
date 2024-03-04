import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/db/functions/bill_functions.dart';
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/widget/button_widget.dart';
import 'package:rental_app/widget/textform_calender_widget.dart';

class Revenue extends StatefulWidget {
 const Revenue({super.key});
 
  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  final _formKey = GlobalKey<FormState>();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final Widget divider=const SizedBox(height: 20,);
   double totalRevenue = 0;

  @override
  void initState() {
    _fromDateController.text=DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 7)));
    _toDateController.text=DateFormat('dd-MM-yyyy').format(DateTime.now());
    fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor: const Color(0xff8ECFCB),
        title: const Center(child: Text('Revenue')),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  divider,
                  textFormCalender(
                    controller: _fromDateController,
                    onTapCaleneder: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2001),
                        // firstDate:DateTime.now(), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now()
                      );
                      if (pickedDate != null) {
                        String fromDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                        setState(() {
                          _fromDateController.text = fromDate;
                        });
                      }

                    },
                    hinttext: 'From date',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'From date should not be empty';
                      } else {
                        return null;
                      }
                    }),
                    textFormCalender(
                    controller: _toDateController,
                    onTapCaleneder: () async {
                    
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),                     
                        firstDate:DateTime(2001), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        String toDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                        setState(() {
                          _toDateController.text = toDate;
                        });
                      }                                                                                     
                    },               
                    hinttext: 'To date',
                    validator: (value) { 
                      print('value : $value');
                                  
                      if (value == null || value.isEmpty) {
                        return 'To date should not be empty';                 
                      }                                        
                      else {
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
            
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: revenueNotifier, 
                builder: (BuildContext context, List<BillDetailsModel>revenueList,child){     
                  totalRevenue = 0;
                  for (var item in revenueList) {
                    totalRevenue += item.totalAmount;
                  }            
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      
                      child: Padding(
                        padding: const EdgeInsets.all(20.0 ),
                        child: DataTable(
                          border: TableBorder.all(color: Colors.black),
                          columns: const [
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Bill no',overflow: TextOverflow.ellipsis,maxLines: 2,)),
                            DataColumn(label: Text('Customer name',overflow: TextOverflow.ellipsis,maxLines: 2,)),
                            DataColumn(label: Text('Amount')),                    
                          ],
                           rows: revenueList.map((data) =>  DataRow(cells: [
                         DataCell(Center(child: Text(data.billingDate.toString()))),
                         DataCell(Center(child: Text(data.billNo.toString()))),
                         DataCell(Center(child: Text(data.customerName))),
                         DataCell(Center(child: Text((data.totalAmount.toString())))),
                                                      
                        ])).toList(),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          
            Padding(
             padding: const EdgeInsets.all(15.0 ),
             child:  Text('Total : ₹${totalRevenue.toStringAsFixed(2)}',style: const TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold
             ),),
           )
          ],
        ),
        
      ),
    );
  }
  Future<void>onSubmitButtonClicked(BuildContext context)async{
    final fromdate=_fromDateController.text.trim();
    final todate=_toDateController.text.trim();

    final fromDate = DateTime.parse(_fromDateController.text);
    final toDate = DateTime.parse(_toDateController.text); 

    if(fromDate.isBefore(toDate) || fromDate.isAtSameMomentAs(toDate)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(10),
        content: Text('Select From date before To date'),
      ));
    }    
                    
    if(fromdate.isEmpty||todate.isEmpty){
      return;
    }
   

   
    getRevenue(fromdate, todate);
    fetchdata();
  }
  void _updateTotalRevenue() async {
    final rev = await getRevenue(_fromDateController.text, _toDateController.text);
    setState(() {
      totalRevenue = rev;
    });
  }
   fetchdata() async {
    _updateTotalRevenue();
  }
}
