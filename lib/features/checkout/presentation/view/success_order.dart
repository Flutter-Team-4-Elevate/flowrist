import 'package:flowrist/core/constants/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessOrder extends StatelessWidget {
  const SuccessOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Success order")),
          ElevatedButton(
            onPressed: () {
              context.go(AppRoutes.homeTab);
            },
            child: Text("data"),
          ),
        ],
      ),
    );
  }
}
