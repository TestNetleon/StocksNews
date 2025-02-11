// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

import 'package:stocks_news_new/utils/utils.dart';

import '../tradingSimulator/modals/stream_data.dart';

StreamRes? streamKeysRes;

enum EventAppsFlyer {
  af_firstopen,
  af_signup,
  af_startsub,
  af_starttrial,
}

enum EventAmplitude {
  amp_firstopen,
  amp_signup,
  // amp_startsub,
  // amp_starttrial,
}

enum EventFirebase {
  f_firstopen,
  f_signup,
  // f_startsub,
  // f_starttrial,
}

enum EventBraze {
  // b_firstopen,
  b_sign_up,
  upgrade_screen_view,
  content_view,
  // b_startsub,
  // b_starttrial,
}

enum RequestType { get, post }

enum SnackbarType { error, info }

enum PolicyType {
  tC,
  privacy,
  disclaimer,
  aboutUs,
  contactUs,
  referral,
  membership
}

enum Status { ideal, loading, loaded, loadingMore, searching, refreshing }

enum StocksType { trending, gainers, losers, actives, gapUp, gapDown }

enum StockStates { sector, industry }

enum InsiderTradingName { company, reporter }

enum TypeTrade { shares, dollar }

enum NotificationType {
  dashboard,
  newsDetail,
  lpPage,
  blogDetail,
  register,
  review,
  stockDetail,
  nudgeFriend,
  ticketDetail,
  referRegistration,
  appUpdate,
  membership,
  pointTransaction,
  simulator,
}

enum MembershipEnum {
  membership,
  hundredPoint,
  twoHundredPoint,
  threeHundredPoint
}

enum BlogsType { blog, author, category, tag }

enum CommentType { reddit, twitter }

enum AddType { alert, watchlist }

enum SocialTrendingType { now, recently, cap }

enum AdPlaces { place1, place2, place3 }

enum AdScreen { home, newsDetail, aiNews }

enum TournamentsHead { tradTotal, pPaid, playTraders, topTitan }

enum TsOrderTypes {
  LIMIT_ORDER,
  BRACKET_ORDER,
  STOP_ORDER,
  TRAILING_ORDER,
  STOP_LIMIT_ORDER,
  RECURRING_ORDER,
  MARKET_ORDER
}

// ------ These are global constants to access in complete app --------
bool isPhone = true;
bool isAppInForeground = false;
bool isShowingError = false;
bool callCheckServer = false;
bool isAppUpdating = false;
bool updateProfile = false;
String apiKeyFMP = "";
bool popHome = false;
Uri? deepLinkData;
bool fromDrawer = false;
Uri? shareUri;
bool onDeepLinking = false;
bool splashLoaded = false;
String? fcmTokenGlobal;
String? appVersion;
bool showMembership = true;
bool signUpVisible = false;
bool notifySnackbar = false;
// this is to set default country code for phone number
String? geoCountryCode;
bool isSVG = false;
bool showAdd = false;
bool oneSignalInitialized = false;
bool withLoginMembership = true;
String? memCODE;
String? appsFlyerUID;
bool isOnTsScreen = false;

// bool memTrack = false;

//------------ Ad API Globals

Map<AdScreen, Map<AdPlaces, bool>> adVisibilityMap = {
  AdScreen.home: {
    AdPlaces.place1: false,
    AdPlaces.place2: false,
    AdPlaces.place3: false,
  },
  AdScreen.newsDetail: {
    AdPlaces.place1: false,
    AdPlaces.place2: false,
    AdPlaces.place3: false,
  },
  AdScreen.aiNews: {
    AdPlaces.place1: false,
    AdPlaces.place2: false,
    AdPlaces.place3: false,
  },
};

// String? clientId;
// String? secret;
// String? createAPI;
// String? exchangeAPI;
// String? holdingsAPI;

//------------------------------------------------

class Images {
  //MARK: New UI
  static const String base = 'assets/images/';
  static const String mainLogo = '${base}splashLogo.png';
  static const String mainBlackLogo = '${base}mainBlackLogo.png';
  static const String notification = '${base}notification.png';
  static const String search = '${base}search.png';

  static const String bottomHome = '${base}bottom_home.png';
  static const String bottomMarket = '${base}bottom_market.png';
  static const String bottomMore = '${base}bottom_more.png';
  static const String bottomSignals = '${base}bottom_signals.png';
  static const String bottomTools = '${base}bottom_tools.png';
  static const String trendingUP = '${base}trending_up.png';
  static const String trendingDOWN = '${base}trending_down.png';

