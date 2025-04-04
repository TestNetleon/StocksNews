import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/service/appsFlyer/service.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/utils/utils.dart';

class EventsService {
  EventsService._internal();
  static final EventsService _instance = EventsService._internal();
  static EventsService get instance => _instance;

  final List<EventLogger> _services = [
    AmplitudeLogger(),
    BrazeLogger(),
    AppsFlyerLogger(),
  ];

  void _logEvent(String eventName) {
    for (final service in _services) {
      try {
        service.logEvent(eventName);
      } catch (e) {
        Utils().showLog('Failed to log event with ${service.runtimeType}: $e');
      }
    }
  }

//MARK: Notification
  void notificationPopUp({bool allow = false}) =>
      _logEvent(allow ? 'allow_notifications' : 'dont_allow_notifications');

  //MARK: Location Permission Events
  void locationPermission(String type) {
    final Map<String, String> eventNames = {
      'once': 'allow_once_to_use_your_location',
      'always': 'allow_while_using_app_to_use_your_location',
      'deny': 'dont_allow_to_use_your_location'
    };
    final eventName = eventNames[type] ?? 'unknown_location_permission';
    _logEvent(eventName);
  }

  //MARK: On Boarding
  void onBoardingSKIP() => _logEvent('click_skip_onboarding_page');
  void onBoardingGOTO_7DAY() =>
      _logEvent('click_try_premium_7days_for_free_onboarding_page');

  //MARK: ATT Permission Events
  void onATTpermission({bool allow = false}) => _logEvent(allow
      ? 'allow_track_activity_across_other_companies'
      : 'ask_app_not_to_track_track_activity_across_other_companies');

  //MARK: Welcome Screen Events
  void closeWelcome() => _logEvent('close_welcome_page');
  void selectCountryCodeWelcome() => _logEvent('select_country_welcome_page');
  void selectEnterPhoneNumberWelcome() =>
      _logEvent('enter_phone_number_welcome_page');
  void selectCheckBoxWelcome() => _logEvent('check_box_welcome_page');
  void selectReadMoreWelcome() => _logEvent('read_more_welcome_page');
  void selectContinueWelcome() => _logEvent('click_continue_welcome_page');
  void selectContinueGoogleWelcome() =>
      _logEvent('continue_with_google_welcome_page');
  void selectContinueAppleWelcome() =>
      _logEvent('continue_with_apple_welcome_page');

  // OTP Verification Events
  void enterCodeOTPVerification() => _logEvent('enter_code_otp_verification');
  void resendCodeOTPVerification() => _logEvent('resend_code_otp_verification');

  // Home Page Events
  void myAccountHomePage() => _logEvent('my_account_home_page');
  void searchHomePage() => _logEvent('search_home_page');
  void notificationsHomePage() => _logEvent('notifications_home_page');
  void enterPostHomePage() => _logEvent('enter_post_home_page');
  void joinEliteProgramHomePage() => _logEvent('join_elite_program_home_page');
  void homeHomePage() => _logEvent('home_home_page');
  void scannerHomePage() => _logEvent('scanner_home_page');
  void simulatorHomePage() => _logEvent('simulator_home_page');
  void newsHomePage() => _logEvent('news_home_page');
  void toolsHomePage() => _logEvent('tools_home_page');
  void selectMarketScannerHomePage() =>
      _logEvent('select_market_scanner_home_page');
  void clickHereTextHomePage() => _logEvent('click_here_text_stocks_home_page');
  void clickViewAllPopularStocksHomePage() => _logEvent('click_view_all_popular_stocks_home_page');
  void selectStockPopularStocksHomePage() => _logEvent('select_stock_popular_stocks_home_page');
  void clickViewAllMostBoughtMembersHomePage() => _logEvent('click_view_all_most_bought_members_home_page');
  void selectAaplScannerHomePage() => _logEvent('select_aapl_scanner_home_page');
  void clickSyncYourPortfolioHomePage() => _logEvent('click_sync_your_portfolio_home_page');
  void clickTrendingHomePage() => _logEvent('click_trending_home_page');
  void clickTopGainersHomePage() => _logEvent('click_top_gainers_home_page');
  void clickTopLosersHomePage() => _logEvent('click_top_losers_home_page');
  void viewAllTopInsiderTradesHomePage() => _logEvent('view_all_top_insider_trades_home_page');
  void viewAllTopPoliticiansTradesHomePage() => _logEvent('view_all_top_politicians_trades_home_page');

