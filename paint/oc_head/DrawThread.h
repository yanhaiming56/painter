//
//  DrawThread.h
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawThread : NSThread

@property(nonatomic,assign) BOOL isCanRun;

- (void)stopWork;

@end

NS_ASSUME_NONNULL_END