  //-------------------------------------------------------------------------------
  static const String scannerStop = 'assets/images/scanner_stop.png';
  static const String logo = "assets/images/logo.png";
  static const String logoP = "assets/images/logo_holder.png";
  static const String login = "assets/images/log-in.png";
  static const String stockIcon = "assets/images/stock_icon.png";
  static const String signupSuccess = "assets/images/signup_success.png";
  static const String signup = "assets/images/signup.png";
  static const String google = "assets/images/google.png";
  static const String apple = "assets/images/apple.png";
  static const String userPlaceholder = "assets/images/user_placeholder.png";
  static const String placeholder = "assets/images/placeholder.jpg";
  static const String reddit = "assets/images/reddit.png";
  static const String monitor = "assets/images/monitor.png";
  static const String bull = "assets/images/stock_bull.png";
  static const String graphBear = "assets/images/graph_bear.png";
  static const String graphBull = "assets/images/graph_bull.png";
  static const String dotsMenu = "assets/images/dots-menu.png";
  static const String info = "assets/images/info.png";
  static const String graphHolder = "assets/images/graph_placeholder.png";
  static const String portfolioCard = "assets/images/portfolio.png";
  static const String stockIcon3d = "assets/images/stock_icon_3d.png";
  static const String referBack = "assets/images/bg.png";
  static const String coin = "assets/images/coin.png";
  static const String flames = "assets/images/flames.png";
  static const String reward = "assets/images/reward.png";
  static const String temp = "assets/images/temp.png";
  static const String sorting = "assets/images/sorting.png";
  static const String leaderBoard = "assets/images/leaderboard.png";
  static const String nudge = "assets/images/nudge.png";
  static const String starAffiliate = "assets/images/star.png";
  static const String profileBg = "assets/images/profile_bg1.png";
  static const String profile = "assets/images/profile.png";
  static const String rankAffiliate = "assets/images/award.png";
  static const String transaction = "assets/images/transaction.png";
  static const String pointIcon = "assets/images/golden1.png";
  static const String pointIcon2 = "assets/images/golden.png";
  static const String word = "assets/images/word.png";
  static const String arrow = "assets/images/arrow.png";
  static const String bannerImage = "assets/images/banner_image.png";

  static const String pointIcon3 = "assets/images/3_coins.png";
  static const String blackFriday = "assets/images/black_friday.png";

  static const String netflix = "assets/images/nflx.png";
  static const String amazon = "assets/images/amzn.png";
  static const String spotify = "assets/images/spot.png";
  static const String fb = "assets/images/fb.png";
  static const String microsoft = "assets/images/msft.png";
  static const String download = "assets/images/download.png";
  static const String edit = "assets/images/edit.png";
  static const String report = "assets/images/report2.png";

  //Market Data icons
  static const String gainerLoser = "assets/images/gain_lose.png";
  static const String penny = "assets/images/penny.png";
  static const String blogging = "assets/images/blogging.png";
  static const String earnings = "assets/images/earnings.png";
  static const String activities = "assets/images/activities.png";
  static const String advisor = "assets/images/advisor.png";
  static const String dividends = "assets/images/dividends.png";
  static const String technical = "assets/images/stocks.png";
  static const String discount = "assets/images/discount.png";
  static const String performance = "assets/images/performance.png";
  static const String exchange = "assets/images/exchange.png";
  static const String gapUpDown = "assets/images/exchange.png";
  static const String feedback = "assets/images/feedback.png";
  static const String highLow = "assets/images/highLow.png";
  static const String week = "assets/images/calendar.png";
  static const String indices = "assets/images/bank_ind.png";
  static const String insider = "assets/images/insider.png";
  static const String highPE = "assets/images/finance.png";
  static const String ticket = "assets/images/support-ticket.png";
  static const String referT = "assets/images/refer_t.png";
  static const String referW = "assets/images/refer_w.png";
  static const String referE = "assets/images/refer_e.png";
  static const String referS = "assets/images/refer_s.png";
  static const String referF = "assets/images/refer_f.png";
  static const String line = "assets/images/line.png";
  static const String upgrade = "assets/images/upgrade.png";
  static const String graphBG = "assets/images/graph_bg.png";
  static const String graphBG2 = "assets/images/graph_bg2.png";
  static const String graphBG3 = "assets/images/graph_bg3.png";

