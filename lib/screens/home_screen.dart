import 'package:flutter/material.dart';
import 'package:goalzify/components/my_drawer.dart';
import 'package:goalzify/screens/auth/auth_service.dart';
import 'package:goalzify/screens/content_detail_screen.dart';
import 'package:goalzify/services/contents_service.dart';
import 'package:goalzify/components/my_carousel.dart';
import 'package:goalzify/services/motivation_service.dart';
import 'package:goalzify/styles.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ContentService _contentService = ContentService();
  final MotivationService _motivationService = MotivationService();
  String? email;
  int motivationValue = 0;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _loadMotivation();
  }

  Future<void> _loadUserEmail() async {
    final auth = AuthService();
    setState(() {
      email = auth.getCurrentUserEmail();
    });
  }

  Future<void> _loadMotivation() async {
    await _motivationService.resetMotivationIfNeeded();
    int motivation = await _motivationService.getMotivation();
    setState(() {
      motivationValue = motivation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          "./assets/images/goalzify_appbar_logo.png",
          height: 40, // Logonun boyutunu ayarlayın
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserProfileAndMotivationSummary(),
            _buildContentCarousel(),
            const SizedBox(height: 20),
            _buildGoalsSection(context),
            _buildDailyRemindersSection(context),
            _buildProgressStats(context),
            _buildMotivationalContent(context),
            _buildGamificationSection(context),
            _buildCommunityAndSharing(context),
            _buildMeditationAndMindfulness(context),
            _buildFeaturedTasks(context),
            _buildRecommendedContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileAndMotivationSummary() {
    // Kullanıcı profili ve motivasyon özeti için bir widget
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Card(
        color: Colors.grey.shade300,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=1780&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
          ),
          title: email != null
              ? Text(
                  email!,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.grey.shade900),
                )
              : const Text("Loading..."),
          subtitle: Text("Son motivasyon: $motivationValue%"),
        ),
      ),
    );
  }

  Widget _buildContentCarousel() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _contentService.getContent(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No content available."));
        }

        var contentList = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: MyCarousel(
            contentList: contentList,
            onItemTap: (content) async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentDetailScreen(content: content),
                ),
              );
              // await _motivationService.increaseMotivation(content['id']);
              _loadMotivation(); // Motivasyon değerini güncelle
            },
          ),
        );
      },
    );
  }

  Widget _buildGoalsSection(BuildContext context) {
    // Hedefler bölümü için bir widget
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("G o a l s", style: AppStyles.homeScreenSectionTitle),
          Divider(
            color: Colors.grey.shade400,
            thickness: 2,
          ),
          // Hedef kartları burada gösterilebilir
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Card(
              color: Colors.grey.shade300,
              child: const Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Goals title"),
                    Text("Date"),
                    Icon(Icons.check_box),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Card(
              color: Colors.grey.shade300,
              child: const Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Goals title"),
                    Text("Date"),
                    Icon(Icons.check_box_outline_blank_sharp),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Card(
              color: Colors.grey.shade300,
              child: const Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Goals title"),
                    Text("Date"),
                    Icon(Icons.check_box),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRemindersSection(BuildContext context) {
    // Günlük hatırlatıcılar ve bildirimler bölümü için bir widget
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("D A I L Y   R E M I N D E R",
              style: AppStyles.homeScreenSectionTitle),
          Divider(
            color: Colors.grey.shade400,
            thickness: 2,
          ),
          // Hatırlatıcılar burada listelenebilir
        ],
      ),
    );
  }

  Widget _buildProgressStats(BuildContext context) {
    // İlerleme grafikleri ve istatistikler bölümü için bir widget
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("İlerleme", style: Theme.of(context).textTheme.bodyLarge),
          // İstatistikler ve grafikler burada gösterilebilir
        ],
      ),
    );
  }

  Widget _buildMotivationalContent(BuildContext context) {
    // Motivasyonel içerikler bölümü için bir widget
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Motivasyon İçerikleri",
              style: Theme.of(context).textTheme.bodyLarge),
          // Motivasyonel içerikler burada listelenebilir
        ],
      ),
    );
  }

  Widget _buildGamificationSection(BuildContext context) {
    // Gamifikasyon bölümü için bir widget
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gamifikasyon", style: Theme.of(context).textTheme.bodyLarge),
          // Rozetler, puanlar vb. burada gösterilebilir
        ],
      ),
    );
  }

  Widget _buildCommunityAndSharing(BuildContext context) {
    // Topluluk ve sosyal paylaşım bölümü için bir widget
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Topluluk ve Paylaşım",
              style: Theme.of(context).textTheme.bodyLarge),
          // Kullanıcı etkileşimleri ve paylaşımlar burada gösterilebilir
        ],
      ),
    );
  }

  Widget _buildMeditationAndMindfulness(BuildContext context) {
    // Meditasyon ve mindfulness bölümü için bir widget
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Meditasyon ve Mindfulness",
              style: Theme.of(context).textTheme.bodyLarge),
          // Meditasyon rehberleri burada gösterilebilir
        ],
      ),
    );
  }

  Widget _buildFeaturedTasks(BuildContext context) {
    // Öne çıkan görevler ve etkinlikler bölümü için bir widget
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Öne Çıkan Görevler",
              style: Theme.of(context).textTheme.bodyLarge),
          // Görevler ve etkinlikler burada listelenebilir
        ],
      ),
    );
  }

  Widget _buildRecommendedContent(BuildContext context) {
    // Önerilen içerikler bölümü için bir widget
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Önerilen İçerikler",
              style: Theme.of(context).textTheme.bodyMedium),
          // Kullanıcıya özel öneriler burada gösterilebilir
        ],
      ),
    );
  }
}
