import 'package:intl/intl.dart';
import 'package:stocks_news_new/utils/utils.dart';

enum RequestType { get, post }

enum SnackbarType { error, info }

enum PolicyType { tC, privacy, disclaimer, aboutUs, contactUs }

enum Status { ideal, loading, loaded, loadingMore, searching, refreshing }

enum StocksType { trending, gainers, losers, actives, gapUp, gapDown }

enum StockStates { sector, industry }

enum InsiderTradingName { company, reporter }

enum NotificationType { dashboard, newsDetail, lpPage, blogDetail }

enum BlogsType { blog, author, category, tag }

enum CommentType { reddit, twitter }

enum AddType { alert, watchlist }

enum SocialTrendingType { now, recently, cap }

// ------ These are global constants to access in complete app --------
bool isPhone = true;
bool isAppInForeground = false;
bool isShowingError = false;
String apiKeyFMP = "";

String? clientId;
String? secret;
String? createAPI;
String? exchangeAPI;
String? holdingsAPI;

//------------------------------------------------

class Images {
  static const String logo = "assets/images/logo.png";
  static const String logoP = "assets/images/logo_holder.png";
  static const String stockIcon = "assets/images/stock_icon.png";
  static const String signupSuccess = "assets/images/signup_success.png";
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

  //GIF
  static const String trendingGIF = "assets/images/trending.gif";
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

  static const String start1 = "assets/images/1st_page.png";
  static const String start2 = "assets/images/2nd_page.png";
  static const String start3 = "assets/images/3rd_page.png";

  //share
  static const twitter = "assets/images/twitter_share.png";
  static const whatsapp = "assets/images/whatsapp_share.png";
  static const whatsappC = "assets/images/whatsapp_circle.png";

  static const facebook = "assets/images/facebook_share.png";
  static const linkedin = "assets/images/linkedin_share.png";
  static const telegram = "assets/images/telegram_share.png";
  static const ratingIcon = "assets/images/rating_icon.png";
}

class AudioFiles {
  static const alertWeathlist = "audios/alert_watchlist.mp3";
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
}

class Fonts {
  static const String roboto = 'Roboto';
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
  static const String errSomethingWrong =
      "Oops! We encountered a hiccup. Please try again.";
  static const String errNoRecord = "No record found.";
  static const String noInternet = "Please check your internet connection.";
  static const String timedOut = "Request timed out.";
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

  String toRuppeeFormat() {
    if (this == 0) {
      return NumberFormat("0").format(this);
    }
    return NumberFormat("##,##,##0.00").format(this < 0 ? this * -1 : this);
  }

  String toMonth() {
    return NumberFormat("00").format(this);
  }
}

extension CurrencyFormat on num {
  String toCurrency() {
    if (this == 0) {
      return '0';
    }

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
}
