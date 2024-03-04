import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/db/functions/bill_functions.dart';
import 'package:rental_app/db/functions/cart_functions.dart';
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/screens/settled_bill.dart';
import 'package:rental_app/widget/button_widget.dart';

class BillSettlement extends StatefulWidget {
  const BillSettlement({super.key});

  @override
  State<BillSettlement> createState() => _BillSettlementState();
}

class _BillSettlementState extends State<BillSettlement> {

  Widget text({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget customerText({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget okButtonText({required String text}) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 15.0, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }

  @override
  void initState() {
    super.initState();
    //isSettledList=[];
   getAllCartItems();
  }

  @override
  Widget build(BuildContext context) {
    getBillDetails();
   // getCustomerDetails();

    return Scaffold(
      appBar: EasySearchBar(
          title: const Text('Bill Settlement'),
          onSearch: (value) async {
            List<BillDetailsModel> products = await searchText(value);
            billListNotifier.value = products;
          }),
      body: SafeArea(
          child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: billListNotifier,
          builder:
              (BuildContext context, List<BillDetailsModel> billList, child) {          
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = billList[index];              
                  print('cart${data.cartItems.toList()}');
                  print('settled: ${data.isSettled}');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0,),
                      text(text: 'Bill No : ${data.billNo}'),
                      const SizedBox(height: 20.0,),
                      text(text: 'Customer details'),
                      const SizedBox(height: 10.0,),
                      customerText(text: 'Name          : ${data.customerName}'),
                      customerText(text: 'Address      : ${data.customerAddress}'),
                      customerText(text: 'Place           : ${data.customerPlace}'),
                      customerText(text: 'Mobile no    : ${data.customerMobileNo}'),
                      customerText(text: 'Event date   : ${data.eventDate}'),
                      customerText(text: 'Return date : ${data.returnDate}'),                     
                      const SizedBox( height: 20.0,),  
                      text(text: 'Item details'),                 
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
                          rows: data.cartItems.map((cartItem) {                                                                 
                            return DataRow(                   
                            cells: [                    
                              DataCell(Text(cartItem["name"])),
                              DataCell(Text(cartItem["quantity"].toString())),
                              DataCell(Text(cartItem["unit_price"].toString())),
                              DataCell(Text(cartItem["total_price"].toString())),
                
                            ]);
                          }).toList(),
                        ),
                      ),                    
                      text(text: 'Total Amount      : ₹${data.totalAmount}'),
                      text(text: 'Advance Paid      : ₹${data.advancePaid}'),
                      text(text: 'Balance Amount : ₹${data.balanceAmount}'),
                      
                      (data.isSettled==false)?
                      
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff8ECFCB),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              right: -40,
                                              top: -40,
                                              child: InkResponse(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  child: Icon(Icons.close),
                                                ),
                                              ),
                                            ),
                                            Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [                                                                                                  
                                                text(text:'Date         : ${DateFormat('dd-MM-yyyy').format(DateTime.now())}'),                                                                                                
                                                text(text:'Bill No      : ${data.billNo}'),
                                                text(text:'Total Amt : ${data.totalAmount}'),
                                                text(text:'Adv Paid  : ${data.advancePaid}'),
                                                text(text: 'Balance   : ${data.balanceAmount}'),
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('Items returned back and Balance amount received',style: TextStyle(color: Colors.red),),
                                                ),
                                                
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: button(
                                                    buttonText: 'OK',
                                                    buttonPressed: (){
                                                      updateBill(
                                                        data.billNo,                                                        
                                                        DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                                        index);
                                                        Navigator.pushAndRemoveUntil(
                                                          context, MaterialPageRoute(builder: (context)=>BillSettled(
                                                            billDetailsModel: billList[index])), (route) =>false);
                                                        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>BillSettled(billDetailsModel: billList[index],
                                                        // )));                                                                                               
                                                    })
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    });                               
                              },
                              child: const Text(
                                'SETTLE BILL',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      :
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Column(
                          children: [
                            Text('Balance amount received',style: TextStyle(color: Colors.red),),
                            Text('Bill Settled',style: TextStyle(color: Colors.red,fontSize: 20 ,fontWeight: FontWeight.bold),),
                          ],
                        )),
                      )
                    ],
                  );
                  //}
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Divider(
                      color: Colors.black,
                    ),
                  );
                },
                itemCount: billList.length);
          },
        ),
      )),
    );
  }
}
