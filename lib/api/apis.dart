// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';

class Apis {
  // maintenance
  static const baseUrlLocal = "https://notification.stocks.news/api/v1";

  // With Debug condition
  static const baseUrl = kDebugMode
      ? "https://dev.stocks.news/api/v2"
      : "https://app.stocks.news/api/v2";

  // Main live server
  // static const baseUrl = "https://app.stocks.news/api/v2";

  // MARK: New UI APIs
  static const onBoarding = '/onboarding';
  static const myHome = '/home-new';
  static const homeTrendingGainerLoser = '/home-popular-gainer-loser';
  // static const myHome = '/home';
  static const myHomePopular = '/todays-popular';
  static const myHomeMostBought = '/most-purchased-stocks';

  static const compareStocks = '/compare';
  static const addCompareStock = '/add-compare';
  static const deleteCompareStock = '/delete-compare';
  // static const myHomePremium = '/home-premium';
  static const myHomePremium = '/home-premium-new';
  static const tools = '/tools';
  static const savePlaid = '/save-plaid-portfolio';
  static const getPortfolio = '/plaid-portfolio';
  static const removePortfolio = '/remove-plaid-portfolio';
  static const myHomeWatchlist = '/home-watchlist-data';
  static const marketData = '/market-data';
  static const notificationSettings = '/notification-settings';
  static const phoneLogin = '/phone-login';
  static const googleLogin = "/signup-google";
  static const appleLogin = "/signup-apple";
  static const logout = "/logout";
  static const deleteUser = '/delete-user';
  static const alerts = "/alerts";
  static const deleteAlert = "/delete-alert";
  static const watchlist = "/watchlist";
  static const deleteWatchlist = "/delete-watchlist";
  static const faqs = "/faq";
  static const getTickets = "/get-tickets";
  static const sendTicket = "/send-ticket";
  static const ticketDetail = "/ticket-detail";
  static const ticketReply = "/ticket-reply";
  static const feedback = "/feedback";
  static const shareFeedback = "/share-feedback";
  static const notifications = "/notifications";

  // Referral
  static const referral = "/referrals/list";
  static const referralTransaction = "/referrals/txn-report";
  static const leaderboard = "/referrals/leaderboard";
  static const redeemList = "/point-claim-list";
  static const pointClaim = "/point-claim";

  //MARK: Crypto API
  static const cryptoTabs = "/crypto/tab";
  static const cryptoHome = "/crypto/home";
  static const cryptoBillionaireDetails = "/crypto/billionaire-details";
  static const cryptoDetails = "/crypto/crypto-details";
  static const cryptoChart = "/crypto/crypto-chart";
  static const cryptoViewAll = "/crypto/crypto-view-all";
  static const cryptoWatchList = "/crypto/my-watchlist";
  static const addWatch = "/crypto/add-to-crypto-watchlist";
  static const removeWatch = "/crypto/remove-crypto-watchlist";
  static const addFav = "/crypto/add-to-favorite-person";
  static const removeFav = "/crypto/remove-favorite-person";
  static const billionaireTweets = "/crypto/billionaire-tweets";
  static const viewAll = "/crypto/all-billionaires";
  static const cryptoFiat = "/crypto/converter";
  static const cryptoSearchSymbol = "/crypto/crypto-search-data";
  static const cryptoSearchCurrency = "/crypto/currency-search-data";
  static const cryptoExchange = "/crypto/exchange";

  //MARK: Simulator API
  static const tsUserInfo = "/simulator/user-info";
  static const tsTopBar = "/simulator/trade/stock-detail-topbar";
  static const tsStreamData = '/simulator/trade/stream-init-variables';
  static const tsOrderList = "/simulator/holding-list";
  static const tsPendingList = "/simulator/pending-list";
  static const tsTransaction = '/simulator/trade/history';
  static const tradingMostSearch = "/simulator/most-search-symbol";
  static const tsRequestTrade = "/simulator/trade/store";
  static const tsAddConditional = "/simulator/trade/add-conditional-order/";
  static const tsSearchSymbol = "/simulator/trade/search-symbol";
  static const tsOpenList = "/simulator/list-purchased-shares";
  static const stockHoldings = '/simulator/stock-holdings-new';
  static const recurringHoldings = '/simulator/recurring-holdings';
  static const recurringList = '/simulator/recurring-list';
  static const recurringClose = '/simulator/recurring-close/';
  static const recurringDetail = '/simulator/recurring-detail/';
  static const holidaysList = '/simulator/market-holidays';
  static const cancleOrder = '/simulator/trade/cancel/';
  static const updateOrder = '/simulator/trade/update/';
  static const orderTypeInfo = '/simulator/trade/order-type-definition';
  static const squareOff = '/simulator/trade/close-conditional-trade';