  // Scanner Page Events
  void scannerTabPage({int? index=0}) => _logEvent(
    index==0?'scanner_tab_scanner_page':index==1?'gainers_tab_scanner_page':'losers_tab_scanner_page'
  );
  void filterByScannerTabScannerPage() => _logEvent('filter_by_scanner_tab_scanner_page');
  void sortByScannerTabScannerPage() => _logEvent('sort_by_scanner_tab_scanner_page');
  void openHdScannerTabScannerPage() => _logEvent('open_hd_scanner_tab_scanner_page');

  void sortByGainerTabChangePage({int? innerIndex=0}) => _logEvent(
      innerIndex==0?'sort_by_gainers_tab_percent_change_tab_scanner_page':'sort_by_gainers_tab_volume_tab_scanner_page'
  );
  void sortByLoserTabChangePage({int? innerIndex=0}) => _logEvent(
      innerIndex==0?'sort_by_losers_tab_percent_change_tab_scanner_page':'sort_by_losers_tab_volume_tab_scanner_page'
  );

  void openTnonGainersTabChangePage({int? innerIndex=0}) => _logEvent(
      innerIndex==0?'open_tnon_gainers_tab_percent_change_tab_scanner_page':'open_tnon_gainers_tab_volume_tab_scanner_page'
  );
  void openTnonLosersTabChangePage({int? innerIndex=0}) => _logEvent(
      innerIndex==0?'open_cnsp_losers_tab_percent_change_tab_scanner_page':'open_azo_losers_tab_volume_tab_scanner_page'
  );

  void backMarketScannerFilter() => _logEvent('back_market_scanner_filter');
  void enterSymbolCompanyNamemarketScannerFilter() => _logEvent('enter_symbol_company_namemarket_scanner_filter');
  void enterBidStartMarketScannerFilter() => _logEvent('enter_bid_start_market_scanner_filter');
  void enterBidEndMarketScannerFilter() => _logEvent('enter_bid_end_market_scanner_filter');
  void enterAskStartMarketScannerFilter() => _logEvent('enter_ask_start_market_scanner_filter');
  void enterAskEndMarketScannerFilter() => _logEvent('enter_ask_end_market_scanner_filter');
  void enterLastTradeStartMarketScannerFilter() => _logEvent('enter_last_trade_start_start_market_scanner_filter');
  void enterLastTradeEndMarketScannerFilter() => _logEvent('enter_last_trade_end_market_scanner_filter');
  void enterNetChangeStartMarketScannerFilter() => _logEvent('enter_net_change_start_market_scanner_filter');
  void enterNetChangeEndMarketScannerFilter() => _logEvent('enter_net_change_end_market_scanner_filter');
  void enterChangeStartMarketScannerFilter() => _logEvent('enter_%_change_start_market_scanner_filter');
  void enterChangeEndMarketScannerFilter() => _logEvent('enter_%_change_end_market_scanner_filter');
  void enterVolumeStartMarketScannerFilter() => _logEvent('enter_volume_start_market_scanner_filter');
  void enterVolumeEndMarketScannerFilter() => _logEvent('enter_volume_end_market_scanner_filter');
  void enterDVolumeStartMarketScannerFilter() => _logEvent('enter_\$_volume_start_market_scanner_filter');
  void enterDVolumeEndMarketScannerFilter() => _logEvent('enter_\$_volume_end_market_scanner_filter');

