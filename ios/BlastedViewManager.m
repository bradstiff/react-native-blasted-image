#import "BlastedViewManager.h"
#import "BlastedImageModule.h"
#import <React/RCTViewManager.h>
#import <React/RCTConvert.h>
#import <SDWebImage/SDWebImage.h>

@implementation BlastedViewManager {
    BOOL _hybridAssets;
    NSString *_cloudUrl;
}

RCT_EXPORT_MODULE(BlastedImageView);

- (UIView *)view {
    UIImageView *imageView = [[UIImageView alloc] init];
    return imageView;
}

- (BOOL)isEmptyString:(NSString *)str {
    return (!str || ![str isKindOfClass:[NSString class]] || [str isEqualToString:@""]);
}

RCT_CUSTOM_VIEW_PROPERTY(hybridAssets, BOOL, UIImageView) {
    _hybridAssets = [RCTConvert BOOL:json];
}

RCT_CUSTOM_VIEW_PROPERTY(cloudUrl, NSString, UIImageView) {
    _cloudUrl = [RCTConvert NSString:json];
}

RCT_CUSTOM_VIEW_PROPERTY(sourceUri, NSString, UIImageView) {
    NSString *uri = [RCTConvert NSString:json]; 
    BlastedImageModule *blastedImageModule = [[BlastedImageModule alloc] init];
    NSURL *url = [blastedImageModule prepareUrl:uri hybridAssets:_hybridAssets cloudUrl:_cloudUrl showLog:NO];
    
    if (url != nil && ![url.absoluteString isEqualToString:@""]) {
        [view sd_setImageWithURL:url];
        [view setHidden:NO];
    } else {
        [view setHidden:YES];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(resizeMode, NSString, UIImageView) {
    NSString *resizeMode = [RCTConvert NSString:json];

    // Check if resizeMode is nil, empty, or "undefined" then set default
    if (!resizeMode || [resizeMode isEqualToString:@""] || [resizeMode isEqualToString:@"undefined"]) {
        resizeMode = @"cover";
    }

    if ([resizeMode isEqualToString:@"contain"]) {
        [view setContentMode:UIViewContentModeScaleAspectFit];
    } else if ([resizeMode isEqualToString:@"stretch"]) {
        [view setContentMode:UIViewContentModeScaleToFill];
    } else if ([resizeMode isEqualToString:@"cover"]) {
        [view setContentMode:UIViewContentModeScaleAspectFill];
    } else if ([resizeMode isEqualToString:@"center"]) {
        [view setContentMode:UIViewContentModeCenter];
    } else {
        [view setContentMode:UIViewContentModeScaleAspectFill]; // Default to cover
    }
}

RCT_CUSTOM_VIEW_PROPERTY(width, NSNumber, UIImageView) {
    CGFloat width = [RCTConvert CGFloat:json];
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

RCT_CUSTOM_VIEW_PROPERTY(height, NSNumber, UIImageView) {
    CGFloat height = [RCTConvert CGFloat:json];
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

@end
