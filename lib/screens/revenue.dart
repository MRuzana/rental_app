import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/db/functions/bill_functions.dart';
import 'package:rental_app/widget/button_widget.dart';
import 'package:rental_app/widget/revenue_widget.dart';
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
  void initState(){
    _fromDateController.text=DateFormat('MMM d, yyyy').format(DateTime.now().subtract(const Duration(days: 7)));
    _toDateController.text=DateFormat('MMM d, yyyy').format(DateTime.now());
    fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 206, 242, 242),    
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
                        String fromDate = DateFormat('MMM d, yyyy').format(pickedDate);
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
                        String toDate = DateFormat('MMM d, yyyy').format(pickedDate);
                        setState(() {
                          _toDateController.text = toDate;
                        });
                      }                                                                                     
                    },               
                    hinttext: 'To date',
                    validator: (value) { 
                                                      
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
            revenuelist(),            
        
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
                      
    if(fromdate.isEmpty||todate.isEmpty){
      return;
    }

    final DateFormat dateFormat = DateFormat('MMM d, yyyy');
    DateTime fromDate;
    DateTime toDate;

    try {
      fromDate = dateFormat.parse(fromdate);
      toDate = dateFormat.parse(todate);
    } catch (e) {
      print('Error parsing date: $e');
      return;
    }
  if(fromDate.isAfter(toDate)){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(10),
        content: Text('Select From date before To date'),
      ));
      _fromDateController.text=DateFormat('MMM d, yyyy').format(DateTime.now().subtract(const Duration(days: 7)));
      _toDateController.text=DateFormat('MMM d, yyyy').format(DateTime.now());

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