  void clickResetMarketScannerFilter() => _logEvent('click_reset_market_scanner_filter');
  void clickApplyMarketScannerFilter() => _logEvent('click_apply_market_scanner_filter');
  void symbolNameUpDownScannerTabPage({String? type}) => _logEvent(
      type==SortByEnums.symbol.name?
      'symbol_name_up/down_scanner_tab_scanner_page':
      type==SortByEnums.company.name?
      'company_name_up/down_scanner_tab_scanner_page':
      type==SortByEnums.postMarket.name?
      'pre_market_price_name_up/down_scanner_tab_scanner_page':
      type==SortByEnums.postMarketNetChange.name?
      'pre_market_net_change_name_up/down_scanner_tab_scanner_page':
      type==SortByEnums.postMarketPerChange.name?
      'pre_market_percentage_change_name_up/down_scanner_tab_scanner_page':
      type==SortByEnums.lastTrade.name?
      'last_trade_price_up/down_scanner_tab_scanner_page':
      type==SortByEnums.netChange.name?
      'net_change_up/down_scanner_tab_scanner_page':
      type==SortByEnums.perChange.name?
      'percentage_change_up/down_scanner_tab_scanner_page':
      type==SortByEnums.volume.name?
      'volume_up/down_scanner_tab_scanner_page':
      type==SortByEnums.dollarVolume.name?
      '\$volume_up/down_scanner_tab_scanner_page':
      type==SortByEnums.bid.name?
      'bid_price_up/down_scanner_tab_scanner_page':
      'ask_price_up/down_scanner_tab_scanner_page'
  );

  void symbolNameUpDownGainerTabPage({String? type}) => _logEvent(
      type==SortByEnums.symbol.name?
      'symbol_name_up/down_gainers_tab_scanner_page':
      type==SortByEnums.company.name?
      'company_name_up/down_gainers_tab_scanner_page':
      type==SortByEnums.postMarket.name?
      'pre_market_price_name_up/down_gainers_tab_scanner_page':
      type==SortByEnums.postMarketNetChange.name?
      'pre_market_net_change_name_up/down_gainers_tab_scanner_page':
      type==SortByEnums.postMarketPerChange.name?
      'pre_market_percentage_change_name_up/down_gainers_tab_scanner_page':
      type==SortByEnums.lastTrade.name?
      'last_trade_price_up/down_gainers_tab_scanner_page':
      type==SortByEnums.netChange.name?
      'net_change_up/down_gainers_tab_scanner_page':
      type==SortByEnums.perChange.name?
      'percentage_change_up/down_gainers_tab_scanner_page':
      type==SortByEnums.volume.name?
      'volume_up/down_gainers_tab_scanner_page':
      type==SortByEnums.dollarVolume.name?
      '\$volume_up/down_gainers_tab_scanner_page':
      type==SortByEnums.bid.name?
      'bid_price_up/down_gainers_tab_scanner_page':
      type==SortByEnums.ask.name?
      'ask_price_up/down_gainers_tab_scanner_page':
      'sector_wise_up/down_gainers_tab_scanner_page'
  );

  void symbolNameUpDownLoserTabPage({String? type}) => _logEvent(
      type==SortByEnums.symbol.name?
      'symbol_name_up/down_losers_tab_scanner_page':
      type==SortByEnums.company.name?
      'company_name_up/down_losers_tab_scanner_page':
      type==SortByEnums.postMarket.name?
      'pre_market_price_name_up/down_losers_tab_scanner_page':
      type==SortByEnums.postMarketNetChange.name?
      'pre_market_net_change_name_up/down_losers_tab_scanner_page':
      type==SortByEnums.postMarketPerChange.name?
      'pre_market_percentage_change_name_up/down_losers_tab_scanner_page':
      type==SortByEnums.lastTrade.name?
      'last_trade_price_up/down_losers_tab_scanner_page':
      type==SortByEnums.netChange.name?
      'net_change_up/down_losers_tab_scanner_page':
      type==SortByEnums.perChange.name?
      'percentage_change_up/down_losers_tab_scanner_page':
      type==SortByEnums.volume.name?
      'volume_up/down_losers_tab_scanner_page':
      type==SortByEnums.dollarVolume.name?
      '\$volume_up/down_losers_tab_scanner_page':
      type==SortByEnums.bid.name?
      'bid_price_up/down_losers_tab_scanner_page':
      type==SortByEnums.ask.name?
      'ask_price_up/down_losers_tab_scanner_page':
      'sector_wise_up/down_losers_tab_scanner_page'
  );

  void clickStockScannerPage({String? type}) => _logEvent(
      type=="overview"?
      'click_stock_overview_scanner_tab_scanner_page':
      type=="buy"?
      'click_buy_order_scanner_tab_scanner_page':
      type=="sell"?
      'click_sell_order_scanner_tab_scanner_page':
      type=="short"?
      'click_short_order_order_scanner_tab_scanner_page':
      type=="btc"?
      'click_buy_to_cover_order_order_scanner_tab_scanner_page':
      ''
  );

