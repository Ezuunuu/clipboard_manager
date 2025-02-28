//
//  ClipboardManager.m
//  ClipboardManager
//
//  Created by 이준우 on 3/1/25.
//

#import "ClipboardManager.h"

@implementation ClipboardManager

+ (NSString *)getClipboardContent {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], nil];
    NSDictionary *options = [NSDictionary dictionary];
    NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];

    if (copiedItems.count > 0) {
        return copiedItems[0];
    }
    return nil;
}

@end
