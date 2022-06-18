import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

// Loading
Widget loadingWidget(context) {
  return Padding(
    padding: const EdgeInsets.all(30.0),
    child: SpinKitDoubleBounce(
      size:
          MediaQuery.of(context).orientation == Orientation.portrait ? 100 : 50,
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? grey : lightgrey,
          ),
        );
      },
    ),
  );
}

// Error
Widget errorWidget(context, text) {
  return Container(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 10),
      child: MediaQuery.of(context).orientation == Orientation.portrait
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Image.asset(
                    'assets/images/error.png',
                    height: 100,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: lightgrey,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blueblack, fontSize: 25, fontFamily: defaultFont),
                ),
                const SizedBox(
                  height: 30,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: Material(
                //     color: blueblack,
                //     borderRadius: BorderRadius.circular(15.0),
                //     child: TextButton(
                //       onPressed: () {
                //         //Navigator.pushReplacementNamed(context, '/$route');
                //         Navigator.pop(context);
                //       },
                //       child: Text(
                //         "Retry",
                //         // AppLocalizations.of(context)
                //         //     .translate("retry_btn_text"),
                //         style: TextStyle(color: white, fontFamily: defaultFont),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Image.asset('assets/images/error.png'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: lightgrey,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blueblack, fontSize: 25, fontFamily: defaultFont),
                ),
                const SizedBox(
                  height: 30,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: Material(
                //     color: blueblack,
                //     borderRadius: BorderRadius.circular(15.0),
                //     child: TextButton(
                //       onPressed: () {
                //         Navigator.pushReplacementNamed(context, '/$route');
                //       },
                //       child: Text(
                //         // AppLocalizations.of(context)
                //         //     .translate("retry_btn_text"),
                //         "Retry",
                //         style: TextStyle(color: white, fontFamily: defaultFont),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ));
}

// Done
Widget doneWidget(context, route, text) {
  return Container(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 10),
      child: MediaQuery.of(context).orientation == Orientation.portrait
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Image.asset(
                    'assets/images/done.png',
                    height: 100,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: lightgrey,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blueblack, fontSize: 25, fontFamily: defaultFont),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: blueblack,
                    borderRadius: BorderRadius.circular(15.0),
                    child: TextButton(
                      onPressed: () {
                        //Navigator.pushReplacementNamed(context, '/$route');
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate("ok"),
                        style: TextStyle(color: white, fontFamily: defaultFont),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Image.asset('assets/images/error.png'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: lightgrey,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blueblack, fontSize: 25, fontFamily: defaultFont),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: blueblack,
                    borderRadius: BorderRadius.circular(15.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/$route');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate("ok"),
                        style: TextStyle(color: white, fontFamily: defaultFont),
                      ),
                    ),
                  ),
                ),
              ],
            ));
}
