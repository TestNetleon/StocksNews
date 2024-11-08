import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/help_desk_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../api/image_service.dart';
import '../modals/help_desk_chat_res.dart';
import '../route/my_app.dart';
import '../screens/helpDesk/chats/index.dart';
import '../utils/dialogs.dart';

class NewHelpDeskProvider extends ChangeNotifier {
// Get Chats
  Status _status = Status.ideal;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  Extra? _extra;
  Extra? get extra => _extra;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  HelpDeskChatRes? _chatData;
  HelpDeskChatRes? get chatData => _chatData;

  bool removeLoader = false;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getAllChats({
    String? ticketId,
    showProgress = true,
    loadRemoval = false,
  }) async {
    if (loadRemoval) {
      removeLoader = loadRemoval;
    }

    setStatus(Status.loading);

    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      Map request = {
        "token": provider.user?.token ?? "",
        "ticket_id": ticketId ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.ticketDetail,
        request: request,
        showProgress: showProgress,
        removeForceLogin: true,
      );
      if (response.status) {
        _chatData = helpDeskChatResFromJson(jsonEncode(response.data));
        _error = null;
        _extra = response.extra is Extra ? response.extra : null;
      } else {
        _chatData = null;
        _error = null;
        _extra = null;
      }
      removeLoader = false;
      setStatus(Status.loaded);
    } catch (e) {
      _chatData = null;
      _error = null;
      _extra = null;
      Utils().showLog("Error in get all chats, provider $e");
      setStatus(Status.loaded);
    }
  }

// Reply Ticket
  Status _statusR = Status.ideal;
  bool get isLoadingR => _statusR == Status.loading || _statusR == Status.ideal;

  void setStatusR(status) {
    _statusR = status;
    notifyListeners();
  }

  Future replyTicketNew({
    String url = Apis.ticketReply,
    Map<String, dynamic>? header,
    baseUrl = Apis.baseUrl,
    String? ticketNo,
    File? image,
    required String ticketId,
    String? message,
  }) async {
    showGlobalProgressDialog();
    try {
      Utils().showLog("URL  =  $baseUrl$url");
      Utils().showLog("HEADERS  =  ${getHeaders().toString()}");
      final messageText = message?.replaceAll("\n", "<br>");
      String mainFormattedMsg = _formatMessage(messageText ?? "");
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
          notifyListeners();

          // Utils().showLog("RESPONSE => ${response.data}");
          getAllChats(
            ticketId: ticketId,
            showProgress: true,
            loadRemoval: true,
          );
        } else {
          //
        }
        AmplitudeService.logUserInteractionEvent(
          type: 'Support Ticket Created',
          selfText: 'Support ticket #$ticketNo created by user for assistance.',
        );
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

// Get Tickets
  Status _statusTickets = Status.ideal;
  bool get isLoadingTickets =>
      _statusTickets == Status.loading || _statusTickets == Status.ideal;

  HelpDeskRes? _data;
  HelpDeskRes? get data => _data;

  Extra? _extraTickets;
  Extra? get extraTickets => _extraTickets;

  String? _errorTickets;
  String? get errorTickets => _errorTickets ?? Const.errSomethingWrong;

  void setStatusTickets(status) {
    _statusTickets = status;
    notifyListeners();
  }

  Future getTickets() async {
    setStatusTickets(Status.loading);

    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.getTickets,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _data = helpDeskResFromJson(jsonEncode(response.data));
        _errorTickets = null;
        _extraTickets = response.extra is Extra ? response.extra : null;
      } else {
        _data = null;
        _errorTickets = null;
        _extraTickets = null;
      }

      setStatusTickets(Status.loaded);
    } catch (e) {
      _data = null;
      _errorTickets = null;
      _extraTickets = null;
      Utils().showLog("Error in get tickets, provider $e");
      setStatusTickets(Status.loaded);
    }
  }

  // Send Subject ID
  Status _statusSubject = Status.ideal;
  bool get isLoadingSubject =>
      _statusSubject == Status.loading || _statusSubject == Status.ideal;

  Extra? _extraSubject;
  Extra? get extraSubject => _extraSubject;

  String? _errorSubject;
  String? get errorSubject => _errorSubject ?? Const.errSomethingWrong;

  void setStatusSubject(status) {
    _statusSubject = status;
    notifyListeners();
  }

  Future sendSubjectID({required Subject subject}) async {
    setStatusSubject(Status.loading);
    Utils().showLog("Sending Subject ${subject.id}, ${subject.title}");
    // return;
    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      Map request = {
        "token": provider.user?.token ?? "",
        "subject_id": subject.id,
        "message": subject.title.toString().trim(),
      };
      ApiResponse response = await apiRequest(
        url: Apis.sendTicket,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        _errorSubject = null;
        _extraSubject = response.extra is Extra ? response.extra : null;

        if (response.data != null) {
          Ticket ticket = Ticket.fromJson(response.data);
          _data?.tickets?.insert(0, ticket);
        } else {
          popUpAlert(
            icon: Images.alertPopGIF,
            message: "No data found in response.",
            title: "Alert",
          );
        }

        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) =>
                HelpDeskAllChatsNew(ticketId: response.data['ticket_id']),
          ),
        );
      } else {
        _errorSubject = null;
        _extraSubject = null;
        popUpAlert(
          icon: Images.alertPopGIF,
          message: response.message,
          title: "Alert",
        );
      }

      setStatusSubject(Status.loaded);
    } catch (e) {
      _errorSubject = null;
      _extraSubject = null;
      popUpAlert(
        icon: Images.alertPopGIF,
        message: Const.errSomethingWrong,
        title: "Alert",
      );
      Utils().showLog("Error in send subject ID, provider $e");
      setStatusSubject(Status.loaded);
    }
  }

  // Compress File
  Future _compressAndGetFile(File file) async {
    Uint8List? result = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 50,
      format: CompressFormat.jpeg,
    );
    return result;
  }

  // Format Message
  String _formatMessage(String message) {
    try {
      final RegExp regex = RegExp(
        r"(https?:\/\/\S+)",
        caseSensitive: false,
        multiLine: true,
      );

      String formattedMessage = message.replaceAllMapped(regex, (match) {
        String? url = match.group(0);
        if (url == '' || url == null) {
          return url ?? "";
        }
        return '<a href="$url">$url</a>';
      });
      return formattedMessage;
    } catch (e) {
      Utils().showLog("-----$e");
    }

    return "";
  }
}