  //GIF
  static const String trendingGIF = "assets/images/trending.gif";
  static const String coins = "assets/images/coin_Rotate.gif";
  static const String discussedGIF = "assets/images/most_discussed.gif";
  static const String newsGIT = "assets/images/news.gif";
  static const String bearBullGIF = "assets/images/animation_bull_bear.json";
  static const String alertBellGIF = "assets/images/alert_bell.gif";
  static const String progressGIF = "assets/images/progress.gif";
  static const String alertTickGIF = "assets/images/alert_tick.gif";
  static const String alertPopGIF = "assets/images/alerts_GIF.gif";
  static const String otpSuccessGIT = "assets/images/otp_success.gif";
  static const String updateGIF = "assets/images/update.gif";
  static const String serverErrorGIF = "assets/images/server_error.json";
  static const String connectionGIF = "assets/images/connection.gif";
  static const String noDataGIF = "assets/images/nodata_GIF.gif";
  static const String syncGIF = "assets/images/syncGIF.gif";
  static const String portfolioGIF = "assets/images/portfolio.gif";
  static const String otpVerify = "assets/images/otp1.gif";
  static const String referSuccess = "assets/images/success.gif";
  static const String kingGIF = "assets/images/king.gif";
  static const String receiveGIF = "assets/images/receive.gif";
  static const String lockGIF = "assets/images/Lock.gif";
  static const String start1 = "assets/images/1st_page.png";
  static const String start2 = "assets/images/2nd_page.png";
  static const String start3 = "assets/images/3rd_page.png";
  static const String referAndEarn = "assets/images/refer_and_earn.png";
  static const String membership = "assets/images/membership.png";
  static const String newLineBG = "assets/images/newLineBG.png";
  static const String objective = "assets/images/objective.png";
  static const String transferMoney = "assets/images/transfer-money.png";
  static const String economic = "assets/images/ecom.png";
  static const String tickS = "assets/images/tick.png";
  static const String reportS = "assets/images/report.png";
  static const String bellS = "assets/images/bell.png";
  static const String diamondS = "assets/images/diamond.png";
  static const String logoGIF = "assets/images/StocksNews_Logo.gif";
  static const String splashLogoGIF = "assets/images/StocksNews_GIF.gif";
  static const String christmasBell = "assets/images/christmas_bell.gif";
  static const String newYearBell = "assets/images/new-year-bell.png";

  //share
  static const twitter = "assets/images/twitter_share.png";
  static const whatsapp = "assets/images/whatsapp_share.png";
  static const whatsappC = "assets/images/whatsapp_circle.png";

  static const facebook = "assets/images/facebook_share.png";
  static const linkedin = "assets/images/linkedin_share.png";
  static const telegram = "assets/images/telegram_share.png";
  static const ratingIcon = "assets/images/rating_icon.png";
  static const appRating = "assets/images/app_rating.png";
  static const tickFeedback = "assets/images/tick_feedback.png";
  static const String downloadFile = "assets/images/download_file.png";
  static const refer = "assets/images/refer.png";
  static const marketing = "assets/images/marketing.jpeg";
  static const health = "assets/images/health.png";
  static const heart = "assets/images/heart.png";
  static const financialHealth = "assets/images/financial-health.png";
  static const viewReport = "assets/images/research.png";
  static const viewFile = "assets/images/view_file.png";
  static const totalPoints = "assets/images/total_points.png";
  static const activityPoints = "assets/images/activity_point.png";
  static const totalPoint = "assets/images/total_point.png";
  static const pointSpent = "assets/images/point_spent.png";
  static const referPoint = "assets/images/refer_point.png";
  static const morningStarLogoSvg = "assets/images/morningstar_logo.svg";
  static const morningStarLogo = "assets/images/morningstar_logo.png";
  static const beginnerPlan = "assets/images/loyalty.png";
  static const traderPlan = "assets/images/vip-card.png";
  static const portfolio = "assets/images/membership-card.png";
  static const ultimatePlan = "assets/images/member-card.png";
  static const background = "assets/images/background.png";
  static const bg = "assets/images/sync.png";
  static const affWhite = "assets/images/aff_white.png";
  static const storeIcon = "assets/images/store_icon.png";
  static const storeBanner = "assets/images/store_banner.png";
  static const storeBack = "assets/images/store_back.png";
  static const buyPoints = "assets/images/buy_points.png";
  static const congrationTextImage = "assets/images/congration_text_image.jpeg";
  static const congratsGIF = "assets/images/Congrats.gif";
  static const congratsGIF1 = "assets/images/Congrats.png";
  static const pointWithStar = "assets/images/coin_with_star.png";
  static const tringle = "assets/images/tringle.png";
  static const k = "assets/images/k.png";

