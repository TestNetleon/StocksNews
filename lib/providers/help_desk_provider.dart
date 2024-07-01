// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/api/image_service.dart';
import 'package:stocks_news_new/modals/help_desk_chat_res.dart';
import 'package:stocks_news_new/modals/help_desk_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

class HelpDeskProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;

  int _page = 1;
  Extra? _extra;
  HelpDeskRes? _data;

  HelpDeskRes? get data => _data;
  HelpDeskChatRes? _chatData;

  HelpDeskChatRes? get chatData => _chatData;
  Extra? get extra => _extra;
  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  TextEditingController reasonController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  String _slug = "1";
  String get slug => _slug;
  String _ticketId = "1";
  String get ticketId => _ticketId;

  String _reasonId = "";
  String get reasonId => _reasonId;

  String _loaderChatMessage = "1";
  String get loaderChatMessage => _loaderChatMessage;
  bool _showProgressChatMessage = false;
  bool get showProgressChatMessage => _showProgressChatMessage;

  void setStatus(status) {
    _status = status;

    notifyListeners();
  }

  void setSlug(slug, ticketId) {
    _slug = slug;
    _ticketId = ticketId;

    notifyListeners();
  }

  setMessage(msg) {
    messageController.text = msg;
    notifyListeners();
  }

  void setReasonController(reason, reasonId) {
    reasonController.text = reason;
    _reasonId = reasonId == "" ? reasonId : reasonId;

    _chatData?.logs?.clear();
    _chatData?.logs = [];

    notifyListeners();
  }

  Future getHelpDeskList({
    loadMore = false,
    reset = false,
  }) async {
    if (reset) _data = null;
    setStatus(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.getTickets,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );

      if (response.status) {
        _data = helpDeskResFromJson(jsonEncode(response.data));
        _error = null;
        _extra = response.extra is Extra ? response.extra : null;

        // setSlug("1",
        //     "${helpDeskResFromJson(jsonEncode(response.data)).tickets?.isEmpty == true ? "" : helpDeskResFromJson(jsonEncode(response.data)).tickets?[0].ticketId}");
        // notifyListeners();
        // getHelpDeskChatScreen(loaderChatMessage: "0");
      } else {
        _error = response.message ?? Const.errSomethingWrong;
      }

      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      Utils().showLog(e);
      setStatus(Status.loaded);
    }
  }

  Future sendTicket() async {
    showGlobalProgressDialog();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "subject_id": reasonId,
        "message": messageController.text.toString().trim(),
      };

      ApiResponse response = await apiRequest(
        url: Apis.sendTicket,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        messageController.text = "";
        // notifyListeners();
        // _showProgressChatMessage = true;

        Map requestList = {
          "token":
              navigatorKey.currentContext!.read<UserProvider>().user?.token ??
                  "",
        };

        ApiResponse responseList = await apiRequest(
          url: Apis.getTickets,
          request: requestList,
          showProgress: false,
          removeForceLogin: true,
        );

        if (responseList.status) {
          _data = helpDeskResFromJson(jsonEncode(responseList.data));
          _error = null;
          _extra = responseList.extra is Extra ? responseList.extra : null;
          setSlug("0",
              "${helpDeskResFromJson(jsonEncode(responseList.data)).tickets?.isEmpty == true ? "" : helpDeskResFromJson(jsonEncode(responseList.data)).tickets?[0].ticketId}");

          Map requestDetail = {
            "token":
                navigatorKey.currentContext!.read<UserProvider>().user?.token ??
                    "",
            "ticket_id": ticketId,
          };

          ApiResponse responseDetail = await apiRequest(
            url: Apis.ticketDetail,
            request: requestDetail,
            showProgress: showProgressChatMessage,
            removeForceLogin: true,
          );

          if (responseDetail.status) {
            _error = null;
            _chatData =
                helpDeskChatResFromJson(jsonEncode(responseDetail.data));
            _extra =
                responseDetail.extra is Extra ? responseDetail.extra : null;

            setSlug("1",
                "${helpDeskResFromJson(jsonEncode(responseList.data)).tickets?.isEmpty == true ? "" : helpDeskResFromJson(jsonEncode(responseList.data)).tickets?[0].ticketId}");
          }
        }
      }
      closeGlobalProgressDialog();
      notifyListeners();
    } catch (e) {
      closeGlobalProgressDialog();
    }
  }

  Future<void> replyTicket({File? image}) async {
    showGlobalProgressDialog();
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "ticket_id": ticketId,
        "message": messageController.text.toString().trim(),
        // "image": multipartFile,
      });

      ApiResponse response = await apiRequest(
        url: Apis.ticketReply,
        showProgress: true,
        removeForceLogin: true,
        formData: formData,
      );

      if (response.status) {
        setSlug(slug, ticketId);
        notifyListeners();

        getHelpDeskChatScreen();
        messageController.text = "";
      }

      closeGlobalProgressDialog();
      notifyListeners();
    } catch (e) {
      Utils().showLog("Error in replyTicket: $e");
      closeGlobalProgressDialog();
      notifyListeners();
    }
  }

  String _formatMessage(String message) {
    // Regular expression to detect URLs
    try {
      final RegExp regex = RegExp(
        r"(https?:\/\/\S+)",
        caseSensitive: false,
        multiLine: true,
      );

      // Replace URLs with clickable links
      String formattedMessage = message.replaceAllMapped(regex, (match) {
        String url = match.group(0)!;
        return '<a href="$url">$url</a>';
      });
      return formattedMessage;
    } catch (e) {
      Utils().showLog("-----$e");
    }

    return "";
  }

  Future replyTicketNew({
    String url = Apis.ticketReply,
    Map<String, dynamic>? header,
    baseUrl = Apis.baseUrl,
    File? image,
  }) async {
    showGlobalProgressDialog();
    try {
      Utils().showLog("URL  =  $baseUrl$url");
      Utils().showLog("HEADERS  =  ${getHeaders().toString()}");
      final messageText = messageController.text.replaceAll("\n", "<br>");
      String mainFormattedMsg = _formatMessage(messageText);
      Map<String, dynamic> headers = getHeaders();
      if (header != null) headers.addAll(header);
      dio.options.headers = headers;
      Uint8List? result;
      MultipartFile? multipartFile;

      if (image != null) {
        result = await testCompressAndGetFile(image);

        if (result != null) {
          multipartFile = MultipartFile.fromBytes(
            result,
            filename: image.path.substring(image.path.lastIndexOf("/") + 1),
          );
        }
      } else {
        Utils().showLog("null image");
      }

      final request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "ticket_id": ticketId,
        "message": mainFormattedMsg,
        "image": multipartFile,
      });
      Response response = await dio.post((baseUrl + url),
          data: request, options: Options(headers: headers));
      closeGlobalProgressDialog();
      if (response.statusCode == 200) {
        if (response.data != null) {
          setSlug(slug, ticketId);
          notifyListeners();
          getHelpDeskChatScreen();
          messageController.text = "";
        } else {
          //
        }

        return ApiResponse(status: true);
      } else {
        return ApiResponse(status: false);
      }
    } on DioException catch (e) {
      Utils().showLog("dio e $e");
      closeGlobalProgressDialog();

      return ApiResponse(status: false, message: Const.errSomethingWrong);
    } catch (e) {
      Utils().showLog("catch e$e");
      closeGlobalProgressDialog();
      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }

  Future getHelpDeskChatScreen(
      {loaderChatMessage = "1", loadMore = false}) async {
    if (loaderChatMessage == "0") {
      _chatData = null;
      setStatus(Status.loading);
    }
    messageController.clear();

    if (showProgressChatMessage) {
      _error = "";
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "ticket_id": ticketId,
      };

      ApiResponse response = await apiRequest(
        url: Apis.ticketDetail,
        request: request,
        showProgress: showProgressChatMessage,
        removeForceLogin: true,
      );

      if (response.status) {
        _error = null;

        _chatData = helpDeskChatResFromJson(jsonEncode(response.data));
        _extra = response.extra is Extra ? response.extra : null;
      } else {
        _error = response.message ?? Const.errSomethingWrong;
        _chatData = null;
      }
      _showProgressChatMessage = false;

      setStatus(Status.loaded);

      return ApiResponse(status: response.status);
    } catch (e) {
      // _chatData = null;
      setStatus(Status.loaded);
      return ApiResponse(status: false);
    }
  }
}
