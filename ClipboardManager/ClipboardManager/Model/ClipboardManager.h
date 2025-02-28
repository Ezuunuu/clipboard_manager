//
//  ClipboardManager.h
//  ClipboardManager
//
//  Created by 이준우 on 3/1/25.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface ClipboardManager : NSObject
+ (NSString *)getClipboardContent;
@end
