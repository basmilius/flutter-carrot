import 'package:flutter/widgets.dart';

import '../app/extensions/extensions.dart';
import '../components/components.dart';
import '../ui/theme.dart';

class CarrotDebugThemingPreview extends StatelessWidget {
  final CarrotTheme theme;

  const CarrotDebugThemingPreview({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return _PreviewBase(
      theme: theme,
      children: const [
        _PreviewButtons(),
        _PreviewCards(),
        _PreviewNotices(),
        _PreviewTypography(),
      ],
    );
  }
}

class _PreviewBase extends StatelessWidget {
  final List<Widget> children;
  final CarrotTheme theme;

  const _PreviewBase({
    required this.children,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return CarrotThemeProvider(
      theme: theme,
      child: DefaultTextStyle(
        style: theme.typography.body1,
        child: Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.background,
            ),
            child: CarrotScrollView(
              scrollController: ScrollController(),
              child: Padding(
                padding: context.safeArea.add(const EdgeInsets.all(30)),
                child: CarrotColumn(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  gap: 30,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewButtons extends StatelessWidget {
  const _PreviewButtons();

  @override
  Widget build(BuildContext context) {
    return CarrotColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      gap: 9,
      children: [
        CarrotContainedButton(
          icon: "circle-check",
          onTap: () {},
          children: const [Text("Button")],
        ),
        CarrotTextButton(
          icon: "circle-check",
          onTap: () {},
          children: const [Text("Button")],
        ),
        CarrotLinkButton(
          icon: "circle-check",
          onTap: () {},
          children: const [Text("Button")],
        ),
      ],
    );
  }
}

class _PreviewCards extends StatelessWidget {
  const _PreviewCards();

  @override
  Widget build(BuildContext context) {
    return CarrotColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      gap: 9,
      children: const [
        CarrotCard(
          child: CarrotCardContent(
            children: [Text("CarrotCard Widget")],
          ),
        ),
        CarrotCard.flat(
          child: CarrotCardContent(
            children: [Text("CarrotCard(flat) Widget")],
          ),
        ),
      ],
    );
  }
}

class _PreviewNotices extends StatelessWidget {
  const _PreviewNotices();

  @override
  Widget build(BuildContext context) {
    return CarrotColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      gap: 9,
      children: const [
        CarrotNotice(
          title: Text("Title"),
          message: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus in velit vel justo porta pharetra. In nec imperdiet elit. Nulla accumsan lacus elit, sed fermentum dui posuere sit amet."),
        ),
        CarrotNotice(
          isSerious: true,
          title: Text("Title"),
          message: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus in velit vel justo porta pharetra. In nec imperdiet elit. Nulla accumsan lacus elit, sed fermentum dui posuere sit amet."),
        ),
        CarrotNotice(
          isFluid: true,
          title: Text("Title"),
          message: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus in velit vel justo porta pharetra. In nec imperdiet elit. Nulla accumsan lacus elit, sed fermentum dui posuere sit amet."),
        ),
        CarrotNotice(
          isBordered: false,
          isSerious: true,
          title: Text("Title"),
          message: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus in velit vel justo porta pharetra. In nec imperdiet elit. Nulla accumsan lacus elit, sed fermentum dui posuere sit amet."),
        ),
      ],
    );
  }
}

class _PreviewTypography extends StatelessWidget {
  const _PreviewTypography();

  @override
  Widget build(BuildContext context) {
    return CarrotColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      gap: 9,
      children: const [
        CarrotText.display1("Display 1"),
        CarrotText.display2("Display 2"),
        CarrotText.headline1("Headline 1"),
        CarrotText.headline2("Headline 2"),
        CarrotText.headline3("Headline 3"),
        CarrotText.headline4("Headline 4"),
        CarrotText.headline5("Headline 5"),
        CarrotText.headline6("Headline 6"),
        CarrotText.body1("Body 1 - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer rhoncus nibh ut odio imperdiet, aliquam imperdiet nibh mollis. Praesent elementum lorem vel nibh dignissim semper. Donec odio urna, hendrerit sit amet purus in, porttitor lacinia nibh. Nulla vitae gravida odio, et egestas tellus. Duis elementum, dolor non pellentesque sollicitudin, mauris nibh lobortis mi, et euismod turpis dolor et ante. Maecenas dui orci, molestie eget ultricies vitae, mattis nec tellus. Fusce feugiat luctus erat et porta."),
        CarrotText.body2("Body 2 - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer rhoncus nibh ut odio imperdiet, aliquam imperdiet nibh mollis. Praesent elementum lorem vel nibh dignissim semper. Donec odio urna, hendrerit sit amet purus in, porttitor lacinia nibh. Nulla vitae gravida odio, et egestas tellus. Duis elementum, dolor non pellentesque sollicitudin, mauris nibh lobortis mi, et euismod turpis dolor et ante. Maecenas dui orci, molestie eget ultricies vitae, mattis nec tellus. Fusce feugiat luctus erat et porta."),
        CarrotText.subtitle1("Subtitle 1"),
        CarrotText.subtitle2("Subtitle 2"),
      ],
    );
  }
}
