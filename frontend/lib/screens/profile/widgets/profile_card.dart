import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/repositories/auth_repository.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  final AuthRepository _authRepo = AuthRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (_authRepo.currentUser == null) {
      _fetchUser();
    }
  }

  void refresh() {
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    setState(() => _isLoading = true);
    try {
      await _authRepo.getUserProfile();
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authRepo.currentUser;

    return Container(
      width: double.infinity,
      height: 114,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_outline,
              size: 32,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user?.fullName ?? 'Unknown User',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? 'No email available',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
