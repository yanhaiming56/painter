//
//  main.m
//  paint
//
//  Created by yhs on 2020/5/14.
//  Copyright © 2020 yhs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

void threadMethod()
{
    NSLog(@"");
}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
        
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