  void clickStockGainerPage({String? type}) => _logEvent(
      type=="overview"?
      'click_stock_overview_gainers_tab_percent_change_tab_scanner_page':
      type=="buy"?
      'click_buy_order_gainers_tab_percent_change_tab_scanner_page':
      type=="sell"?
      'click_sell_order_gainers_tab_percent_change_tab_scanner_page':
      type=="short"?
      'click_short_order_order_gainers_tab_percent_change_tab_scanner_page':
      type=="btc"?
      'click_buy_to_cover_order_order_gainers_tab_percent_change_tab_scanner_page':
      ''
  );
  void clickStockLoserPage({String? type}) => _logEvent(
      type=="overview"?
      'click_stock_overview_losers_tab_percent_change_tab_scanner_page':
      type=="buy"?
      'click_buy_order_losers_tab_percent_change_tab_scanner_page':
      type=="sell"?
      'click_sell_order_losers_tab_percent_change_tab_scanner_page':
      type=="short"?
      'click_short_order_order_losers_tab_percent_change_tab_scanner_page':
      type=="btc"?
      'click_buy_to_cover_order_order_losers_tab_percent_change_tab_scanner_page':
      ''
  );

}

abstract class EventLogger {
  void logEvent(String eventName);
}

class AmplitudeLogger implements EventLogger {
  @override
  void logEvent(String eventName) {
    AmplitudeService.instance.logEvent(eventName);
  }
}

class BrazeLogger implements EventLogger {
  @override
  void logEvent(String eventName) {
    BrazeService.brazeBaseEvents(eventName: eventName);
  }
}

class AppsFlyerLogger implements EventLogger {
  @override
  void logEvent(String eventName) {
    AppsFlyerService.instance.appsFlyerLogEvent(eventName);
  }
}



