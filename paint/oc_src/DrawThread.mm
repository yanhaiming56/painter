//
//  DrawThread.m
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#import "DrawThread.h"

@interface DrawThread()
{
    BOOL m_isCanRun;
    CFRunLoopRef m_runLoop;
    CFRunLoopSourceRef m_source;
    CFRunLoopSourceContext m_source_context;
}
@end

@implementation DrawThread

@synthesize isCanRun = m_isCanRun;

- (void)main
{
    NSLog(@"\n<====== Draw thread begin ========>");
    if (self.isCancelled)
    {
        return;
    }
    
    @autoreleasepool
    {
        m_runLoop = CFRunLoopGetCurrent();
        m_isCanRun = YES;
        
        bzero(&m_source_context, sizeof(m_source_context));
        
        //这里创建了一个基于事件的源
        m_source_context.perform = fire;
        m_source = CFRunLoopSourceCreate(NULL, 0, &m_source_context);
        
        //将源添加到当前RunLoop中去
        CFRunLoopAddSource(m_runLoop, m_source, kCFRunLoopDefaultMode);
        
        while (m_isCanRun)
        {
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10.0, NO);
        }
    }
}

static void fire(void* info __unused)
{
}

- (void)stopWork
{
    m_isCanRun = NO;
    CFRunLoopStop(m_runLoop);
    CFRelease(m_source);
}

@end
