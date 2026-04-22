import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';

class FormArticleScreen extends StatefulWidget {
  const FormArticleScreen({super.key});

  static const routeName = '/form-article';

  @override
  State<FormArticleScreen> createState() => _FormArticleScreenState();
}

class _FormArticleScreenState extends State<FormArticleScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;

    final isEdit = args?['isEdit'] ?? false;
    final article = args?['article'];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            isEdit ? 'Update Article' : 'Create Article',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.background,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.text),
            padding: EdgeInsets.only(left: 20),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label from Title
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text.withOpacity(0.7),
                ),
              ),

              // Form Title
              const SizedBox(height: 8),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter article title',
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.secondary,
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                ),
              ),
              //Label from Category
              Text(
                "Category",
                style: TextStyle(
                  color: Color(0xff4d46377),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Form Category
              const SizedBox(height: 5),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                  hintText: 'Enter article category',
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.secondary,
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                ),
              ),

              // Label from Description
              const SizedBox(height: 10),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text.withOpacity(0.7),
                ),
              ),

              // Form Description
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 5,
                controller: descriptionController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Enter article description',
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.secondary,
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              // Handle save or update article logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isEdit ? 'Update Article' : 'Create Article',
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
