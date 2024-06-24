// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/help_desk_chat_res.dart';
import 'package:stocks_news_new/modals/help_desk_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

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

  void setReasonController(reason, reasonId) {
    reasonController.text = reason;
    _reasonId = reasonId == "" ? reasonId : reasonId;

    _chatData?.logs?.clear();
    _chatData?.logs = [];

    notifyListeners();
  }

  Future getHelpDeskList({loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.getTickets,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;

        _data = helpDeskResFromJson(jsonEncode(response.data));
        _extra = response.extra is Extra ? response.extra : null;

        setSlug("1",
            "${data?.tickets == null ? "" : helpDeskResFromJson(jsonEncode(response.data)).tickets?[0].ticketId}");
        notifyListeners();
        getHelpDeskChatScreen(loaderChatMessage: "0");
      } else {
        _error = response.message ?? Const.errSomethingWrong;
        _data = null;
      }

      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
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
      );
      if (response.status) {
        messageController.text = "";
        notifyListeners();
        _showProgressChatMessage = true;

        getHelpDeskList(loadMore: false);
      }
      notifyListeners();
      closeGlobalProgressDialog();
    } catch (e) {
      closeGlobalProgressDialog();
    }
  }

  Future replyTicket() async {
    showGlobalProgressDialog();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "ticket_id": ticketId,
        "message": messageController.text.toString().trim(),
      };

      ApiResponse response = await apiRequest(
        url: Apis.ticketReply,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        setSlug(slug, ticketId);
        notifyListeners();

        getHelpDeskChatScreen();
        messageController.text = "";
      }
      notifyListeners();
      closeGlobalProgressDialog();
    } catch (e) {
      _data = null;
      closeGlobalProgressDialog();
    }
  }

  Future getHelpDeskChatScreen(
      {loaderChatMessage = "1", loadMore = false}) async {
    if (loaderChatMessage == "0") {
      _chatData = null;
    }

    if (showProgressChatMessage) {
      _error = "";
    }

    if (loaderChatMessage == "0") setStatus(Status.loading);

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
    } catch (e) {
      // _chatData = null;
      setStatus(Status.loaded);
    }
  }
}