  //MARK: TOURNAMENT API
  static const lTabs = '/home-tab';
  static const t = '/tournaments';
  static const tLeaderboard = '/tournament/leaderboard/by-date';
  static const tTradeList = '/tournament/trade-list';
  static const tDetail = '/tournament/detail';
  static const tJoin = '/tournament/join';
  static const tTickerList = '/tournament/ticker-list';
  static const tTickerSearch = '/tournament/ticker-search';
  static const tTickerDetail = '/tournament/ticker-detail';
  static const tBuyOrSell = '/tournament/trade-action';
  static const tCancle = '/tournament/trade-close';
  static const tPointsPaid = '/tournament/points-paid';
  static const tPlayTraders = '/tournament/titans';
  static const tTopTitans = '/tournament/top-titans';
  static const tTradingTotal = '/tournament/all';
  static const tUser = '/tournament/user-profile';
  static const tShowLeaderboard = '/tournament/show-today-leaderboard';
  static const tTradeAll = '/tournament/league-date/trade-list';

  //Search---
  static const recentSearch = '/recent-search';
  static const searchWithNews = '/search-with-news';
  static const search = "/search";
  //Signals---
  static const signalStocks = '/signals/stocks';
  static const signalSentiment = '/signals/sentiment';
  static const signalInsiders = '/signals/insiders';
  static const signalPoliticians = '/signals/politicians';
  //News---
  static const newsCategories = '/news-categories';
  static const news = '/news';
  static const newsDetail = '/news-detail';
  static const sendFeedback = "/send-feedback";
  //Blogs---
  static const secureBlogs = "/secure-blogs";
  static const secureBlogDetail = '/secure-blog-detail';

  //Subscription
  static const subscription = '/subscription';
  static const mySubscription = "/my-subscription";
  static const subscriptionLayout = '/check-membership-layout';

  static const infoPage = '/info-page';
  static const updateProfile = "/update-profile";
  static const checkEmailExist = '/check-email-exist';
  static const verifyEmail = '/verify-email';
  static const checkPhoneExist = '/check-phone-exist';

  //Stock Detail
  static const sdTab = '/stock-tab-bar';
  static const sdOverview = "/stock-detail-overview";
  static const sdHistoricalC = "/stock-historical-chart";
  static const sdKeyStats = '/stock-detail-key-stats';
  static const sdStocksAnalysis = '/stock-analysis';
  static const sdTechnicalAnalysis = '/technical-analysis';
  static const sdAnalystForecast = '/stock-detail-forecast';
  static const sdLatestNews = '/stock-detail-news';
  static const sdEarnings = '/stock-detail-earning';
  static const sdDividends = '/stock-detail-dividend';
  static const sdInsiderTrades = '/stock-detail-insider';
  static const sdCompetitors = '/stock-detail-competitor';
  static const sdFinancials = '/stock-detail-financial';
  static const sdSecFiling = '/stock-detail-secFiling';
  static const sdMergers = '/stock-detail-mergers';
  static const sdChart = '/stock-detail-chart';
  static const sdOwnership = '/stock-detail-ownership';

