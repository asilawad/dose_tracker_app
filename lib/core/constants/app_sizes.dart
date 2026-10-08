/// Every spacing, radius, size, stroke and font metric used by the UI.
///
/// Spacing, radii and font metrics come from the design tokens. Component
/// sizes (buttons, inputs, nav, FAB) are estimates taken from the mockups,
/// so tune them here and every screen follows. All values are logical pixels.
abstract final class AppSizes {
  // ---- Spacing scale ----
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 14;
  static const double spaceLg = 16;
  static const double spaceXl = 20;
  static const double space2xl = 24;
  static const double space3xl = 32;

  // ---- Layout ----
  static const double screenPaddingHorizontal = 20;
  static const double gutter = 14;
  static const double bottomOverlayClearance = 96;

  // ---- Breakpoints and content width (Windows and tablets) ----
  static const double breakpointMedium = 600;
  static const double contentMaxWidth = 480;

  // ---- Radii ----
  static const double radiusSm = 4;
  static const double radiusDefault = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 9999;

  // ---- Semantic radii ----
  static const double radiusCard = radiusXl;
  static const double radiusButton = radiusFull;
  static const double radiusInput = radiusLg;
  static const double radiusChip = radiusFull;
  static const double radiusSheet = radiusXl;

  // ---- Strokes ----
  static const double borderHairline = 1;
  static const double borderEmphasis = 2;

  // ---- Elevation as shadow geometry ----
  static const double shadowBlurSoft = 16;
  static const double shadowOffsetYSoft = 4;
  static const double shadowBlurActive = 20;
  static const double shadowOffsetYActive = 8;

  // ---- Icons ----
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // ---- Components ----
  static const double minTapTarget = 48;
  static const double buttonHeight = 52;
  static const double inputHeight = 52;
  static const double progressBarHeight = 8;
  static const double bottomNavHeight = 64;
  static const double fabSize = 56;
  static const double doseCheckSize = 32;
  static const double avatarSm = 40;
  static const double avatarMd = 48;
  static const double avatarLg = 64;
  static const double avatarXl = 96;
  static const double logoSplash = 96;
  static const double logoHeader = 32;
  static const double logoAuth = 64;
  static const double sheetHandleWidth = 40;
  static const double sheetHandleHeight = 4;

  // ---- Onboarding ----
  static const double onboardingIllustrationSize = 240;
  static const double iconHero = 96;
  static const double pageDotSize = 8;
  static const double pageDotActiveWidth = 24;

  // ---- Input limits (characters) ----
  static const int passwordMinLength = 8;
  static const int nameMinLength = 2;
  static const int nameMaxLength = 40;
  static const int securityAnswerMinLength = 2;

  // ---- Font sizes ----
  static const double fontHero = 32;
  static const double fontHeroMobile = 26;
  static const double fontTitle = 22;
  static const double fontSection = 18;
  static const double fontStat = 20;
  static const double fontBodyBold = 16;
  static const double fontBody = 15;
  static const double fontBodySecondary = 13;
  static const double fontTimeSlot = 13;
  static const double fontBadge = 11;
  static const double fontNav = 11;

  // ---- Line heights (px; the text theme divides by font size) ----
  static const double lineHero = 38;
  static const double lineHeroMobile = 32;
  static const double lineTitle = 28;
  static const double lineSection = 24;
  static const double lineStat = 24;
  static const double lineBodyBold = 22;
  static const double lineBody = 21;
  static const double lineBodySecondary = 18;
  static const double lineTimeSlot = 16;
  static const double lineBadge = 14;
  static const double lineNav = 14;

  // ---- Letter spacing ----
  static const double letterSpacingTimeSlot = 0.5;
}
