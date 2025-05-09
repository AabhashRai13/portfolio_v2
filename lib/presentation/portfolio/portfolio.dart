import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/portfolio/portfolio_desktop.dart';
import 'package:my_portfolio/presentation/portfolio/portfolio_mobile.dart';
import 'package:my_portfolio/presentation/responsive/responsive.dart';

class Portfolio extends StatelessWidget {
  const Portfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: PortfolioMobileTab(),
      tablet: PortfolioMobileTab(),
      desktop: const PortfolioDesktop(),
    );
  }
}
