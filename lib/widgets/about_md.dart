import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../utils/about/handle_link_tap.dart';

class AboutMd extends StatefulWidget {
  const AboutMd({super.key});

  @override
  State<AboutMd> createState() => _AboutMdState();
}

class _AboutMdState extends State<AboutMd> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: MarkdownWidget(
        data: '''
# 壁紙リサイズとは
画像の大きさが壁紙として合わない場合にリサイズできるアプリです。
# このアプリを作ったきっかけ
このアプリはXでの[アイデア募集](https://x.com/nomin_coding/status/1817913632145154144)から誕生しました。
# 開発者へのご連絡
## 通常のお問い合わせ
- [Discord](https://discord.com/invite/C2nc3uHj)
- [Twitter](https://x.com/nomin_coding)
- [GitHub](https://github.com/nomindes)
- [Instagram](https://www.instagram.com/sena.gadget_/)
- [nomincoding@gmail.com](mailto:nomincoding@gmail.com)
- [Coconala](https://coconala.com/users/4766421)
## 法的観点からのお問い合わせ
- [nomincoding@gmail.com](mailto:nomincoding@gmail.com)
こちらのお問い合わせは優先して返信いたします。
# ライセンス
[ライセンス条件](license)
''',
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        config: MarkdownConfig(configs: [
          LinkConfig(
            style: const TextStyle(fontSize: 20, color: Colors.blue),
            onTap: (url) => handleLinkTap(context, url),
          )
        ]),
      ),
    );
  }
}