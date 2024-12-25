import 'package:flutter/material.dart';
import 'package:currency_converter/Custom_Widget/Textform.dart';
import 'package:currency_converter/services/Countries_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? selectFromIndex;
  String? selectToIndex;
  TextEditingController _amountController = TextEditingController();
  double? convertedAmount;
  Map<String, dynamic>? currencies;

  double? convertAmount(double amount, String fromCurrency, String toCurrency) {
    if (currencies == null) return null;

    double fromValue = currencies![fromCurrency]['value'];
    double toValue = currencies![toCurrency]['value'];
    return (amount / fromValue) * toValue;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
        future: CountriesServices().getdatafromAPI(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          }
          currencies = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // From Currency Dropdown with icon
                const Text(
                  'From Currency',
                  style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueGrey.shade300),
                  ),
                  child: DropdownButton<String>(
                    value: selectFromIndex,
                    hint: const Text('Select From Currency'),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: currencies?.keys.map((currencyCode) {
                      return DropdownMenuItem<String>(
                        value: currencyCode,
                        child: Text(currencyCode),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        selectFromIndex = newVal;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Amount Input Field
                Textform(
                  hinttxt: 'Enter the amount',
                  amount: _amountController,
                ),
                const SizedBox(height: 16),

                // To Currency Dropdown with icon
                const Text(
                  'To Currency',
                  style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueGrey.shade300),
                  ),
                  child: DropdownButton<String>(
                    value: selectToIndex,
                    hint: const Text('Select To Currency'),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: currencies?.keys.map((currencyCode) {
                      return DropdownMenuItem<String>(
                        value: currencyCode,
                        child: Text(currencyCode),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        selectToIndex = newVal;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Convert Button with gradient
                ElevatedButton(
                  onPressed: () {
                    if (selectFromIndex != null && selectToIndex != null && _amountController.text.isNotEmpty) {
                      double amount = double.parse(_amountController.text);
                      double? result = convertAmount(amount, selectFromIndex!, selectToIndex!);
                      setState(() {
                        convertedAmount = result;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150,45),
                    backgroundColor: Colors.blueAccent, // button color
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Convert', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 24),

                // Display Converted Amount
                if (convertedAmount != null)
                  Center(
                    child: Text(
                      'Converted Amount: ${convertedAmount!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
