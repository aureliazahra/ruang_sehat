import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ruang_sehat/features/articles/presentation/widgets/popup_menu.dart';
import 'package:ruang_sehat/features/articles/providers/articles_providers.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../widgets/container_detail.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  static const routeName = '/detail-screen';

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  bool isMenuOpen = false;


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
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final isMe = args['isMe'] ?? false; 
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
            
            // Container detail article
            Positioned(
              top: 0,
              left: 20,
              right: 20,
              child: ContainerDetail(article: article),
             ),


            // Back button
            Positioned(
              top: 25,
              left: 25,
              right: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
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
                  if (isMe)
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.text.withOpacity(0.3),
                    ),
                    child:  IconButton(
                      onPressed: () => {
                        setState(() {
                          isMenuOpen = !isMenuOpen;
                        })
                      },
                      icon: const Icon(
                        Icons.more_horiz,
                        color: AppColors.secondary,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Popup menu
            if (isMenuOpen) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isMenuOpen = false;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: PopupMenu(),
              )
            ]
          ],
        ),
      ),
    );
  }
}