  // Market data
  static const mostBullish = '/most-bullish';
  static const checkAlertLock = '/check-alert-lock';
  static const mostBearish = '/most-bearish';
  static const todaysGainers = '/todays-gainers';
  static const todaysLosers = '/todays-losers';
  static const todaysBreakout = '/breakout-stocks';
  static const gapUpStocks = "/gap-up-stocks";
  static const gapDownStocks = "/gap-down-stocks";
  static const highPE = "/high-pe-ratio-stocks";
  static const lowPE = "/low-pe-ratio-stocks";
  static const highPEGrowth = "/high-pe-growth-stocks";
  static const lowPEGrowth = "/low-pe-growth-stocks";
  static const fiftyTwoWeekHigh = "/52-week-highs";
  static const fiftyTwoWeekLow = "/52-week-lows";
  static const highBeta = "/high-beta-stocks";
  static const lowBeta = "/low-beta-stocks";
  static const negativeBeta = "/negative-beta-stocks";
  static const dow30 = "/dow-30-stocks";
  static const snp500 = "/sp-500-stocks";
  static const indices = "/indices";
  static const mostActive = "/most-active-stocks";
  static const mostVolatile = "/most-volatile-stocks";
  static const unusualTrading = "/unusual-trading-volume";
  static const lowPricedStocksUnder = "/low-priced-stocks-under";
  //
  static const mostActivePennyStocks = "/most-active-penny-stocks";
  static const mostPopularPennyStocks = "/most-popular-penny-stocks";
  static const topTodaysPennyStock = "/top-todays-penny-stock";
  static const dividendsAnnouncements = "/dividends-announcements";
  static const earningAnnouncements = "/earning-announcements";
  static const sectors = "/sectors";
  static const sectorsView = "/sector/view";
  static const industries = "/industries";
  static const industriesView = "/industry/view";

  //AI
  static const aiAnalysis = '/ai-analysis';
  static const aiFinancials = '/ai-analysis/financial';
  static const aiPR = "/ai-analysis/past-returns";
  static const aiPV = "/ai-analysis/post-volume";

  //Scanner
  static const stockScannerPort = '/stock-scanner';
  static const scannerFilters = '/scanner-sectors';

  static const morningStarReports = '/morning-star-transaction';

//----------------------------------------------
//----------------------------------------------
//----------------------------------------------

  static const stocksScreenerWebUrl =
      'https://app.stocks.news/stockScannerMobile/screener';

  static const proxyAdvertiser = "/proxy/advertiser";
  static const checkServer = "/check-server-status";
  // static const phoneLogin = '/phone-login';
  static const signup = "/sign-up";
  static const verifySignupOtp = "/check-signup-otp";
  static const resendOtp = "/resend-otp";
  static const signupResendOtp = "/signup-resend-otp";
  static const login = "/login";

  static const homePortfolio = "/home-plaid-portfolio";
  static const verifyLoginOtp = "/check-login-otp";
  static const home = "/home";
  static const homeNew = "/home-new";
  static const saveFCM = "/save-fcm-token";
  static const ipoCalendar = "/ipo-calendar";
  static const welcome = "/welcome-screen";
  static const stockFocus = "/stock-in-focus";
  static const menuWhatWeDo = "/menu-what-we-do";
  static const whatWeDo = "/what-we-do";
  static const lowPricesTab = "/low-priced-stocks";
  static const exchanageTab = "/exchanage";
  static const savePlaidPortfolio = "/save-plaid-portfolio";
  static const plaidPortfolio = "/plaid-portfolio";
  static const referLogin = "/send-phone-otp";
  // static const updateEmailOtp = "/update-email-otp";
  static const updateEmailOtp = "/update-profile-email";
  // static const checkEmailOtp = "/check-email-otp";
  static const checkEmailOtp = "/check-profile-email-otp";
  static const updatePhoneOtp = "/update-phone-otp";
  static const checkUpdatePhoneOtp = "/check-update-phone-otp";
  static const checkPhone = "/check-phone-otp";
  static const lowPricesStocks = "/low-priced-stocks-under";
  static const featuredWatchlist = "/home-watchlist-data";
  // static const indices = "/indices";
  static const spFifty = "/sp-500-stocks";
  static const dowThirty = "/dow-30-stocks";
  static const saleOnStocks = "/stocks-on-sale";
  // static const highPE = "/high-pe-ratio-stocks";
  // static const lowPE = "/low-pe-ratio-stocks";
  // static const fiftyTwoWeekHigh = "/week-highs";
  static const fiftyTwoWeekLows = "/week-lows";
  static const homeSlider = "/home-slider";
  static const homeSentiment = "/home-sentiment";
  static const mostPurchased = "/most-purchased-stocks";
  static const benefitAnalysis = "/referrals/settings";
  // static const homeTrending = "/home-trending"; //Deprecated
  static const homeTrending = "/home-trending-v2";
  static const homeTopGainerLoser = "/home-popular-gainer-loser";
  static const homeInsider = "/home-insider";
  static const homeAlert = "/home-alerts-data";
  static const newsAlertGraphData = "/stock-historical-chart";
  static const featuredTicker = "/featured-tickers";
  static const mostActivePenny = "/most-active-penny-stocks";
  static const mostPopularPenny = "/most-popular-penny-stocks";
  static const topPennyStocksToday = "/top-penny-stocks-today";
  static const getMostSearch = "/most-search-symbol";
  static const latestNews = "/latest-news";
  // static const trending = "/trending";
  static const insiderTrading = "/insider-trading";
  //static const watchlist = "/watchlist";
  static const addWatchlist = "/add-watchlist";
  static const createAlert = "/add-alert";
  //static const deleteWatchlist = "/delete-watchlist";
  static const deleteAlertlist = "/delete-alert";

