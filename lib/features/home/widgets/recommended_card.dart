import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/detail_screen.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/providers/articles_providers.dart';

class RecommendedCard extends StatelessWidget {
  const RecommendedCard({super.key});
  static final String baseUrl = dotenv.env['BASE_URL']!;

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProviders>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.articles.isEmpty) {
          return const Center(child: Text("Tidak ada artikel"));
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (_, __) => const SizedBox(height: 7),
          itemCount: provider.articles.length,
          itemBuilder: (context, index) {
            final article = provider.articles[index];
              return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailScreen.routeName,
                  arguments: {'id': article.id},
                );
              },
              child: Card(
              color: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(12),
                child: Row(
                  children: [
                    //Image articles
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage("$baseUrl/${article.image}"),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    // Article title
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(99),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      article.category,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  article.date,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.hintText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              article.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              )
            );
          },
        );
      },
    );
  }
}