  //svg
  // static const share = "assets/svg/share.svg";
  // static const buy = "assets/svg/buy.svg";
  // static const credit = "assets/svg/credit.svg";
  // static const profile = "assets/svg/profile.svg";
  // static const purchase = "assets/svg/purchase.svg";
  // // static const login = "assets/svg/login.svg";
  // static const signin = "assets/svg/signin.svg";
  // static const star = "assets/svg/star.svg";
  static const add = "assets/svg/add.svg";
  static const chartHTML = 'assets/html/chart.html';
}

class AudioFiles {
  static const alertWeathlist = "audios/alert_watchlist.mp3";
  static const coinWinAudio = "audios/coin_win.wav";
  static const successCoin = "audios/success_coin.mp3";
  static const refresh = "audios/refresh.wav";
}

class AppIcons {
  // static const String angleDown = "assets/icons/angle-down.svg";
}

class Dimen {
  static const double authScreenPadding = 24;
  static const double padding = 16;
  static const double paddingTablet = 8;
  static const int narrationLength = 500;
  static const double itemSpacing = 12;
  static const double radius = 10;
  static const double homeSpacing = 30;
}

class Pad {
  static const double pad5 = 5;
  static const double pad10 = 10;
  static const double pad16 = 16;
  static const double pad24 = 24;
  static const double pad32 = 32;
  static const double pad999 = 999;
}

class Fonts {
  // static const String roboto = 'Roboto';
  static const String georgia = 'Georgia';
  static const String ptSans = "PTSans";
  static const String merriWeather = "Merriweather";
}

class Const {
  static const String appName = "Stock.News";
  // static const String dateFormat = "dd-MM-yyyy";
  // static const String dateFormat = "yyyy-MM-dd";
  // static const String dateFormatDisplay = "dd-MMM-yyyy";
  // static const String submit = "Submit";
  static String errSomethingWrong =
      "Oops! We encountered a hiccup. Please try again.";
  static String loadingMessage =
      "We are preparing data for you. Please wait...";
  static const String errNoRecord = "No record found.";
  static const String noInternet = "Please check your internet connection.";
  static const String timedOut = "Request timed out.";
  static const String androidAppUrl =
      "https://play.google.com/store/apps/details?id=com.stocks.news";
  static const String iosAppUrl =
      "https://apps.apple.com/us/app/stocks-news/id6476615803";

  static const String membershipLink =
      "https://stocksnews.page.link/membership";

  // static const String errParse =
  //     "Unable to parse data, please check your response.";
  // static const String dummyText =
  //     '''Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dorem ipsum dolor sit amet.\n\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.\n\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur''';
}

class HomeError {
  static const unavailable = "unavailable at this moment.";

  static const sentiment = "Market sentiment is $unavailable";
  static const trending = "Trending is $unavailable";
  static const gainers = "Top Gainers are $unavailable";
  static const ipo = "IPO data is $unavailable";
  static const stockBuzz = "Stock in Popular data is $unavailable";
  static const homeAlert = "Alert data is $unavailable";

  static const loosers = "Top Losers are $unavailable";
  static const insiderTrading = "Insider Trending is $unavailable";
  static const mentions = "Most recent mentions are $unavailable";
  static const news = "News data is $unavailable";
}

class TrendingError {
  static const unavailable = "unavailable at this moment.";

  static const bullish = " Most Bullish is $unavailable";
  static const bearish = "Most Bearish is $unavailable";
  static const sectors = "Trending Sectors are $unavailable";
  static const stories = "Trending Stories are $unavailable";
}

class TopTrendingError {
  static const unavailable = "unavailable at this moment.";

