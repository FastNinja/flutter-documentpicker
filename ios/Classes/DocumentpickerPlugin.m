@import UIKit;

#import "DocumentpickerPlugin.h"

@interface DocumentpickerPlugin ()<UIDocumentPickerDelegate>
@end

@implementation DocumentpickerPlugin{
    FlutterResult _result;
    UIViewController *_viewController;
    UIDocumentPickerViewController *_pickerController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"documentpicker"
            binaryMessenger:[registrar messenger]];
    
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    DocumentpickerPlugin *instance = [[DocumentpickerPlugin alloc] initWithViewController:viewController];
    
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        _pickerController = [[UIDocumentPickerViewController alloc]
                                                               initWithDocumentTypes:@[@"public.item"]
                                                               inMode:UIDocumentPickerModeImport];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // I honestly do not undertsand below code but it was implemented by Flutter team in ImagePicker
    // https://github.com/flutter/plugins/blob/master/packages/image_picker/ios/Classes/ImagePickerPlugin.m
    // and it seems work
    if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
    }
    
  if ([@"pickDocument" isEqualToString:call.method]) {

//      documentPickerMenu.delegate = self;
//      [_viewController presentViewController:documentPickerMenu animated:YES completion:nil];
//      UIDocumentPickerViewController  *documentPickerCtrl = [[UIDocumentPickerViewController alloc]
//                                                          initWithDocumentTypes:@[@"public.item"]
//                                                          inMode:UIDocumentPickerModeImport];
      
      _pickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
      _pickerController.delegate = self;
      
        _result = result;
      [_viewController presentViewController:_pickerController animated:YES completion:nil];
      
  }
  else if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller
didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    
    [_pickerController dismissViewControllerAnimated:YES completion:nil];

    NSURL *url = [urls objectAtIndex:0];
    
    NSString *resultFilePath = [url path];
    NSLog( @"result:%@",resultFilePath);
    _result(resultFilePath);
}
@end
