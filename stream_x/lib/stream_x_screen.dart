import 'package:flutter/material.dart';
import 'dart:ui';

class StreamXScreen extends StatelessWidget {
  const StreamXScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFF1997F0);
    final Color backgroundColor = isDarkMode ? const Color(0xFF101B22) : const Color(0xFFF6F7F8);
    final Color cardBackgroundColor = isDarkMode ? const Color.fromRGBO(30, 41, 59, 0.5) : Colors.white;
    final Color textColor = isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF0D161C);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF4B799B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'StreamX',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildUrlInputSection(primaryColor, secondaryTextColor, backgroundColor, isDarkMode),
                  const SizedBox(height: 24),
                  _buildVideoPreviewSection(primaryColor, cardBackgroundColor, textColor, secondaryTextColor),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          )
        ],
      ),
      bottomSheet: _buildStickyMiniPlayer(isDarkMode, textColor, secondaryTextColor),
    );
  }

  Widget _buildUrlInputSection(Color primaryColor, Color secondaryTextColor, Color backgroundColor, bool isDarkMode) {
    final Color darkMutedTextColor = const Color(0xFFCBD5E1);
    final Color darkBorderColor = const Color(0xFF334155);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YouTube URL',
          style: TextStyle(
            color: isDarkMode ? darkMutedTextColor : const Color(0xFF0D161C),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Paste YouTube URL here',
            hintStyle: TextStyle(color: secondaryTextColor),
            filled: true,
            fillColor: isDarkMode ? backgroundColor : Colors.white,
            suffixIcon: Icon(Icons.content_paste, color: secondaryTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDarkMode ? darkBorderColor : const Color(0xFFCFDDE8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDarkMode ? darkBorderColor : const Color(0xFFCFDDE8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
            minimumSize: const Size(double.infinity, 52),
            elevation: 5,
            shadowColor: primaryColor.withOpacity(0.3),
          ),
          child: const Text(
            'Search Video',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreviewSection(Color primaryColor, Color cardBackgroundColor, Color textColor, Color secondaryTextColor) {
    return Column(
      children: [
        Card(
          color: cardBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0.5,
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuC0KQ-p-vWYc1_hel-BT2QYoJw0tOQ8fdNuaBqgjnbnjgeu8ncpsdjl7gxKODMnLQqoqAWQSOr-lCntaRckUWZkWkDrIdV3JYSScPT7oXFudfOEjaebEtZFBM_r4R0IjK3QZhpB6iCFLvf9kEcvFJkDZtqYO5Q5y9Vixrz_u0cvwcTjyB788dg8dwHjZ1rg8XUgiZz-sAd9B8TPZAd4AxJBDSqx_4LLkTH8rKWQMGXyVH3aY-0hJwHWLh9dnnM5YQwcBgU5LJgxRG2a',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow, size: 40),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      label: Text('Video Loaded', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w500)),
                      backgroundColor: primaryColor.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lofi Hip Hop Radio - Beats to Relax/Study to',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lofi Girl',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.headphones),
                label: const Text('Audio Only'),
                style: _playbackButtonStyle(primaryColor),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_in_picture_alt),
                label: const Text('PiP Mode'),
                style: _playbackButtonStyle(primaryColor),
              ),
            ),
          ],
        )
      ],
    );
  }

  ButtonStyle _playbackButtonStyle(Color primaryColor) {
    return ElevatedButton.styleFrom(
      foregroundColor: primaryColor,
      backgroundColor: primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9999),
      ),
      minimumSize: const Size(0, 56),
      elevation: 0,
    );
  }

  Widget _buildStickyMiniPlayer(bool isDarkMode, Color textColor, Color secondaryTextColor) {
    final Color miniPlayerBackgroundColor = isDarkMode ? const Color.fromRGBO(15, 23, 42, 0.8) : Colors.white.withOpacity(0.8);

    return Container(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Material(
            color: miniPlayerBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC8iRzO7nVZe3hrFhAJ6I1ESR3O0cTQBaBAeb7MJrNTyZzR7oC1iSX9eIjw103dMiaMaw3KJ9HZXRs5DQyLLtJlIP6bVww1wDaAYBY6TPdzMYNggLZTRll7mGcGpXLPWsybfOWyuWBZLMNz2mgiWp-IfQ-j0S81zoceSQ_OqDOeDdTuZWpgwfoOp6-_2Jwsh-_TesdZottsgWLWTea_zo0hPMDTqAWb6-SjN71_QwMHxAIN1JbjDV5gjrE-RdItgpGpLgZLy2fK8rz1',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lofi Hip Hop Radio - Beats to Relax/Study to',
                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Lofi Girl',
                          style: TextStyle(color: secondaryTextColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause, size: 30),
                    color: textColor,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: textColor,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
