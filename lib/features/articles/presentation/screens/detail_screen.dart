import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ruang_sehat/features/articles/providers/articles_providers.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  static const routeName = '/detail-screen';

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final id = args['id'];

      context.read<ArticleProviders>().getDetailArticle(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArticleProviders>();

    if (provider.isLoading) {
      return const Center(
          child: CircularProgressIndicator(),
      );
    }

    if (provider.detailArticles == null) {
      return const Center(
        child: Text("Article not found"),
      );
    }
    final article = provider.detailArticle!;


    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Image article
            Image(
              image: NetworkImage("$baseUrl/${article.image}"),
              width: double.infinity,
              height: 500,
              fit: BoxFit.cover,
            ),

            //gradient overlay
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      AppColors.background.withOpacity(1.0),
                      AppColors.background.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 25,
              left: 25,
              right: 25,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.text.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.secondary,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
