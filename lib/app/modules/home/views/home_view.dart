import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_cdn_web_flutter/app/modules/home/component/pricing_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../../util/key_controller.dart';
import '../../../../util/responsive.dart';
import '../../../component/horizontal_sync.dart';
import '../../../component/hover_button.dart';
import '../../../component/language_selection_widget.dart';
import '../../../component/scroll_progress.dart';
import '../../../routes/app_pages.dart';
import '../component/benefit_card.dart';
import '../component/step_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showLanguageSelector = true; // Переменная для контроля отображения

  String _selectedLanguage = 'English';
  final List<String> languages = ['English', 'Русский', '中文'];

  void _closeLanguageSelector(String selectedLanguage) {
    EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.black);

    setState(() {
      _selectedLanguage = selectedLanguage;
      _showLanguageSelector = false;

      var locale = Locale(
          selectedLanguage == 'English'
              ? 'en'
              : selectedLanguage == 'Русский'
              ? 'ru'
              : 'zh',
          selectedLanguage == 'English'
              ? 'US'
              : selectedLanguage == 'Русский'
              ? 'RU'
              : 'CN');
      Get.updateLocale(locale);
    });

    Future.delayed(Duration(seconds: 1), () {
      EasyLoading.dismiss();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        body: Stack(
          children: [
            _buildMainContent(Colors.grey[100]!),
            _buildHeader(),
            ScrollProgressBar(height: 1),
            if (_showLanguageSelector) _buildLanguageSelector(),
            // Вставляем выбор языка через Stack
          ],
        ),
      ),
      tablet: Scaffold(
        body: Stack(
          children: [
            _buildMainContent(Colors.grey[100]!),
            _buildHeader(),
            ScrollProgressBar(height: 1),
            if (_showLanguageSelector) _buildLanguageSelector(),
          ],
        ),
      ),
      desktop: Scaffold(
        body: Stack(
          children: [
            _buildMainContent(Colors.grey[100]!),
            _buildHeader(),
            ScrollProgressBar(height: 1),
            if (_showLanguageSelector) _buildLanguageSelector(),
          ],
        ),
      ),
    );
  }

  // Виджет для выбора языка
  Widget _buildLanguageSelector() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: 300,

        color: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(
                      "language_selection".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  SizedBox(
                    width: 32,
                  ),
                  InkWell(
                    child: Icon(Icons.close, color: Colors.white),
                    onTap: () {
                      setState(() {
                        _showLanguageSelector = false; // Закрыть выбор языка
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 600,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          "language_select".tr,
                          style: TextStyle(color: Colors.white),
                        ),
                        items: languages
                            .map((String language) => DropdownMenuItem<String>(
                                  value: language,
                                  child: Text(
                                    language,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: _selectedLanguage,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLanguage = newValue!;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[900],
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[700],
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        _closeLanguageSelector(
                            _selectedLanguage); // Закрываем выбор языка после выбора
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      child: Text(
                        "language_change_button".tr,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Color color) {
    return SingleChildScrollView(
      controller: Get.find<KeyController>().scrollController,
      child: Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            _buildHeroSection(Colors.white),
            _buildPartnerSection(),
            _buildBenefitsSection(Colors.white),
            SizedBox(key: Get.find<KeyController>().section1Key),
            _buildHorizontalScrollSync(),
            _buildPricingSection(Colors.white),
            _buildStepsSection(),
            _buildCallToActionSection(Colors.white),
            _buildFooterSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Color color) {
    return Container(
      width: double.infinity,
      color: color,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 4),
          width: 1200,
          child: Responsive.isDesktop(context) || Responsive.isTablet(context)
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            "get_cdn".tr,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Baseline(
                                baseline: 16,
                                baselineType: TextBaseline.alphabetic,
                                child: Container(
                                  width: 3,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text("boost_speed".tr),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Baseline(
                                baseline: 16,
                                baselineType: TextBaseline.alphabetic,
                                child: Container(
                                  width: 3,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text("extra_performance".tr),
                              ),
                            ],
                          ),
                          const SizedBox(height: 64),
                          Row(
                            children: [
                              HoverEffectButton(
                                onPressed: () {},
                                expanded: 1.1,
                                milsec: 150,
                                shrink: 0.8,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () async {
                                    const String url = 'https://user.gocdn.vip';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      throw 'Не удалось открыть $url';
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('get_cdn_button'.tr,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 32),
                              HoverEffectButton(
                                onPressed: () {},
                                expanded: 1.1,
                                milsec: 150,
                                shrink: 0.8,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    Get.find<KeyController>().scrollToSection(
                                      Get.find<KeyController>().section1Key,
                                      1,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('view_packages_button'.tr),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 32),
                    VideoPlayerScreen(),
                  ],
                )
              : IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 8),
                            Text(
                              "get_cdn".tr,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Baseline(
                                  baseline: 16,
                                  baselineType: TextBaseline.alphabetic,
                                  child: Container(
                                    width: 3,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text("boost_speed".tr),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Baseline(
                                  baseline: 16,
                                  baselineType: TextBaseline.alphabetic,
                                  child: Container(
                                    width: 3,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text("extra_performance".tr),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            VideoPlayerScreen(),
                            const SizedBox(height: 32),
                            Responsive.isDesktop(context) ||
                                    Responsive.isTablet(context)
                                ? Row(
                                    children: [
                                      HoverEffectButton(
                                        onPressed: () {},
                                        expanded: 1.1,
                                        milsec: 150,
                                        shrink: 0.8,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () async {
                                            const String url =
                                                'https://user.gocdn.vip';
                                            if (await canLaunchUrl(
                                                Uri.parse(url))) {
                                              await launchUrl(Uri.parse(url));
                                            } else {
                                              throw 'Не удалось открыть $url';
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text('get_cdn_button'.tr,
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 32),
                                      HoverEffectButton(
                                        onPressed: () {},
                                        expanded: 1.1,
                                        milsec: 150,
                                        shrink: 0.8,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () {
                                            Get.find<KeyController>()
                                                .scrollToSection(
                                              Get.find<KeyController>()
                                                  .section1Key,
                                              1,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child:
                                                Text('view_packages_button'.tr),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      HoverEffectButton(
                                        onPressed: () {},
                                        expanded: 1.1,
                                        milsec: 150,
                                        shrink: 0.8,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () async {
                                            const String url =
                                                'https://user.gocdn.vip';
                                            if (await canLaunchUrl(
                                                Uri.parse(url))) {
                                              await launchUrl(Uri.parse(url));
                                            } else {
                                              throw 'Не удалось открыть $url';
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text('get_cdn_button'.tr,
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16,width: 16,),
                                      HoverEffectButton(
                                        onPressed: () {},
                                        expanded: 1.1,
                                        milsec: 150,
                                        shrink: 0.8,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () {
                                            Get.find<KeyController>()
                                                .scrollToSection(
                                              Get.find<KeyController>()
                                                  .section1Key,
                                              1,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child:
                                                Text('view_packages_button'.tr),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                      SizedBox(width: 32),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildPartnerSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      width: double.infinity,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: 1200,
          child: Responsive.isDesktop(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "partners_title".tr,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 32),
                          Text("partners_subtitle".tr,
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    Container(
                      child: Image.network(
                        "assets/partners_white.png",
                        height: 300,
                        width: 300,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "partners_title".tr,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 32),
                        Text("partners_subtitle".tr,
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      width: 300,
                      child: Image.asset(
                        "assets/partners_white.png",
                        height: 300,
                        width: 300,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildBenefitsSection(Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 4),
      color: color,
      width: double.infinity,
      child: Center(
        child: SizedBox(
          width: 1200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "benefits_title".tr,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              Responsive.isDesktop(context)
                  ? IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BenefitCard(
                            icon: EvaIcons.powerOutline,
                            title: "benefit1_title".tr,
                            description: "benefit1_description".tr,
                          ),
                          BenefitCard(
                            icon: Icons.rocket_launch_sharp,
                            title: "benefit2_title".tr,
                            description: "benefit2_description".tr,
                          ),
                          BenefitCard(
                            icon: Icons.attach_money_sharp,
                            title: "benefit3_title".tr,
                            description: "benefit3_description".tr,
                          ),
                        ],
                      ),
                    )
                  : IntrinsicHeight(
                      child: SizedBox(
                        width: 800,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BenefitCard(
                              icon: EvaIcons.powerOutline,
                              title: "benefit1_title".tr,
                              description: "benefit1_description".tr,
                            ),
                            BenefitCard(
                              icon: Icons.rocket_launch_sharp,
                              title: "benefit2_title".tr,
                              description: "benefit2_description".tr,
                            ),
                            BenefitCard(
                              icon: Icons.attach_money_sharp,
                              title: "benefit3_title".tr,
                              description: "benefit3_description".tr,
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollSync() {
    return HorizontalScrollSync(
      verticalScrollController: Get.find<KeyController>().scrollController,
      itemCount: 50,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 42),
          child: HoverEffectButton(
            onPressed: () {},
            expanded: 1.0,
            milsec: 150,
            shrink: 1.0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red.withOpacity(0.3)),
              alignment: Alignment.center,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'GO '.tr,
                    style: TextStyle(
                      color: index % 2 == 0 ? Colors.black : Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'CDN'.tr,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPricingSection(Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 4),
      color: color,
      width: double.infinity,
      child: Center(
        child: Container(
          width: 1200,
          child: Column(
            children: [
              Text(
                "pricing_title".tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              SizedBox(
                height: 32,
              ),
              Responsive.isDesktop(context) || Responsive.isTablet(context)
                  ? IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: PricingCard(
                              title: "ultimate_title".tr,
                              price: "ultimate_price".tr,
                              description: "ultimate_description".tr,
                              additional: 'ultimate_additional'.tr,
                            ),
                          ),
                          Expanded(
                            child: PricingCard(
                              title: "premium_title".tr,
                              price: "premium_price".tr,
                              description: "premium_description".tr,
                              additional: 'premium_additional'.tr,
                            ),
                          ),
                          Expanded(
                            child: PricingCard(
                              title: "basic_title".tr,
                              price: "basic_price".tr,
                              description: "basic_description".tr,
                              additional: 'basic_additional'.tr,
                            ),
                          ),
                        ],
                      ),
                    )
                  : IntrinsicHeight(
                      child: SizedBox(
                        width: 450,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: PricingCard(
                                title: "ultimate_title".tr,
                                price: "ultimate_price".tr,
                                description: "ultimate_description".tr,
                                additional: 'ultimate_additional'.tr,
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Expanded(
                              child: PricingCard(
                                title: "premium_title".tr,
                                price: "premium_price".tr,
                                description: "premium_description".tr,
                                additional: 'premium_additional'.tr,
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Expanded(
                              child: PricingCard(
                                title: "basic_title".tr,
                                price: "basic_price".tr,
                                description: "basic_description".tr,
                                additional: 'basic_additional'.tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepsSection() {
    return Container(
      width: double.infinity,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          width: 1200,
          child: Column(
            children: [
              Text(
                "steps_title".tr,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                "steps_subtitle".tr,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 16,
              ),
              Responsive.isDesktop(context) || Responsive.isTablet(context)
                  ? IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StepCard(
                            sufWidget: '1',
                            step: "step1_title".tr,
                            description: "step1_description".tr,
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          StepCard(
                            sufWidget: '2',
                            step: "step2_title".tr,
                            description: "step2_description".tr,
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          StepCard(
                            sufWidget: '3',
                            step: "step3_title".tr,
                            description: "step3_description".tr,
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          StepCard(
                            sufWidget: '4',
                            step: "step4_title".tr,
                            description: "step4_description".tr,
                          ),
                        ],
                      ),
                    )
                  : IntrinsicHeight(
                      child: SizedBox(
                        width: 450,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StepCard(
                              sufWidget: '1',
                              step: "step1_title".tr,
                              description: "step1_description".tr,
                            ),
                            StepCard(
                              sufWidget: '2',
                              step: "step2_title".tr,
                              description: "step2_description".tr,
                            ),
                            StepCard(
                              sufWidget: '3',
                              step: "step3_title".tr,
                              description: "step3_description".tr,
                            ),
                            StepCard(
                              sufWidget: '4',
                              step: "step4_title".tr,
                              description: "step4_description".tr,
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallToActionSection(Color color) {
    return Container(
      color: color,
      alignment: Alignment.center,
      width: double.infinity,
      child: Center(
        child: Center(
          child: Container(
            width: 1200,
            margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Responsive.isDesktop(context)
                ? Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "cta_title".tr,
                            style: TextStyle(fontSize: 36),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      HoverEffectButton(
                        onPressed: () {},
                        expanded: 1.1,
                        milsec: 150,
                        shrink: 0.8,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => print("hello"),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'cta_button'.tr,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                    ],
                  )
                : IntrinsicHeight(
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "cta_title".tr,
                              style: TextStyle(fontSize: 36),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        HoverEffectButton(
                          onPressed: () {},
                          expanded: 1.1,
                          milsec: 150,
                          shrink: 0.8,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => print("hello"),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'cta_button'.tr,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: SizedBox(
              width: 1400,
              height: 70,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(1),
                      Colors.white.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 1400,
                        child: Row(
                          children: [
                            Responsive.isDesktop(context) ||
                                    Responsive.isTablet(context)
                                ? SizedBox(
                                    width: 16,
                                  )
                                : SizedBox(),
                            HoverEffectButton(
                              onPressed: () async {
                                Get.toNamed(Routes.HOME);
                              },
                              expanded: 1.1,
                              milsec: 150,
                              shrink: 0.8,
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 4, top: 3, bottom: 3),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1.0,
                                      ),
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8)),
                                  width: 120,
                                  height: 60,
                                  child:
                                      Image.asset('assets/logo_gocdn-2.png')),
                            ),
                            const Spacer(),
                            HoverEffectButton(
                              onPressed: () {},
                              expanded: 1.1,
                              milsec: 150,
                              shrink: 0.8,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async {
                                  const String url = 'https://user.gocdn.vip';
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    throw 'Не удалось открыть $url';
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('get_cdn_button'.tr,
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                            Responsive.isDesktop(context) ||
                                    Responsive.isTablet(context)
                                ? SizedBox(
                                    width: 16,
                                  )
                                : SizedBox(),
                            HoverEffectButton(
                              onPressed: () {},
                              expanded: 1.1,
                              milsec: 150,
                              shrink: 0.8,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async {
                                  const String url = 'https://user.gocdn.vip';
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    throw 'Не удалось открыть $url';
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 4, top: 3, bottom: 3),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    EvaIcons.person,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Responsive.isDesktop(context) ||
                                    Responsive.isTablet(context)
                                ? SizedBox(
                                    width: 16,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildFooterSection(BuildContext context) {
  return Container(
    width: double.infinity,
    color: Colors.black87,
    child: Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (Responsive.isDesktop(context)) ...[
              // Mobile Layout
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialMediaIcon(icon: Icons.facebook),
                  SocialMediaIcon(icon: Icons.alternate_email),
                  SocialMediaIcon(icon: Icons.linked_camera),
                  SocialMediaIcon(icon: Icons.video_call),
                  SocialMediaIcon(icon: Icons.photo_camera),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FooterLink(text: 'footer_copyright'.tr),
                  FooterLink(text: 'footer_privacy'.tr),
                  FooterLink(text: 'footer_terms'.tr),
                  FooterLink(text: 'footer_security'.tr),
                  FooterLink(text: 'footer_cookies'.tr),
                  FooterLink(text: 'footer_trademark'.tr),
                ],
              ),
            ] else ...[
              IntrinsicHeight(
                child: Wrap(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Wrap(
                            children: [
                              SocialMediaIcon(icon: Icons.facebook),
                              SocialMediaIcon(icon: Icons.alternate_email),
                              SocialMediaIcon(icon: Icons.linked_camera),
                              SocialMediaIcon(icon: Icons.video_call),
                              SocialMediaIcon(icon: Icons.photo_camera),
                            ],
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            children: [
                              FooterLink(text: 'footer_copyright'.tr),
                              FooterLink(text: 'footer_privacy'.tr),
                              FooterLink(text: 'footer_terms'.tr),
                              FooterLink(text: 'footer_security'.tr),
                              FooterLink(text: 'footer_cookies'.tr),
                              FooterLink(text: 'footer_trademark'.tr),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class SocialMediaIcon extends StatelessWidget {
  final IconData icon;

  const SocialMediaIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: HoverEffectButton(
        onPressed: () => print("0"),
        expanded: 1.1,
        milsec: 150,
        shrink: 0.9,
        child: Icon(
          icon,
          size: MediaQuery.of(context).size.width < 600
              ? 24
              : 32, // Размер иконки для мобильной версии меньше
          color: Colors.white,
        ),
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;

  const FooterLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: HoverEffectButton(
        onPressed: () => print("0"),
        expanded: 1.1,
        milsec: 150,
        shrink: 0.9,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: MediaQuery.of(context).size.width < 600
                ? 12
                : 14, // Размер текста для мобильной версии меньше
          ),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/head.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
        child: _controller.value.isInitialized
            ? Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
