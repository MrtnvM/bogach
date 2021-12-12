import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/recommendations/courses/recommendation_course.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseItem extends HookWidget {
  const CourseItem(this.course);

  final RecommendationCourse course;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = useAdaptiveMediaQueryData();
    final size = useAdaptiveSize();
    final borderRadius = BorderRadius.all(Radius.circular(size(4)));

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => launch(
        course.url,
        forceSafariVC: true,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: mediaQuery.size.width - size(16) * 2,
        ),
        height: size(192),
        margin: EdgeInsets.all(size(16)),
        decoration: BoxDecoration(
          color: ColorRes.bookItemBackground,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.grey.withAlpha(150),
            )
          ],
        ),
        child: MediaQuery(
          data: mediaQuery,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: _CourseImage(imageUrl: course.imageUrl),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _CourseInfo(course: course),
              ),
              Positioned(
                top: size(8),
                right: size(8),
                child: _CourseSourceLogo(source: course.source),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseInfo extends HookWidget {
  const _CourseInfo({Key? key, required this.course}) : super(key: key);

  final RecommendationCourse course;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    final startDateFormatter = DateFormat('d MMMM');

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(size(4))),
      ),
      padding: EdgeInsets.only(
        top: size(8),
        left: size(12),
        right: size(12),
        bottom: size(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.profession,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: Styles.bodyWhiteBold.copyWith(fontSize: 12),
          ),
          SizedBox(height: size(2)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${course.salaryText} ',
                  style: Styles.body2.copyWith(fontSize: 12),
                ),
                TextSpan(
                  text: course.salaryValue.toPrice(),
                  style: Styles.bodyBold.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: size(2)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${Strings.startCourseDate}',
                  style: Styles.body2.copyWith(fontSize: 12),
                ),
                TextSpan(
                  text: '${startDateFormatter.format(course.startDate)}',
                  style: Styles.bodyBold.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseImage extends HookWidget {
  const _CourseImage({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _CourseSourceLogo extends HookWidget {
  const _CourseSourceLogo({Key? key, required this.source}) : super(key: key);

  final String source;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    if (source == 'SkillFactory') {
      return Image.asset(
        Images.skillFactoryLogo,
        width: size(75),
      );
    }

    return const SizedBox();
  }
}
