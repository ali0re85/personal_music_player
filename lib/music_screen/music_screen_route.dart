import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/music_screen/bloc/music_screen_bloc.dart';
import 'package:music_player/music_screen/music_screen.dart';

/// مسیر باز شدن صفحه‌ی پلینگ (اسلاید از پایین + کشیدن به پایین برای بستن).
/// از home_screen.dart و mini_player.dart صدا زده میشه.
Route<void> musicScreenRoute() => _MusicScreenRoute();

class _MusicScreenRoute extends PageRoute<void> {
  _MusicScreenRoute()
    : super(settings: const RouteSettings(name: 'music_screen'));

  /// true وقتی صفحه دست انگشت کاربره (کشیدن + جا افتادن بعد از ولش کردن).
  /// تو این حالت حرکت خطی میشه تا صفحه دقیق دنبال انگشت بیاد.
  bool isUserDragging = false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 450);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 350);

  @override
  bool get maintainState => true;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  /// صفحه‌ی زیرین موقع حرکت کم‌کم تیره میشه
  @override
  Color? get barrierColor => Colors.black54;

  /// گردی گوشه‌های بالا، موقع حرکت
  static const double _maxRadius = 32;

  // باز شدن: شروع سریع و توقف نرم
  static final Animatable<Offset> _slideIn = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeOutQuart));

  // بسته شدن: شروع آروم و خروج سریع
  static final Animatable<Offset> _slideOut = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInCubic));

  // موقع کشیدن با انگشت: خطی، یک به یک با انگشت
  static final Animatable<Offset> _slideLinear = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  );

  // محو شدن فقط توی نیمه‌ی اول حرکت
  static final Animatable<double> _fade = CurveTween(
    curve: const Interval(0, 0.5, curve: Curves.easeOut),
  );

  // گوشه‌ها از گرد به صاف
  static final Animatable<double> _radius = Tween<double>(
    begin: _maxRadius,
    end: 0,
  ).chain(CurveTween(curve: Curves.easeOut));

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return BlocProvider(
      create: (_) => MusicScreenBloc(),
      child: _SwipeDownToDismiss(route: this, child: const MainScreen()),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final slide = isUserDragging
        ? _slideLinear
        : (animation.status == AnimationStatus.reverse ? _slideOut : _slideIn);

    final radius = animation.drive(_radius);

    return FadeTransition(
      opacity: animation.drive(_fade),
      child: SlideTransition(
        position: animation.drive(slide),
        child: AnimatedBuilder(
          animation: radius,
          child: child,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(radius.value),
              ),
              // وقتی صفحه جا افتاد، کلیپ کلاً خاموش میشه
              clipBehavior: radius.value == 0 ? Clip.none : Clip.antiAlias,
              child: child,
            );
          },
        ),
      ),
    );
  }
}

/// کشیدن صفحه به پایین برای بستن (مثل اپل‌میوزیک).
/// مستقیم کنترلر انیمیشن خود route رو با انگشت حرکت میده.
class _SwipeDownToDismiss extends StatefulWidget {
  const _SwipeDownToDismiss({required this.route, required this.child});

  final _MusicScreenRoute route;
  final Widget child;

  @override
  State<_SwipeDownToDismiss> createState() => _SwipeDownToDismissState();
}

class _SwipeDownToDismissState extends State<_SwipeDownToDismiss> {
  /// سرعتی (پیکسل بر ثانیه) که بالاترش یعنی «پرتاب»
  static const double _flingVelocity = 700;

  /// اگه بیشتر از این کسر از صفحه کشیده شد، بسته میشه
  static const double _closeFraction = 0.35;

  bool _canDrag = false;

  AnimationController get _controller => widget.route.controller!;

  void _onDragStart(DragStartDetails details) {
    // فقط وقتی صفحه کامل باز شده اجازه‌ی کشیدن میدیم
    _canDrag = _controller.status == AnimationStatus.completed;

    if (_canDrag) {
      widget.route.isUserDragging = true;
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_canDrag) return;

    final height = context.size?.height ?? MediaQuery.sizeOf(context).height;

    _controller.value -= details.delta.dy / height;
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_canDrag) return;
    _canDrag = false;

    final velocity = details.velocity.pixelsPerSecond.dy;

    final shouldClose = velocity > _flingVelocity
        ? true
        : velocity < -_flingVelocity
        ? false
        : _controller.value < 1 - _closeFraction;

    if (shouldClose) {
      // حالت خطی می‌مونه تا انیمیشن بسته شدن بدون پرش ادامه پیدا کنه
      Navigator.of(context).pop();
    } else {
      _settleOpen();
    }
  }

  void _onDragCancel() {
    if (!_canDrag) return;
    _canDrag = false;

    _settleOpen();
  }

  /// برگردوندن نرم صفحه به حالت باز
  void _settleOpen() {
    _controller
        .animateTo(
          1,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        )
        .whenComplete(() => widget.route.isUserDragging = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      onVerticalDragCancel: _onDragCancel,
      child: widget.child,
    );
  }
}
