@import UIKit;

#import "DocumentpickerPlugin.h"

@interface DocumentpickerPlugin ()<UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>
@end

@implementation DocumentpickerPlugin{
    FlutterResult _result;
    UIViewController *_viewController;
    UIDocumentPickerViewController *_pickerController;
    UIDocumentInteractionController *_interactionController;
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
      
      _pickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
      _pickerController.delegate = self;
      
      _result = result;
      [_viewController presentViewController:_pickerController animated:YES completion:nil];
      
  }
  else if ([@"viewDocument" isEqualToString:call.method]) {
      
      NSString *documentUrl = call.arguments[@"documentUrl"];
      
      NSLog(@"Starting to Open doc %@", documentUrl);
      
      NSURL *docUrl = [NSURL fileURLWithPath:documentUrl];
      
      _interactionController = [UIDocumentInteractionController interactionControllerWithURL: docUrl];
      _interactionController.delegate = self;
  
      
      BOOL isOk = [_interactionController presentPreviewAnimated:YES];
      if(isOk){
          
        NSLog(@"Failed to Open doc %@", documentUrl);
        result(@"Failed");
      }else{
       _result = result;
      }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller
didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    
    [_pickerController dismissViewControllerAnimated:YES completion:nil];

    NSURL *url = [urls objectAtIndex:0];
    
    NSString *resultFilePath = [url path];
    NSLog( @"Finished picking document:%@",resultFilePath);
    _result(resultFilePath);
}

// DocumentInteractionController delegate

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    _result(@"Finished");
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    NSLog(@"Finished");
    return  _viewController;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    
    NSLog(@"Starting to send this puppy to %@", application);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    
    NSLog(@"We're done sending the document.");
}

@end
