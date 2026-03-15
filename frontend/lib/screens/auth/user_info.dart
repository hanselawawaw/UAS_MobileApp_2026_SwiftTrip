import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  int _selectedDay = 1;
  String _selectedMonth = 'January';
  int _selectedYear = DateTime.now().year;

  final List<int> _days = List.generate(31, (index) => index + 1);
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<int> _years = List.generate(
    100,
    (index) => DateTime.now().year - index,
  );

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final Map<String, dynamic> payload = {
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth':
          '$_selectedYear-${_months.indexOf(_selectedMonth) + 1}-$_selectedDay',
    };

    // TODO: Send payload to backend
    debugPrint('Submitting: $payload');

    // As UserInfo overrode Signup on top of Login, popping lands back on Login
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'One Last Step And\nYou\'re Ready',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 40),

                _buildInputField(
                  controller: _firstNameController,
                  hint: 'First Name',
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: _lastNameController,
                  hint: 'Last Name',
                ),
                const SizedBox(height: 24),

                const Divider(color: Color(0xFFD1DEE5), thickness: 1),
                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Birth Day:',
                    style: TextStyle(
                      color: Color(0xFF4F7A93),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWheelPicker<int>(
                      label: 'Day',
                      items: _days,
                      initialItem: _days.indexOf(_selectedDay),
                      onChanged: (val) => setState(() => _selectedDay = val),
                      width: 70,
                    ),
                    _buildWheelPicker<String>(
                      label: 'Month',
                      items: _months,
                      initialItem: _months.indexOf(_selectedMonth),
                      onChanged: (val) => setState(() => _selectedMonth = val),
                      width: 140,
                    ),
                    _buildWheelPicker<int>(
                      label: 'Year',
                      items: _years,
                      initialItem: _years.indexOf(_selectedYear),
                      onChanged: (val) => setState(() => _selectedYear = val),
                      width: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                GestureDetector(
                  onTap: _handleConfirm,
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF679CE0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFE8EDF2),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD1DEE5)),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          style: const TextStyle(
            color: Color(0xFF0C161C),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF4F7A93),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildWheelPicker<T>({
    required String label,
    required List<T> items,
    required int initialItem,
    required ValueChanged<T> onChanged,
    required double width,
  }) {
    return Column(
      children: [
        Container(
          width: width,
          height: 60,
          decoration: ShapeDecoration(
            color: const Color(0xFFE8EDF2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 20,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ListWheelScrollView.useDelegate(
            itemExtent: 30,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(initialItem: initialItem),
            onSelectedItemChanged: (index) => onChanged(items[index]),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, index) {
                return Center(
                  child: Text(
                    items[index].toString(),
                    style: const TextStyle(
                      color: Color(0xFF4F7A93),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4F7A93),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