  static const now = "Trending now is $unavailable";
  static const recently = "Trending recently is $unavailable";
  static const cap = "Trending bt market cap is $unavailable";
  static const megaCap = "Mega cap is $unavailable";
  static const largeCap = "Large cap is $unavailable";
  static const mediumCap = "Medium cap is $unavailable";
  static const smallCap = "Small cap is $unavailable";
  static const microCap = "Micro cap is $unavailable";
  static const nanoCap = "Nano cap is $unavailable";
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toDisplayDate() {
    try {
      List<String> dateArray = split('-');
      DateTime dateTime = DateTime.parse(
          "${dateArray[0]}-${num.parse(dateArray[1]).toMonth()}-${num.parse(dateArray[2]).toMonth()}");
      return DateFormat('d MMM yyyy').format(dateTime);
    } catch (e) {
      Utils().showLog("Error  = $e");
      return this;
    }
  }

  String toDisplayDatePdf() {
    try {
      List<String> dateArray = split('-');
      DateTime dateTime = DateTime.parse(
          "${dateArray[0]}-${num.parse(dateArray[1]).toMonth()}-${num.parse(dateArray[2]).toMonth()}");
      return DateFormat('d MMM yy').format(dateTime);
    } catch (e) {
      return this;
    }
  }

  String toDateMonthOnly() {
    try {
      List<String> dateArray = split('-');
      DateTime dateTime = DateTime.parse(
          "${dateArray[0]}-${num.parse(dateArray[1]).toMonth()}-${num.parse(dateArray[2]).toMonth()}");
      return DateFormat('d MMMM').format(dateTime);
    } catch (e) {
      return this;
    }
  }

  String capitalizeWords() =>
      replaceAll(RegExp(' +'), ' ').split(' ').map((str) {
        if (str.isNotEmpty) {
          return str.capitalize();
        } else {
          return str;
        }
      }).join(' ');
}

extension IntExtention on num {
  String toRuppees() {
    if (this == 0) {
      return NumberFormat("\$0").format(this);
    }
    return NumberFormat("\$#,##,##0.00").format(this < 0 ? this * -1 : this);
  }

  String toUSDFormat({bool showDollar = true}) {
    if (this == 0) {
      return showDollar ? NumberFormat("\$0").format(this) : "0";
    }
    return showDollar
        ? NumberFormat.currency(locale: "en_US", symbol: "\$").format(this)
        : NumberFormat("#,##0", "en_US").format(this);
  }

  String toRuppeeFormat() {
    if (this == 0) {
      return NumberFormat("0").format(this);
    }
    return NumberFormat("##,##,##0.00").format(this < 0 ? this * -1 : this);
  }

  String toRuppeeFormatWithoutFloating() {
    if (this == 0) {
      return NumberFormat("0").format(this);
    }
    return NumberFormat("##,##,###").format(this < 0 ? this * -1 : this);
  }

  String toMonth() {
    return NumberFormat("00").format(this);
  }
}

extension CurrencyFormat on num {
  String toCurrency() {
    if (this == 0) return '0';

    String result = abs().toStringAsFixed(2); // Format with 2 decimal places

    // Remove trailing zeros and the decimal point if it's followed by only zeros
    result = result.replaceAll(RegExp(r'\.0+$'), '');

    // Reattach the negative sign if the original number was negative
    if (this < 0) {
      result = '-$result';
    }

    // Trim trailing zeros after the decimal point
    result = result.replaceAll(RegExp(r'(?<=\.\d*?)0+$'), '');

    return result;
  }

  // String toFormattedPrice() {
  //   // Format the number with commas
  //   String formatted = abs().toStringAsFixed(2);
  //   // String formatted = abs().toString();

  //   formatted = formatted.replaceAll(RegExp(r'\.0+$'), '');

  //   formatted = formatted.replaceAll(RegExp(r'(?<=\d)(?=(\d{3})+\.)'), ',');

  //   if (this < 0) {
  //     return '-\$$formatted';
  //   } else {
  //     return '\$$formatted';
  //   }
  // }

  String toFormattedPrice({bool removeSign = false}) {
    // Format the number with two decimal places
    String formatted = abs().toStringAsFixed(2);

    // Remove unnecessary trailing zeroes after the decimal point
    formatted = formatted.replaceAll(RegExp(r'\.0+$'), '');

    // Add commas to the integer part
    formatted = formatted.replaceAll(RegExp(r'(?<=\d)(?=(\d{3})+(?!\d))'), ',');

    // Format the price with a negative sign if the number is negative
    if (removeSign) {
      return '\$$formatted';
    }

    if (this < 0) {
      return '-\$$formatted';
    } else {
      return '\$$formatted';
    }
  }

