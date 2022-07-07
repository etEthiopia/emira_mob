// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PaymentComponent extends StatelessWidget {
  PaymentType p;
  String ref;

  PaymentComponent({required this.p, required this.ref});

  @override
  Widget build(BuildContext context) {
    // Size _screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        print(p.link + "" + ref);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) => HealthInstitutesDetails(
        //           id: id,
        //           name: name,
        //           nameamh: nameamh,
        //           address: address,
        //           addressamh: addressamh,
        //           phone: phone,
        //           photo: photo,
        //           code: code,
        //           status: status,
        //           pro: pro,
        //           createdAt: createdAt,
        //           updatedAt: updatedAt,
        //           servs: servs,
        //           professionals: professionals)),
        // );
      },
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Image.asset(
                  'assets/images/${p.image}',
                  height: 100,
                ),
              ))),
    );
  }
}

class PaymentType {
  String link;
  String image;

  static List<PaymentType> paymentTypes = [
    PaymentType(link: "", image: "mvola.png"),
    PaymentType(link: "", image: "orangemoney.png"),
    PaymentType(link: "https://emirapay.web.app/pay", image: "paypal.png"),
    PaymentType(link: "https://emirapay.web.app/pay", image: "visacard.png"),
    PaymentType(link: "https://emirapay.web.app/pay", image: "mastercard.png"),
  ];

  PaymentType({required this.link, required this.image});
}