///Events
///allow_notifications
///dont_allow_notifications
///
///allow_once_to_use_your_location
///allow_while_using_app_to_use_your_location
///dont_allow_to_use_your_location
///
///click_skip_onboarding_page
///click_try_premium_7days_for_free_onboarding_page
///
///ask_app_not_to_track_track_activity_across_other_companies
///allow_track_activity_across_other_companies
///
///close_welcome_page
///select_country_welcome_page
///enter_phone_number_welcome_page
///check_box_welcome_page
///read_more_welcome_page
///click_continue_welcome_page
///continue_with_google_welcome_page
///continue_with_apple_welcome_page
///
///enter_code_otp_verification
///resend_code_otp_verification
///
///close_select_plan_page
///select_monthly_basic_plan_select_plan_page
///select_yearly_basic_plan_select_plan_page
///unlock_basic_plan_basic_plan_select_plan_page
///montly_basic_plan_clicked
///montly_basic_plan_received
///montly_basic_plan_clicked : to know if user click to buy
///montly_basic_plan_received: to know if you received the transition
///monthly_basic_plan_clicked
///annual_basic_plan_received
///select_monthly_pro_plan_select_plan_page
///select_yearly_pro_plan_select_plan_page
///unlock_pro_plan_pro_plan_select_plan_page
///montly_pro_plan_clicked
///montly_pro_plan_received
///montly_pro_plan_clicked : to know if user click to buy
///montly_pro_plan_received: to know if you received the transition
///monthly_pro_plan_clicked
///annual_pro_plan_received
///select_monthly_elite_plan_select_plan_page
///select_yearly_elite_plan_select_plan_page
///unlock_elite_plan_elite_plan_select_plan_page
///montly_elite_plan_clicked
///montly_elite_plan_received
///montly_elite_plan_clicked : to know if user click to buy
///montly_elite_plan_received: to know if you received the transition
///monthly_elite_plan_clicked
///annual_elite_plan_received
///my_account_home_page
///search_home_page
///notifications_home_page
///enter_post_home_page
///join_elite_program_home_page
///simulator_home_page
///scanner_home_page
///home_home_page
///news_home_page
///tools_home_page
///select_market_scanner_home_page
///click_here_text_stocks_home_page
///cancel_message_stocks_to_67903
///send_message_stocks_to_67903
///click_view_all_popular_stocks_home_page
///select_stock_popular_stocks_home_page
///click_view_all_most_bought_members_home_page
///select_aapl_scanner_home_page
///click_sync_your_portfolio_home_page
///click_trending_home_page
///click_top_losers_home_page
///click_top_gainers_home_page
///click_continue_use_plaid_to_connect_your_account
///view_all_top_insider_trades_home_page
///view_all_top_politicians_trades_home_page
///scanner_tab_scanner_page
///losers_tab_scanner_page
///gainers_tab_scanner_page
///sort_by_scanner_tab_scanner_page
///filter_by_scanner_tab_scanner_page
///open_hd_scanner_tab_scanner_page
///simulator_scanner_page
///scanner_scanner_page
///home_scanner_page
///news_scanner_page
///tools_scanner_page
///back_market_scanner_filter
///enter_symbol_company_namemarket_scanner_filter
///enter_bid_start_market_scanner_filter
///enter_bid_end_market_scanner_filter
///enter_ask_start_market_scanner_filter
///enter_ask_end_market_scanner_filter
///enter_last_trade_start_start_market_scanner_filter
///enter_last_trade_end_market_scanner_filter
///enter_net_change_start_market_scanner_filter
///enter_net_change_end_market_scanner_filter
///enter_%_change_start_market_scanner_filter
///enter_%_change_end_market_scanner_filter
///enter_volume_start_market_scanner_filter
///enter_volume_end_market_scanner_filter
///enter_$_volume_start_market_scanner_filter
///enter_$_volume_end_market_scanner_filter
///click_reset_market_scanner_filter
///click_apply_market_scanner_filter
///symbol_name_up/down_scanner_tab_scanner_page
///company_name_up/down_scanner_tab_scanner_page
///pre_market_price_name_up/down_scanner_tab_scanner_page
///pre_market_net_change_name_up/down_scanner_tab_scanner_page
///pre_market_percentage_change_name_up/down_scanner_tab_scanner_page
///last_trade_price_up/down_scanner_tab_scanner_page
///net_change_up/down_scanner_tab_scanner_page
///percentage_change_up/down_scanner_tab_scanner_page
///volume_up/down_scanner_tab_scanner_page
///$volume_up/down_scanner_tab_scanner_page
///bid_price_up/down_scanner_tab_scanner_page
///ask_price_up/down_scanner_tab_scanner_page
///click_stock_overview_scanner_tab_scanner_page
///click_buy_order_scanner_tab_scanner_page
///click_sell_order_scanner_tab_scanner_page
///click_short_order_order_scanner_tab_scanner_page
///click_buy_to_cover_order_order_scanner_tab_scanner_page
///sort_by_gainers_tab_percent_change_tab_scanner_page
///open_tnon_gainers_tab_percent_change_tab_scanner_page
///click_stock_overview_gainers_tab_percent_change_tab_scanner_page
///click_buy_order_gainers_tab_percent_change_tab_scanner_page
///click_sell_order_gainers_tab_percent_change_tab_scanner_page
///click_short_order_order_gainers_tab_percent_change_tab_scanner_page
///click_buy_to_cover_order_order_gainers_tab_percent_change_tab_scanner_page
///sort_by_gainers_tab_volume_tab_scanner_page
///open_tnon_gainers_tab_volume_tab_scanner_page
///symbol_name_up/down_gainers_tab_scanner_page
///company_name_up/down_gainers_tab_scanner_page
///company_name_up/down_gainers_tab_scanner_page
///pre_market_net_change_name_up/down_gainers_tab_scanner_page
///pre_market_percentage_change_name_up/down_gainers_tab_scanner_page
///last_trade_price_up/down_gainers_tab_scanner_page
///net_change_up/down_gainers_tab_scanner_page
///percentage_change_up/down_gainers_tab_scanner_page
///volume_up/down_gainers_tab_scanner_page
///$volume_up/down_gainers_tab_scanner_page
///bid_price_up/down_gainers_tab_scanner_page
///ask_price_up/down_gainers_tab_scanner_page
///sector_wise_up/down_gainers_tab_scanner_page
///sort_by_losers_tab_percent_change_tab_scanner_page
///open_cnsp_losers_tab_percent_change_tab_scanner_page
///click_stock_overview_losers_tab_percent_change_tab_scanner_page
///click_buy_order_losers_tab_percent_change_tab_scanner_page
///click_sell_order_losers_tab_percent_change_tab_scanner_page
///click_short_order_order_losers_tab_percent_change_tab_scanner_page
///click_buy_to_cover_order_order_losers_tab_percent_change_tab_scanner_page
///sort_by_losers_tab_volume_tab_scanner_page
///open_azo_losers_tab_volume_tab_scanner_page
///symbol_name_up/down_losers_tab_scanner_page
///company_name_up/down_losers_tab_scanner_page
///pre_market_price_name_up/down_losers_tab_scanner_page
///pre_market_net_change_name_up/down_losers_tab_scanner_page
///pre_market_percentage_change_name_up/down_losers_tab_scanner_page
///last_trade_price_up/down_losers_tab_scanner_page
///net_change_up/down_losers_tab_scanner_page
///percentage_change_up/down_losers_tab_scanner_page
///volume_up/down_losers_tab_scanner_page
///$volume_up/down_losers_tab_scanner_page
///bid_price_up/down_losers_tab_scanner_page
///ask_price_up/down_losers_tab_scanner_page
///sector_wise_up/down_losers_tab_scanner_page
///place_new_order_open_tab_simulator_page
///simulator_simulator_page
///scanner_simulator_page
///home_simulator_page
///news_simulator_page
///tools_simulator_page
///place_new_order_pending_tab_simulator_page
///place_new_order_transactions_tab_simulator_page
///open_featured_post_news_page
///simulator_news_page
///scanner_news_page
///home_news_page
///news_news_page
///tools_news_page
///open_from_sources_post_news_page
///click_market_data_tools_page
///click_signals_tools_page
///click_sync_your_portfolio_tools_page
///click_compare_stocks_tools_page
///click_tranding_league_tools_page
///simulator_tools_page
///scanner_tools_page
///home_tools_page
///news_tools_page
///tools_tools_page
///back_market_data_page_tools_page
///search_market_data_page_tools_page
///select_stocks_market_data_page_tools_page
///select_stocks_market_data_page_tools_page
///select_sectors_market_data_page_tools_page
///select_most_bullish_market_data_page_tools_page
///select_most_bearish_market_data_page_tools_page
///click_crox_most_bullish_tab_market_data_page_tools_page
///click_technology_sectors_market_data_tools_page
///click_healthcare_sectors_market_data_tools_page
///click_consumer_cyclical_sectors_market_data_tools_page
///click_industries_sectors_market_data_tools_page
///back_stocks_signals_tools_page
///search_stocks_signals_tools_page
///select_stocks_stocks_signals_tools_page
///select_politicial_stocks_signals_tools_page
///select_sentiment_stocks_signals_tools_page
///select_insiders_stocks_signals_tools_page
///open_rnst_stocks_signals_tools_page
///back_sentiment_signals_tools_page
///search_sentiment_signals_tools_page
///select_stocks_sentiment_signals_tools_page
///select_politicial_sentiment_signals_tools_page
///select_sentiment_sentiment_signals_tools_page
///select_insiders_sentiment_signals_tools_page
///open_tsla_most_mentioned_stocks_sentiment_signals_tools_page
///back_insiders_signals_tools_page
///search_insiders_signals_tools_page
///filters_insiders_signals_tools_page
///open/close_drct_insiders_signal_tool_page
///click_view_details_drct_insiders_signal_tool_page
///back_politicians_signals_tools_page
///search_politicians_signals_tools_page
///open/close_cost_politicians_signal_tool_page
///back_compare_stocks_tools_page
///remove_brand_from_compare_list_tools_page
///add_brand_to_compare_list_tools_page
///back_add_new_brand_compare_stocks_tools_page
///back_trading_league_tools_page
///select_league_trading_league_tools_page
///select_my_trades_trading_league_tools_page
///select_leaderboard_trading_league_tools_page
///trading_leagues_trading_league_tools_page
///trading_titan_trading_league_tools_page
///points_paid_trading_league_tools_page
///click_play_game_league_tools_page
///view_more_top_trading_titans_league_tools_page
///back_leaderboard_trading_league_tools_page
///click_backward_calendar_trading_league_tools_page
///click_forward_calendar_trading_league_tools_page
///select_specific_day_trading_league_tools_page
///back_my_trades_trading_league_tools_page
///select_all_my_trades_trading_league_tools_page
///select_open_my_trades_trading_league_tools_page
///select_close_my_trades_trading_league_tools_page
///click_place_new_trade_my_trades_trading_league_tools_page