import 'package:flutter/material.dart';
import 'package:rental_app/db/functions/bill_functions.dart';
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/widget/text_widget.dart';

Widget revenuelist() {
  double totalRevenue = 0;
  return Expanded(
      child: ValueListenableBuilder(
          valueListenable: revenueNotifier,
          builder: ((BuildContext context, List<BillDetailsModel> revenueList,
              child) {
            totalRevenue = 0;
            for (var item in revenueList) {
              totalRevenue = totalRevenue + item.totalAmount;
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                final data = revenueList[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: const Color.fromARGB(255, 206, 242, 242),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textfield(
                              text: 'Bill No : ${data.billNo}',
                              color: Colors.black,
                              size: 15,
                              weight: FontWeight.bold),
                          const SizedBox(height: 5.0),
                          textfield(
                              text: 'Date : ${data.billingDate}',
                              color: Colors.black,
                              size: 15,
                              weight: FontWeight.normal),
                          const SizedBox(height: 5.0),
                          textfield(
                              text: 'Name : ${data.customerName}',
                              color: Colors.black,
                              size: 15,
                              weight: FontWeight.normal),
                        ],
                      ),
                      trailing: textfield(
                          text: 'Amount : ${data.totalAmount}',
                          color: Colors.green,
                          size: 17,
                          weight: FontWeight.bold),
                    ),
                  ),
                );
              },
              itemCount: revenueList.length,
            );
          })));
}
