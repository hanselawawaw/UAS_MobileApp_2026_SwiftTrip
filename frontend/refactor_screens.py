import re
import os

base_dir = r"c:\Users\Earthen\dev\college\swifttrip\frontend\lib\screens\home"

def process_review():
    path = os.path.join(base_dir, "review.dart")
    with open(path, "r", encoding="utf-8") as f: content = f.read()

    # 1. Add imports
    content = content.replace("import '../main/main_screen.dart';", "import '../main/main_screen.dart';\nimport 'services/review_service.dart';\nimport 'widgets/dropdown_field.dart';")

    # 2. Update state variables inside _ReviewPageState
    new_state = """class _ReviewPageState extends State<ReviewPage> {
  int _rating = 1;
  String? _selectedFeeling;
  final TextEditingController _thoughtsController = TextEditingController();

  final _reviewService = ReviewService();
  List<String> _feelingOptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final options = await _reviewService.getFeelingOptions();
    if (mounted) {
      setState(() {
        _feelingOptions = options;
        _isLoading = false;
      });
    }
  }"""
    content = re.sub(r'class _ReviewPageState extends State<ReviewPage> \{.*?final List<String> _feelingOptions = \[.*?\];', new_state, content, flags=re.DOTALL)

    # 3. Update _handleAddPost
    old_post = r"// TODO: POST review to backend:.*?// \}"
    new_post = """await _reviewService.submitReview(
      targetName: widget.targetName,
      rating: _rating,
      feeling: _selectedFeeling,
      thoughts: _thoughtsController.text.trim(),
    );"""
    content = re.sub(old_post, new_post, content, flags=re.DOTALL)

    # 4. Replace _DropdownField usage
    content = content.replace("_DropdownField(", """_isLoading ? const Center(child: CircularProgressIndicator()) : DropdownFieldWidget(""")

    # 5. Remove _DropdownField class
    idx = content.find("// ─────────────────────────────────────────────────────────────────────────────\n// DROPDOWN FIELD")
    if idx != -1:
        content = content[:idx].strip() + "\n"

    with open(path, "w", encoding="utf-8") as f: f.write(content)

def process_order_ticket():
    path = os.path.join(base_dir, "order_ticket.dart")
    with open(path, "r", encoding="utf-8") as f: content = f.read()

    content = content.replace("import '../main/main_screen.dart';", "import '../main/main_screen.dart';\nimport 'services/ticket_service.dart';\nimport 'widgets/bottom_action_bar.dart';")

    new_state = """class _OrderTicketPageState extends State<OrderTicketPage> {
  final _ticketService = TicketService();
  List<CartTicket> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final tickets = await _ticketService.getTickets();
    if (mounted) {
      setState(() {
        _tickets = List.from(tickets);
        _isLoading = false;
      });
    }
  }

  // TODO: Track which tickets are selected for cart/checkout"""
    # replace from class _OrderTicketPageState to the selectedIndices comment
    content = re.sub(r'class _OrderTicketPageState extends State<OrderTicketPage> \{.*?// TODO: Track which tickets are selected for cart/checkout', new_state, content, flags=re.DOTALL)

    content = content.replace(" Expanded(", " _isLoading ? const Expanded(child: Center(child: CircularProgressIndicator())) : Expanded(")
    content = content.replace("_BottomActionBar(", "BottomActionBar(")

    idx = content.find("// ─────────────────────────────────────────────────────────────────────────────\n// BOTTOM ACTION BAR")
    if idx != -1:
        content = content[:idx].strip() + "\n"

    with open(path, "w", encoding="utf-8") as f: f.write(content)

def process_next_trip():
    path = os.path.join(base_dir, "next_trip.dart")
    with open(path, "r", encoding="utf-8") as f: content = f.read()

    content = content.replace("import '../main/main_screen.dart';", "import '../main/main_screen.dart';\nimport 'services/next_trip_service.dart';\nimport 'models/purchase_detail.dart';\nimport 'widgets/purchase_details_card.dart';")

    new_state = """class _NextTripPageState extends State<NextTripPage> {
  final _nextTripService = NextTripService();
  CartTicket? _ticket;
  List<PurchaseDetail> _purchaseDetails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final ticket = await _nextTripService.getNextTrip();
    final details = await _nextTripService.getPurchaseDetails();
    if (mounted) {
      setState(() {
        _ticket = ticket;
        _purchaseDetails = details;
        _isLoading = false;
      });
    }
  }

  String _formatRp(int amount) {"""
    content = re.sub(r'class _NextTripPageState extends State<NextTripPage> \{.*?String _formatRp\(int amount\) \{', new_state, content, flags=re.DOTALL)

    content = content.replace(" TicketCard(", " if (_ticket != null) TicketCard(")
    # we need to accommodate null ticket or isLoading
    content = content.replace("ticket: _ticket,", "ticket: _ticket!,")
    content = content.replace("_PurchaseDetailsCard(", "PurchaseDetailsCard(")

    content = content.replace("Expanded(\n            child: SingleChildScrollView(", "Expanded(\n            child: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(")

    idx = content.find("// ─────────────────────────────────────────────────────────────────────────────\n// PURCHASE DETAILS CARD")
    if idx != -1:
        content = content[:idx].strip() + "\n"

    with open(path, "w", encoding="utf-8") as f: f.write(content)

def process_home():
    path = os.path.join(base_dir, "home.dart")
    with open(path, "r", encoding="utf-8") as f: content = f.read()

    # We already extracted popup manually, but need to wire the service
    content = content.replace("import '../../models/schedule_item.dart';", "import '../../models/schedule_item.dart';\nimport 'services/home_service.dart';")

    # In home.dart:
    # Future<void> _fetchHomeData() async { ... }
    # Let's replace _fetchHomeData with a service call
    
    new_fetch = """Future<void> _fetchHomeData() async {
    setState(() => _isLoading = true);
    final homeService = HomeService();
    try {
      final banners = await homeService.fetchBanners();
      final schedules = await homeService.fetchSchedules();
      final recs = await homeService.fetchRecommendations();
      if (mounted) {
        setState(() {
          _serverBanners = banners;
          _serverSchedules = schedules;
          _serverRecommendations = recs;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }"""
    content = re.sub(r'Future<void> _fetchHomeData\(\) async \{.*?\n  \}', new_fetch, content, flags=re.DOTALL, count=1)
    
    # Also I noticed _carouselImages config. It can be replaced by _serverBanners
    content = content.replace("_carouselImages.length", "_serverBanners.length")
    content = content.replace("imageAsset: _carouselImages[i]", "imageAsset: _serverBanners[i]")
    content = content.replace("const _recommendations", "final _recommendations")
    
    # Remove mock variables outside state
    content = re.sub(r'const _carouselImages = \[.*?\];', '', content, flags=re.DOTALL)
    content = re.sub(r'const _recommendations = \[.*?\];', '', content, flags=re.DOTALL)
    
    # Change usages from _recommendations to _serverRecommendations
    content = content.replace("_recommendations[", "_serverRecommendations[")
    content = content.replace("_recommendations.length", "_serverRecommendations.length")

    with open(path, "w", encoding="utf-8") as f: f.write(content)

process_review()
process_order_ticket()
process_next_trip()
process_home()
print("Done")
