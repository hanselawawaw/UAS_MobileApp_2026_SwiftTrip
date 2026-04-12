import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/top_bar.dart';
import 'onboarding.dart';
import 'main_page.dart';
import 'your_ticket.dart';
import 'models/cs_request.dart';
import 'widgets/cs_search_bar.dart';
import 'widgets/cs_dropdown_field.dart';
import 'widgets/cs_dropdown_label.dart';
import 'widgets/cs_input_field.dart';
import 'widgets/cs_upload_field.dart';
import 'widgets/cs_section_label.dart';
import 'services/customer_service_service.dart';

class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  State<AddRequestPage> createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _notifController;
  late Animation<Offset> _notifSlide;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _statementController = TextEditingController();
  final CustomerServiceService _service = CustomerServiceService();

  String? _selectedProblemType;
  String? _selectedLocation;
  String? _selectedPublishType;
  String? _uploadedFileName;

  List<String> _problemTypes = [];
  List<String> _locations = [];
  List<String> _publishTypes = [];

  @override
  void initState() {
    super.initState();
    _notifController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _notifSlide = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _notifController, curve: Curves.easeOut));

    _loadOptions();
  }

  Future<void> _loadOptions() async {
    final types = await _service.getProblemTypes();
    final locs = await _service.getLocations();
    final pubTypes = await _service.getPublishTypes();
    if (mounted) {
      setState(() {
        _problemTypes = types;
        _locations = locs;
        _publishTypes = pubTypes;
      });
    }
  }

  @override
  void dispose() {
    _notifController.dispose();
    _searchController.dispose();
    _headerController.dispose();
    _statementController.dispose();
    super.dispose();
  }

  Future<void> _handleImportFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _uploadedFileName = image.name);
      // TODO: Actually upload the file to your backend here
    }
  }

  Future<void> _handleSendRequest() async {
    // TODO: Validate all fields before submitting
    final request = CsRequest(
      problemType: _selectedProblemType,
      location: _selectedLocation,
      publishType: _selectedPublishType,
      header: _headerController.text,
      statement: _statementController.text,
      uploadedFileName: _uploadedFileName,
    );

    await _service.postRequest(request);
    _showNotificationThenNavigate();
  }

  Future<void> _showNotificationThenNavigate() async {
    await _notifController.forward();
    await Future.delayed(const Duration(seconds: 2));
    await _notifController.reverse();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CustomerServicePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Column(
            children: [
              TopBar(
                showBackButton: true,
                showHamburger: true,
                onHamburgerTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OnboardingPage()),
                  );
                },
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // ── Search Bar ─────────────────────────────────────────────
                      CsSearchBar(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        readOnly: true,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CustomerServicePage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Section Title Row ──────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'State Your Problems',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const YourTicketPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Your Ticket >',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF2B99E3),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Dropdowns ──────────────────────────────────────────────
                      const CsDropdownLabel(text: 'Problem Type'),
                      const SizedBox(height: 4),
                      CsDropdownField(
                        hint: '- - -',
                        value: _selectedProblemType,
                        items: _problemTypes,
                        onChanged: (val) =>
                            setState(() => _selectedProblemType = val),
                      ),
                      const SizedBox(height: 12),
                      const CsDropdownLabel(text: 'Location'),
                      const SizedBox(height: 4),
                      CsDropdownField(
                        hint: '- - -',
                        value: _selectedLocation,
                        items: _locations,
                        onChanged: (val) =>
                            setState(() => _selectedLocation = val),
                      ),
                      const SizedBox(height: 12),
                      const CsDropdownLabel(text: 'Publish Type'),
                      const SizedBox(height: 4),
                      CsDropdownField(
                        hint: '- - -',
                        value: _selectedPublishType,
                        items: _publishTypes,
                        onChanged: (val) =>
                            setState(() => _selectedPublishType = val),
                      ),

                      const SizedBox(height: 15),
                      const Divider(color: Color(0x4D000000), thickness: 1),

                      // ── Header Field ───────────────────────────────────────────
                      const CsSectionLabel(text: 'Header'),
                      const SizedBox(height: 8),
                      CsInputField(
                        controller: _headerController,
                        hint: 'Type Here',
                        minLines: 1,
                        maxLines: 1,
                        height: 40,
                      ),
                      const SizedBox(height: 16),

                      // ── Main Statements Field ──────────────────────────────────
                      const CsSectionLabel(text: 'Main Statements'),
                      const SizedBox(height: 8),
                      CsInputField(
                        controller: _statementController,
                        hint: 'Type Here',
                        minLines: 5,
                        maxLines: 8,
                        height: 142,
                      ),
                      const SizedBox(height: 16),

                      // ── Upload Evidence ────────────────────────────────────────
                      const CsSectionLabel(text: 'Upload Evidence'),
                      const SizedBox(height: 8),
                      CsUploadField(
                        fileName: _uploadedFileName,
                        onImport: _handleImportFile,
                      ),
                      const SizedBox(height: 40),

                      // ── Send Request Button ────────────────────────────────────
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _handleSendRequest,
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF2B99E3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Send Request',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xFFF7F9F9),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 50,
            right: 30,
            child: IgnorePointer(
              child: SlideTransition(
                position: _notifSlide,
                child: Container(
                  width: 208,
                  height: 57,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Request Sent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.string(
                        '''<svg width="124" height="124" viewBox="0 0 124 124" fill="none" xmlns="http://www.w3.org/2000/svg">
<g filter="url(#filter0_d_482_1238)">
<path fill-rule="evenodd" clip-rule="evenodd" d="M61.75 115.5C69.3338 115.5 76.8434 114.006 83.85 111.104C90.8565 108.202 97.2228 103.948 102.585 98.5854C107.948 93.2228 112.202 86.8565 115.104 79.85C118.006 72.8434 119.5 65.3338 119.5 57.75C119.5 50.1662 118.006 42.6566 115.104 35.65C112.202 28.6435 107.948 22.2772 102.585 16.9146C97.2228 11.552 90.8565 7.29817 83.85 4.39596C76.8434 1.49375 69.3338 -1.13008e-07 61.75 0C46.4337 2.2823e-07 31.7448 6.08436 20.9146 16.9146C10.0844 27.7448 4 42.4337 4 57.75C4 73.0663 10.0844 87.7552 20.9146 98.5854C31.7448 109.416 46.4337 115.5 61.75 115.5ZM60.2613 81.1067L92.3447 42.6067L82.4887 34.3933L54.897 67.4969L40.6199 53.2134L31.5468 62.2866L50.7967 81.5366L55.7633 86.5031L60.2613 81.1067Z" fill="#02C518"/>
</g>
<defs>
<filter id="filter0_d_482_1238" x="0" y="0" width="123.5" height="123.5" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
<feOffset dy="4"/>
<feGaussianBlur stdDeviation="2"/>
<feComposite in2="hardAlpha" operator="out"/>
<feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0"/>
<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_482_1238"/>
<feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_482_1238" result="shape"/>
</filter>
</defs>
</svg>
''',
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
