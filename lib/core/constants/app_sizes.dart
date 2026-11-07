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
  static const double gutter = 12;
  static const double bottomOverlayClearance = 126;

  // ---- Breakpoints and content width (Windows and tablets) ----
  static const double breakpointMedium = 600;
  static const double contentMaxWidth = 480;

  // ---- Radii ----
  static const double radiusSm = 4;
  static const double radiusDefault = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 22;
  static const double radius2xl = 28;
  static const double radiusFull = 9999;

  // ---- Semantic radii ----
  static const double radiusCard = radiusXl;
  static const double radiusHero = radius2xl;
  static const double radiusButton = 20;
  static const double radiusInput = radiusLg;
  static const double radiusChip = radiusFull;
  static const double radiusSheet = 30;
  static const double radiusSegment = radiusMd;
  static const double radiusSegmentTrack = radiusLg;
  static const double radiusNavBar = 30;

  // ---- Strokes ----
  static const double borderHairline = 1;
  static const double borderField = 1.5;
  static const double borderEmphasis = 2;

  // ---- Dashed outline ----
  static const double dashLength = 6;
  static const double dashGap = 5;

  // ---- Elevation as shadow geometry ----
  static const double shadowBlurHairline = 2;
  static const double shadowOffsetYHairline = 1;
  static const double shadowBlurSoft = 24;
  static const double shadowOffsetYSoft = 8;
  static const double shadowBlurActive = 24;
  static const double shadowOffsetYActive = 10;
  static const double shadowBlurSegment = 8;
  static const double shadowOffsetYSegment = 2;
  static const double shadowBlurSwitchThumb = 6;
  static const double shadowOffsetYSwitchThumb = 2;

  // ---- Icons ----
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // ---- Components ----
  static const double minTapTarget = 48;
  static const double buttonHeight = 56;
  static const double textButtonHeight = 48;
  static const double inputHeight = 54;
  static const double chipHeight = 40;
  static const double segmentHeight = 40;
  static const double stepperButtonSize = 36;
  static const double stepperValueMinWidth = 28;
  static const double iconButtonSize = 44;
  static const double pillTileSize = 44;
  static const double pillTileRadius = 14;
  static const double dangerBadgeSize = 64;
  static const double dangerBadgeIcon = 30;
  static const double radioSize = 24;
  static const double radioDotSize = 12;
  static const double radioBorder = 2;
  static const double radioRowPaddingVertical = 16;
  static const double radioRowPaddingHorizontal = 6;
  static const double timeFieldHeight = 72;
  static const double timeFieldFontSize = 30;
  static const double progressBarHeight = 8;
  static const double bottomNavHeight = 74;
  static const double bottomNavMargin = 16;
  static const double bottomNavBottomGap = 18;
  static const double bottomNavFadeHeight = 140;
  static const double bottomNavBlur = 40;
  static const double bottomNavOffsetY = 14;
  static const double navLabelBottomPadding = 12;
  static const double navIconLabelGap = 4;
  static const double navIndicatorSize = 56;
  static const double navIndicatorRise = 18;
  static const double navIndicatorRing = 6;
  static const double navIndicatorBlur = 22;
  static const double navIndicatorOffsetY = 10;
  static const double navIconRise = 27;
  static const double navHopPeak = -26;
  static const double navHopLanding = 3;
  static const double navHopShrink = 0.86;
  static const double navHopStretch = 1.14;
  static const double navHopRisePhase = 45;
  static const double navHopFallPhase = 33;
  static const double navHopSettlePhase = 22;

  // ---- Switch ----
  static const double switchWidth = 52;
  static const double switchHeight = 32;
  static const double switchThumbSize = 24;
  static const double switchInset = 4;
  static const double switchTapHeight = 40;
  static const double disabledOpacity = 0.55;

  // ---- Headers ----
  static const double headerBlurSigma = 18;
  static const double headerEyebrowHeight = 30;
  static const double headerEyebrowGap = 10;
  static const double headerTopGap = 10;
  static const double headerCollapsedTopGap = 8;
  static const double headerBottomExpanded = 14;
  static const double headerBottomCollapsed = 10;
  static const double headerEyebrowPaddingStart = 10;
  static const double headerEyebrowPaddingEnd = 12;
  static const double headerEyebrowIconGap = 6;
  static const double headerRowGap = 12;
  static const double innerHeaderPadding = 16;
  static const double fabSize = 56;
  static const double doseCheckSize = 40;
  static const double avatarBadge = 20;
  static const double avatarXs = 28;
  static const double avatarSm = 40;
  static const double avatarMd = 48;
  static const double avatarLg = 64;
  static const double avatarXl = 96;
  static const double logoSplash = 96;
  static const double logoHeader = 32;
  static const double logoAuth = 64;

  /// How far the splash text may extend past each side of the splash logo.
  static const double splashTextOverflow = 120;
  static const double sheetHandleWidth = 40;
  static const double sheetHandleHeight = 5;
  static const double sheetTopPadding = 10;
  static const double sheetHandleGap = 18;
  static const double sheetBottomPadding = 28;
  static const double sheetMaxHeightFactor = 0.85;

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
  static const double fontHeroCollapsed = 22;
  static const double fontHeroMobile = 30;
  static const double fontTitle = 20;
  static const double fontInnerHeader = 18;
  static const double fontSection = 17;
  static const double fontStat = 20;
  static const double fontBodyBold = 16;
  static const double fontBody = 15;
  static const double fontChip = 14;
  static const double fontBodySecondary = 13;
  static const double fontCaption = 12;
  static const double fontTimeSlot = 14;
  static const double fontBadge = 11;
  static const double fontNav = 11;

  // ---- Line heights (px; the text theme divides by font size) ----
  static const double lineHero = 36;
  static const double lineHeroMobile = 35;
  static const double lineTitle = 28;
  static const double lineSection = 24;
  static const double lineStat = 26;
  static const double lineBodyBold = 22;
  static const double lineBody = 21;
  static const double lineBodySecondary = 18;
  static const double lineCaption = 16;
  static const double lineTimeSlot = 18;
  static const double lineBadge = 14;
  static const double lineNav = 14;

  // ---- Letter spacing ----
  static const double letterSpacingHero = -0.64;
  static const double letterSpacingDisplay = -0.6;
  static const double letterSpacingTitle = -0.2;
}
