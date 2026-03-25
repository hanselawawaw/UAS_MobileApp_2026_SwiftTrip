import 'package:flutter/material.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/birth_date_picker.dart';
import 'models/auth_models.dart';
import 'services/auth_service.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final AuthService _authService = AuthService();

  int _selectedDay = 1;
  String _selectedMonth = 'January';
  int _selectedYear = DateTime.now().year;

  List<int> _days = List.generate(31, (index) => index + 1);
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
  void initState() {
    super.initState();
    _updateDays();
  }

  void _updateDays() {
    final monthIndex = _months.indexOf(_selectedMonth) + 1;
    final lastDay = DateTime(_selectedYear, monthIndex + 1, 0).day;
    _days = List.generate(lastDay, (index) => index + 1);
    if (_selectedDay > lastDay) {
      _selectedDay = lastDay;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final month = (_months.indexOf(_selectedMonth) + 1).toString().padLeft(2, '0');
    final day = _selectedDay.toString().padLeft(2, '0');

    final profile = UserProfile(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: '$_selectedYear-$month-$day',
    );

    try {
      await _authService.updateUserProfile(profile);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
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

                BirthDatePicker(
                  selectedDay: _selectedDay,
                  selectedMonth: _selectedMonth,
                  selectedYear: _selectedYear,
                  days: _days,
                  months: _months,
                  years: _years,
                  onDayChanged: (val) => setState(() => _selectedDay = val),
                  onMonthChanged: (val) {
                    setState(() {
                      _selectedMonth = val;
                      _updateDays();
                    });
                  },
                  onYearChanged: (val) {
                    setState(() {
                      _selectedYear = val;
                      _updateDays();
                    });
                  },
                ),
                const SizedBox(height: 32),

                AuthPrimaryButton(
                  text: 'Confirm',
                  width: double.infinity,
                  height: 52,
                  color: const Color(0xFF679CE0),
                  onTap: _handleConfirm,
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
}
