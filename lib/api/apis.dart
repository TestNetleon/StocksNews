class Apis {
  static const baseUrl = "https://app.stocks.news/api/v1"; // live server
  // static const baseUrl = kDebugMode
  //     ? "https://notification.stocks.news/api/v1"
  //     : "https://app.stocks.news/api/v1"; // live server

  static const signup = "/sign-up";
  static const verifySignupOtp = "/check-signup-otp";
  static const resendOtp = "/resend-otp";
  static const signupResendOtp = "/signup-resend-otp";
  static const login = "/login";
  static const googleLogin = "/signup-google";
  static const appleLogin = "/signup-apple";
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

  static const lowPricesStocks = "/low-priced-stocks-under";
  static const indices = "/indices";
  static const spFifty = "/sp-500-stocks";

  static const dowThirty = "/dow-30-stocks";

  static const saleOnStocks = "/stocks-on-sale";
  static const highPE = "/high-pe-ratio-stocks";
  static const lowPE = "/low-pe-ratio-stocks";
  static const fiftyTwoWeekHigh = "/week-highs";
  static const fiftyTwoWeekLows = "/week-lows";
  static const homeSlider = "/home-slider";
  static const homeSentiment = "/home-sentiment";
  // static const homeTrending = "/home-trending"; //Deprecated
  static const homeTrending = "/home-trending-v2";
  static const homeTopGainerLoser = "/home-popular-gainer-loser";
  static const homeInsider = "/home-insider";
  static const homeAlert = "/home-alerts-data";
  static const newsAlertGraphData = "/stock-historical-chart";
  static const featuredTicker = "/featured-tickers";
  static const mostActivePenny = "/most-active-penny-stocks";
  static const topPennyStocksToday = "/top-penny-stocks-today";

  static const search = "/search";
  static const searchWithNews = "/search_with_news";
  static const getMostSearch = "/most-search-symbol";
  static const latestNews = "/latest-news";
  static const trending = "/trending";
  static const insiderTrading = "/insider-trading";
  static const watchlist = "/watchlist";
  static const addWatchlist = "/add-watchlist";
  static const deleteWatchlist = "/delete-watchlist";
  static const moreStocks = "/trending_gainer_loser";
  static const congress = "/congress-stock-trades";

  static const updateProfile = "/update-profile";
  static const updateProfileEmail = "/update-profile-otp";
  static const updateProfileOTP = "/update-profile-resend-otp";
  static const logout = "/logout";
  static const faQs = "/faq";
  static const contactUs = "/contact-us";
  static const infoPage = "/info-page";
  static const alerts = "/alerts";
  static const deleteAlertlist = "/delete-alert";
  static const createAlert = "/add-alert";
  static const stockDetails = "/stock-details";
  static const stockAnalysis = "/stock-analysis";
  static const technicalAnalysis = "/technical-analysis";
  static const industry = "/industry";
  static const sector = "/sector";
  static const redditTwitter = "/reddit-twitter";
  static const compare = "/compare";
  static const deleteCompare = "/delete-compare";
  static const addCompare = "/add-compare";
  static const notifications = "/notifications";
  static const deleteUser = "/delete-user";
  static const qrCodeScan = "/token-login";
  static const stocks = "/stocks";
  static const blogs = "/blogs";
  static const blogDetails = "/blog-detail";
  static const trendingIndustries = "/trending-industries";
  static const stockDetailMention = "/trading-stock";

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
  static const featuredNews = "/featured-news";
  static const getOtherData = "/stock-other-details";
  static const newsTab = "/category-list";
  static const marketTickers = "/market-tickers";

  static const gapUpStocks = "/get-up-stocks";
  static const gapDownStocks = "/get-down-stocks";
  static const highPEGrowth = "/high-pe-growth-stocks";
  static const lowPEGrowth = "/low-pe-growth-stocks";
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
}

//
class ApiKeys {
  static const apiKey = "AIzaSyA26KdOgpIBTIVuNfZwRoixNsfPnMKT2rE";
  static const appId = "1:661986825229:android:ce1c460925d54b155bb144";
  static const messagingSenderId = "661986825229";
  static const projectId = "stocksnews-ef556";
}
