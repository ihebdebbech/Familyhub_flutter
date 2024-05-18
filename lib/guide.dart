import 'package:flutter_application_1/pages/mainskeleton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Mainskeleton(selectedIndex: 2)), // Navigate to the new page
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      skipStyle: ButtonStyle(
          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 17)),
          foregroundColor: MaterialStateProperty.all(Colors.redAccent)),
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "",
          bodyWidget: Column(
            children: [
              Text('Your Personal payment  Manager',
                  style: GoogleFonts.mochiyPopOne(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 248, 64, 64))),
              const SizedBox(height: 20),
              const Image(image: AssetImage('assets/images/cashier.jpg')),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Image(image: AssetImage('assets/images/kidwithphone.png')),
              const SizedBox(height: 20),
              Text('enjoy your reels!',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.mochiyPopOne(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 119, 56, 199)))
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('play our games !',
                  style: GoogleFonts.mochiyPopOne(
                      fontSize: 33,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 248, 64, 64))),
              const SizedBox(height: 20),
              const Image(image: AssetImage('assets/images/kidplaying.jpg')),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Image(image: AssetImage('assets/images/paying.png')),
              const SizedBox(height: 20),
              Text('pay easily with our advanced braclet ',
                  style: GoogleFonts.mochiyPopOne(
                      fontSize: 33,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 119, 56, 199))),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Do your Tasks!',
                  style: GoogleFonts.mochiyPopOne(
                      fontSize: 33,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 248, 64, 64))),
              const SizedBox(height: 20),
              const Image(image: AssetImage('assets/images/tasks.png')),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Image(image: AssetImage('assets/images/wishlist.png')),
              const SizedBox(height: 20),
              Text('Put your prefered products on a wishlist!',
                  style: GoogleFonts.mochiyPopOne(
                      fontSize: 33,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 119, 56, 199))),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            children: [
              Text("Do whatever you want!",
                  style: GoogleFonts.mochiyPopOne(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 40, 183, 125))),
              const SizedBox(height: 30),
              Image(
                image: const AssetImage('assets/images/hobbies.png'),
                height: MediaQuery.of(context).size.height / 2,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              Text("We'll manage it for you",
                  style: GoogleFonts.mochiyPopOne(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 37, 119, 128))),
            ],
          ),
        ),
      ],
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      // onChange: (val) {},
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(
        Icons.arrow_forward,
      ),
      done: const Text('Done',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 248, 64, 64))),
      onDone: () => _onIntroEnd(context),
      nextStyle: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all(Color.fromARGB(255, 248, 64, 64))),
      dotsDecorator: const DotsDecorator(
        size: Size.square(10),
        activeColor: Colors.redAccent,
        activeSize: Size.square(17),
      ),
    );
  }
}