  // String formatPrice() {
  //   if (this == 0) return '0';
  //   // Format the number to have exactly 3 decimal places
  //   String result = abs().toStringAsFixed(3);
  //   Utils().showLog('Value got: $result');
  //   // If the number is an integer (no decimals), remove the decimal point part
  //   if (result.endsWith('.000')) {
  //     result = result.substring(0, result.length - 4); // Remove ".000"
  //   }
  //   // Add commas to the integer part of the number
  //   List<String> parts = result.split('.');
  //   parts[0] = parts[0].replaceAllMapped(
  //       RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
  //   result = parts.join('.');
  //   // Handle negative numbers by adding a negative sign
  //   if (this < 0) {
  //     result = '-\$$result';
  //   } else {
  //     result = '\$$result';
  //   }
  //   Utils().showLog('Result: $result');
  //   return result;
  // }
}

extension PriceFormatting on num {}

enum DeeplinkEnum {
  blogDetail,
  stocksDetail,
  newsDetail,
  dashboard,
  login,
  signup,
  page,
  insiderTrades,
  trendingIndustries,
  sentiments,
  helpdesk,
  membership,

  //below add for Market data only else add above
  gainerLoser,
  gapUpDown,
  highLowPE,
  fiftyTwoWeeks,
  highLowBeta,
  indices,
  lowPriceStocks,
  mostActive,
  pennyStocks,
  congressional,
  dividents,
  earnings,
  stocks,
  outsider,
}

enum SimulatorEnum {
  open,
  pending,
  transaction,
  detail,
  tradeSheet,
  tournament,
  tournamentTrade,
}

DeeplinkEnum containsSpecificPath(Uri uri) {
  Utils().showLog("-----contain path * $uri");

  // Ensure the URI starts with the correct base URL

  if (!(uri.toString().startsWith("https://app.stocks.news") ||
      uri.toString().startsWith("http://app.stocks.news"))) {
    Utils().showLog("returning Outsider URI");
    return DeeplinkEnum.outsider;
  }

  if (uri.path.contains('/blog/')) {
    // return "blog";
    return DeeplinkEnum.blogDetail;
  } else if (uri.path.contains('/stock-detail')) {
    // return "stock_detail";
    return DeeplinkEnum.stocksDetail;
  } else if (uri.path.contains('/news/')) {
    // return 'news';
    return DeeplinkEnum.newsDetail;
  } else if (uri.toString() == "https://app.stocks.news/" ||
      uri.toString() == "https://app.stocks.news") {
    return DeeplinkEnum.dashboard;
  } else if (uri.path.contains('/login')) {
    // return 'login';
    return DeeplinkEnum.login;
  } else if (uri.path.contains('/sign-up')) {
    // return 'signUp';
    return DeeplinkEnum.signup;
  } else if (uri.path.contains('/page/contact-us')) {
    // return 'page';
    return DeeplinkEnum.helpdesk;
  } else if (uri.path.contains('/page/')) {
    // return 'page';
    return DeeplinkEnum.page;
  } else if (uri.path.contains('/trending-industries')) {
    return DeeplinkEnum.trendingIndustries;
  } else if (uri.path.contains('/membership')) {
    return DeeplinkEnum.membership;
  }

  // Only Market data goes here set else above
  else if (uri.path.contains('/top-gainers') ||
      uri.path.contains('/top-losers') ||
      uri.path.contains('/market-data/breakout-stocks')) {
    // return "gainer_loser";
    return DeeplinkEnum.gainerLoser;
  } else if (uri.path.contains('/stocks/NYSE') ||
      uri.path.contains('/stocks/NASDAQ') ||
      uri.path.contains('/stocks/OTCMKTS') ||
      uri.path.contains('/market-data/dow-30-stocks') ||
      uri.path.contains('/market-data/sp-500-stocks')) {
    // return "indices";
    return DeeplinkEnum.indices;
  } else if (uri.path.contains('/market-data/gap-up-stocks') ||
      uri.path.contains('/market-data/gap-down-stocks')) {
    // return "gapup_gapdown";
    return DeeplinkEnum.gapUpDown;
  } else if (uri.path.contains('/insider-trading')) {
    // return 'insider';
    return DeeplinkEnum.insiderTrades;
  } else if (uri.path.contains('/social-sentiment')) {
    // return 'sentiments';
    return DeeplinkEnum.sentiments;
  } else if (uri.path.contains('/market-data/high-pe-ratio-stocks') ||
      uri.path.contains('/market-data/low-pe-ratio-stocks') ||
      uri.path.contains('/market-data/high-pe-growth-stocks') ||
      uri.path.contains('/market-data/low-pe-growth-stocks')) {
    // return "high_lowPE";
    return DeeplinkEnum.highLowPE;
  } else if (uri.path.contains('/market-data/52-week-highs') ||
      uri.path.contains('/market-data/52-week-lows')) {
    // return "52_weeks";
    return DeeplinkEnum.fiftyTwoWeeks;
  } else if (uri.path.contains('/market-data/high-beta-stocks') ||
      uri.path.contains('/market-data/low-beta-stocks') ||
      uri.path.contains('/market-data/negative-beta-stocks')) {
    // return "high_low_beta";
    return DeeplinkEnum.highLowBeta;
  } else if (uri.path
          .contains('/market-data/low-priced-stocks/stocks-under-50-cents') ||
      uri.path.contains('/market-data/low-priced-stocks/stocks-under-1') ||
      uri.path.contains('/market-data/low-priced-stocks/stocks-under-2') ||
      uri.path.contains('/market-data/low-priced-stocks/stocks-under-5') ||
      uri.path.contains('/market-data/low-priced-stocks/stocks-under-10') ||
      uri.path.contains('/market-data/low-priced-stocks/stocks-under-20') ||
      uri.path.contains('/market-data/low-priced-stocks/stocks-under-30') ||
      uri.path.contains('/market-data/low-priced-stocks/stocks-under-50')) {
    // return "low_prices";
    return DeeplinkEnum.lowPriceStocks;
  } else if (uri.path.contains('/market-data/most-active-stocks') ||
      uri.path.contains('/market-data/most-volatile-stocks') ||
      uri.path.contains('/market-data/unusual-volume-stocks')) {
    // return "most_active";
    return DeeplinkEnum.mostActive;
  } else if (uri.path.contains('/market-data/most-active-penny-stocks') ||
      uri.path.contains('/market-data/top-penny-stocks-today')) {
    // return "penny";
    return DeeplinkEnum.pennyStocks;
  } else if (uri.path.contains('/congress-stock-trades')) {
    // return "congress";
    return DeeplinkEnum.congressional;
  } else if (uri.path.contains('/dividend')) {
    // return "dividend";
    return DeeplinkEnum.dividents;
  } else if (uri.path.contains('/earning')) {
    // return "earning";
    return DeeplinkEnum.earnings;
  } else if (uri.path.contains('/stocks')) {
    // return "stocks";
    return DeeplinkEnum.stocks;
  } else {
    return DeeplinkEnum.dashboard;
  }
}