  static const moreStocks = "/trending_gainer_loser";
  static const congress = "/congress-stock-trades";
  static const congressMember = "/profile-congress-member";
  static const updateProfileEmail = "/update-profile-otp";
  static const updateProfileOTP = "/update-profile-resend-otp";
  static const faQs = "/faq";
  static const contactUs = "/contact-us";
  // static const infoPage = "/info-page";
  //static const alerts = "/alerts";
  static const stockDetails = "/stock-details";
  static const stockAnalysis = "/stock-analysis";
  static const technicalAnalysis = "/technical-analysis";
  static const industry = "/industry";
  static const sector = "/sector";
  static const redditTwitter = "/reddit-twitter";
  static const compare = "/compare";
  static const deleteCompare = "/delete-compare";
  static const addCompare = "/add-compare";
  // static const notifications = "/notifications";
  // static const deleteUser = "/delete-user";
  static const qrCodeScan = "/token-login";
  static const stocks = "/stocks";
  static const blogDetails = "/blog-detail-secure-v2-stocks";
  static const trendingIndustries = "/trending-industries";
  static const stockDetailMention = "/trading-stock";
  static const nudgeFriend = '/referrals/nudge-your-friend';
  static const trendingBullish = "/trending-bullish";
  static const trendingBearish = "/trending-bearish";
  static const trendingNews = "/trending-news";
  static const insiderTradingGraph = "/insider-company-chart";
  static const insiderInsiderGraph = "/insider-insider-chart";
  static const newsDetails = "/news-detail";
  static const sectorChart = "/sector-chart";
  static const trendingIndustryChart = "/trending-industries-chart";
  static const gainerLoser = "/gainer_loser";
  static const breakoutStocks = "/breakout-stocks";
  static const socialTrending = "/social-trending";
  static const socialTrendingCap = "/social-trending-cap";
  static const featuredNews = "/featured-news";
  static const getOtherData = "/stock-other-details";
  static const newsTab = "/category-list";
  static const marketTickers = "/market-tickers";
  // static const gapUpStocks = "/gap-up-stocks";
  // static const gapDownStocks = "/gap-down-stocks";
  // static const highPEGrowth = "/high-pe-growth-stocks";
  // static const lowPEGrowth = "/low-pe-growth-stocks";
  static const weekHighs = "/week-highs";
  static const weekLows = "/week-lows";
  static const lowBetaStocks = "/low-beta-stocks";
  static const highBetaStocks = "/high-beta-stocks";
  static const negativeBetaStocks = "/negative-beta-stocks";
  static const mostActiveStocks = "/most-active-stocks";
  static const mostVoliatileStocks = "/most-voliatile-stocks";
  static const mostVolumeStocks = "/unusual-volume-stocks";
  static const updateInAppCount = "/update-inapp-count";
  static const dividends = "/dividends";
  static const earnings = "/earnings";
  static const stockScreener = "/stock-screener";
  static const filters = "/common-filters";
  static const drawerData = "/drawer-data";
  static const blogCategory = "/blog-category-list";
  static const sendAppleOtp = "/signup-apple-email";
  static const disconnectPlaid = "/remove-plaid-portfolio";
  static const referralLeaderBoard = "/referrals/leaderboard";
  static const affiliateTnx = "/referrals/txn-report";
  static const affiliateTnxList = "/referrals/txn-report-list";

  static const blackFridayTransaction = "/membership/transactions_v2";

  static const membershipSuccess = "/membership/success";

