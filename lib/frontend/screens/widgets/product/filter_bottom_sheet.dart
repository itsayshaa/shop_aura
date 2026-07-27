import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class FilterBottomSheet {
  static void show(BuildContext context) {
    double price = 5000;

    bool inStock = true;
    bool freeDelivery = false;

    String rating = "4★ & Above";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Filters",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Maximum Price",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Slider(
                        value: price,
                        min: 500,
                        max: 50000,
                        divisions: 100,
                        activeColor: AppColors.primary,
                        label: "₹${price.toInt()}",
                        onChanged: (value) {
                          setState(() {
                            price = value;
                          });
                        },
                      ),

                      Text(
                        "₹${price.toInt()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Customer Rating",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        children: [

                          _ratingChip(
                            text: "4★ & Above",
                            selected:
                                rating == "4★ & Above",
                            onTap: () {
                              setState(() {
                                rating = "4★ & Above";
                              });
                            },
                          ),

                          _ratingChip(
                            text: "3★ & Above",
                            selected:
                                rating == "3★ & Above",
                            onTap: () {
                              setState(() {
                                rating = "3★ & Above";
                              });
                            },
                          ),

                          _ratingChip(
                            text: "2★ & Above",
                            selected:
                                rating == "2★ & Above",
                            onTap: () {
                              setState(() {
                                rating = "2★ & Above";
                              });
                            },
                          ),

                        ],
                      ),

                      const SizedBox(height: 25),

                      SwitchListTile(
                        value: inStock,
                        activeColor: AppColors.primary,
                        title: const Text("In Stock"),
                        onChanged: (value) {
                          setState(() {
                            inStock = value;
                          });
                        },
                      ),

                      SwitchListTile(
                        value: freeDelivery,
                        activeColor: AppColors.primary,
                        title:
                            const Text("Free Delivery"),
                        onChanged: (value) {
                          setState(() {
                            freeDelivery = value;
                          });
                        },
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [

                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child:
                                  const Text("Reset"),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.primary,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Apply",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _ratingChip({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(text),
      selected: selected,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : Colors.black,
      ),
      onSelected: (_) => onTap(),
    );
  }
}