// String extractLastPathComponent(Uri uri) {
//   try {
//     List<String> parts = uri.pathSegments;

//     if (parts.last.contains("stock-detail") ||
//         uri.queryParameters['symbol'] != null) {
//       return uri.queryParameters['symbol'] ??
//           (parts.isNotEmpty ? parts.last : '');
//     }

//     return parts.isNotEmpty ? parts.last : '';
//   } catch (e) {
//     return '';
//   }
// }

String extractLastPathComponent(Uri uri) {
  try {
    List<String> parts = uri.pathSegments;

    if (parts.contains("stock-detail")) {
      int index = parts.indexOf("stock-detail");
      if (index < parts.length - 1) {
        return parts[index + 2];
      }
    }

    if (uri.queryParameters.containsKey('symbol')) {
      return uri.queryParameters['symbol'] ?? '';
    }

    return parts.isNotEmpty ? parts.last : '';
  } catch (e) {
    return '';
  }
}

// List<Map<String, String>> memPageList = [];

extractCodeFromMEM(Uri uri, String place) {
  Utils().showLog("PLACE $place, $uri");
  try {
    String uriString = uri.toString();

    if (uriString.contains('MEM')) {
      int startIndex = uriString.indexOf('MEM');
      String code = uriString.substring(startIndex);
      Utils().showLog("CODE => $code");

      memCODE = code;

      // memPageList.add({
      //   'place': place,
      //   'code': memCODE ?? "N/A",
      // });
    }
  } catch (e) {
    Utils().showLog("returning code error $e......");
  }
}
// String extractSymbolValue(Uri uri) {
//   if (uri.path.contains('/stock-detail')) {
//     // Check if the query parameters contain 'symbol'
//     if (uri.queryParameters.containsKey('symbol')) {
//       return uri.queryParameters['symbol'] ?? '';
//     }
//   }
//   return '';
// }
