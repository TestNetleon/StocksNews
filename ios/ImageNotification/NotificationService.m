#import "NotificationService.h"
#import "FirebaseMessaging.h"

@interface NotificationService ()
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@end

@implementation NotificationService
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    [[FIRMessaging extensionHelper] populateNotificationContent:self.bestAttemptContent withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
   self.contentHandler(self.bestAttemptContent);
}
@end









// #import <OneSignalExtension/OneSignalExtension.h>

// #import "NotificationService.h"

// @interface NotificationService ()

// @property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
// @property (nonatomic, strong) UNNotificationRequest *receivedRequest;
// @property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

// @end

// @implementation NotificationService

// - (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
//     self.receivedRequest = request;
//     self.contentHandler = contentHandler;
//     self.bestAttemptContent = [request.content mutableCopy];
//     [OneSignalExtension didReceiveNotificationExtensionRequest:self.receivedRequest
//                        withMutableNotificationContent:self.bestAttemptContent
//                                    withContentHandler:self.contentHandler];
// }

// - (void)serviceExtensionTimeWillExpire {
//     [OneSignalExtension serviceExtensionTimeWillExpireRequest:self.receivedRequest withMutableNotificationContent:self.bestAttemptContent];
//     self.contentHandler(self.bestAttemptContent);
// }

// @end