  static const adViewed = "/ad-viewed";
  static const adClicked = "/ad-clicked";

  // Stock Detail New ---
  static const detailEarning = "/stock-detail-earning";
  static const detailDividends = "/stock-detail-dividend";
  static const detailChart = "/stock-detail-chart";
  static const detailSec = "/stock-detail-secFiling";
  static const detailForecast = "/stock-detail-forecast";
  static const stockDetailNews = "/stock-detail-news";
  static const stockDetailNewsV2 = "/stock-detail-news-v2";

  static const stockDetailSocial = "/stock-detail-social";
  static const detailOwnership = "/stock-detail-ownership";
  static const detailCompetitor = "/stock-detail-competitior";
  static const stockDetailInsider = "/stock-detail-insider";
  static const detailFinancial = "/stock-detail-financial";
  static const stockDetailMergers = "/stock-detail-mergers";
  // Stock Detail New ended ----
  //static const getTickets = "/get-tickets";
  // static const sendTicket = "/send-ticket";
  // static const ticketDetail = "/ticket-detail";
  // static const ticketReply = "/ticket-reply";

  static const updateReferral = "/update-referral-code";
  static const userPurchase = "/user-purchase";
  static const plansDetail = "/membership/plans";
  static const storeInfo = "/store-points/list";
  static const membershipInfo = "/membership/plan-data";
  static const blackFridayMembership = "/membership/black-friday-plans";
  static const christmasMembership = "/membership/christmas-plans";
  static const newYearMembership = "/membership/new-year-plans";
  static const aiNewsList = "/latest-news-v2";
  // static const notificationSettings = "/notification-settings";
  static const updateNotificationSettings = "/update-notification-setting";

  static const loginNew = "/check-user";

  // ---------   STock Analysis Screen --------------
  static const msRadarChart = "/stock-analysis/radarChart";
  static const msPriceVolatility = "/stock-analysis/priceVolatility";
  static const msPriceVolatilityNew = "/stock-analysis/price-volatility-new";

  static const msStockHighlight = "/stock-analysis/stockHighLights";
  static const msStockPricing = "/stock-analysis/pricing";
  static const msStockProfit = "/stock-analysis/profit";
  static const msOtherStock = "/stock-analysis/portfolio-stocks";
  static const msStockTop = "/stock-analysis/stock-top-detail";
  static const msFinancials = "/stock-analysis/financials";
  static const msPeer = '/stock-analysis/peer-comparison';
  static const msComplete = '/stock-analysis/complete-data';
  static const msFaqs = '/stock-analysis/faqs';
  static const pastReturn = "/stock-analysis/past-returns";
  static const postVolume = "/stock-analysis/post-volume";
  static const msNews = '/stock-analysis/latest-news';
  static const msEvents = '/stock-analysis/events';

  //----------   Missions
  static const pointClaimList = "/point-claim-list";
  static const pointsClaim = "/point-claim";

  static const pointClaimLog = "/point-claim-log";
  static const claimPointLog = "/referrals/claim-point-log";

  static const appsflyerUsers = '/appsflyer-users';
  static const trendingSectors = '/trending-sectors';
  static const stockScannerChange = '/stockScannerChange';
}

class ApiKeys {
  static const apiKey = "AIzaSyA26KdOgpIBTIVuNfZwRoixNsfPnMKT2rE";
  static const appId = "1:661986825229:android:ce1c460925d54b155bb144";
  static const messagingSenderId = "661986825229";
  static const projectId = "stocksnews-ef556";

  //Revenue Cat
  static const androidKey = 'goog_KXHVJRLChlyjoOamWsqCWQSJZfI';
  static const iosKey = 'appl_kHwXNrngqMNktkEZJqYhEgLjbcC';

  //AppsFlyer
  static const appsFlyerKey = 'DdBBqNnwC3Xz2dwhbF7kJK';
  static const iosAppID = '6476615803';

  //Amplitude
  static const amplitudeKey = 'ff8ab349a2ddf801c985a59e3be1bedf';

  //SuperWall
  static const superWallIOS =
      'pk_12e4abaf1b222772aa2033514213dd673b31001945d628d2';
  static const superWallAndroid =
      'pk_df185ee9c5de2887e44fa3a357cf333b7f5d35d8dd9d839c';
}
