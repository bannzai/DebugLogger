//
//  DebugLoger.m
//  DebugLogger
//
//  Created by hirose yudai on 2015/07/22.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import "DebugLoger.h"

@interface DebugLoger () {
}

@end

@implementation DebugLoger

- (instancetype)init {
    self = [super init];
    if (self) {
        m_dicCache = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static typeof([self new]) s_sharedInstance = nil;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_sharedInstance = [[self alloc] init];
    });
    return s_sharedInstance;
}


- (void)registObject:(id)object {
    
    if (!object) {
        NSAssert(@"", @"To use not nil object");
        return;
    }
    
    @synchronized(m_dicCache) {
        // クラス毎にキャッシュわける
        NSString *strKeyClass = [NSString stringWithFormat:@"%@", NSStringFromClass([object class])];
        NSMutableArray *arrayClass = [m_dicCache objectForKey:strKeyClass];
        if (!arrayClass)
        {
            arrayClass = [NSMutableArray array];
            [m_dicCache setObject:arrayClass forKey:strKeyClass];
            
            NSLog(@"Regist object by : %@", strKeyClass);
        }
        
        // コンテナー作成
        DebugLogerContainer *container = nil;
        if ([self compareObject:arrayClass object:object]) {
            return;
        }
        
        container = [DebugLogerContainer new];
        [arrayClass addObject:container];
        
        // オブジェクト作成
        container.object = object;
    }
}

- (BOOL)compareObject:(NSArray*)array object:(id)object {
    DebugLogerContainer *container = nil;
    for (container in array) {
        if (container.object == object) {
            return YES;
        }
    }
    return NO;
}

- (id)getObject:(NSArray*)array object:(id)object {
    if (![self compareObject:array object:object]) {
        return nil;
    }
    id value = nil;
    for (DebugLogerContainer *container in array) {
        if (container.object == object) {
            value = object;
            break;
        }
    }
    return value;
}

- (void)logWithClass:(Class)c {
    NSMutableArray *arrayClass = [m_dicCache objectForKey:NSStringFromClass(c)];
    int idx = 0;
    for (DebugLogerContainer *container in arrayClass) {
        NSLog(@"idx : %d, object : %@",idx,container.object);
        idx++;
    }
}

- (void)descriptionLogWithClass:(Class)c {
    NSMutableArray *arrayClass = [m_dicCache objectForKey:NSStringFromClass(c)];
    int count = 0;
    for (DebugLogerContainer *container in arrayClass) {
        if ([container.object isKindOfClass:[UIViewController class]]) {
            [self descriptionLogWithViewController:container.object];
        } else if ([container.object isKindOfClass:[UIView class]]) {
            [self descriptionLogWithView:container.object];
        } else if (!container.object) {
            NSLog(@"no object in container ");
            count--;
        }
        count++;
    }
    
    if (count > 1 && [c isSubclassOfClass:[UIViewController class]]) {
        NSLog(@"cycle reference warning : %@",NSStringFromClass(c));
    }
}

- (void)descriptionLogWithViewController:(UIViewController*)viewController {
    NSLog(@"viewController description : %@ retaionCount : %ld" , viewController, CFGetRetainCount((__bridge CFTypeRef)viewController));
    [self viewControllerSubViewsLog:viewController];
}

- (void)viewControllerSubViewsLog:(UIViewController*)viewController {
    if (!viewController.isViewLoaded) { return; }
    [self viewSubViewsLog:viewController.view];
}

- (void)viewSubViewsLog:(UIView*)view {
    for (UIView *subview in view.subviews) {
//        if (subview.subviews.count) {
//            [self viewSubViewsLog:subview];
//        }
        [self descriptionLogWithView:subview];
    }
}

- (void)descriptionLogWithView:(UIView*)view {
    if ([view isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView*)view;
        NSLog(@"collectionview description : %@ delegate : %@ , datasource : %@ ",collectionView,collectionView.delegate,collectionView.dataSource);
        return;
    }
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView*)view;
        NSLog(@"tableView description : %@ delegate : %@ , datasource : %@ ",tableView,tableView.delegate,tableView.dataSource);
        return;
    }
    NSLog(@"view description class : %@ , view : %@ ", NSStringFromClass([view class]) ,view);
}

- (void)allDescription {
    for (NSString *key in m_dicCache.allKeys) {
        NSLog(@"allDescription class : %@",key);
        [self descriptionLogWithClass:NSClassFromString(key)];
    }
}

//- (void)cycleReferenceWarning {
//    for
//}

@end

@implementation DebugLogerContainer

@end

//@implementation UIViewController (debug)
//
//- (void)didReceiveMemoryWarning {
//    [[DebugLoger sharedInstance] allDescription];
//}
//
//@end
//@implementation UICollectionView (debug)
//- (instancetype)init {
//    self = [super init];
//    [[DebugLoger sharedInstance] registObject:self];
//    return self;
//}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [[DebugLoger sharedInstance] registObject:self];
//}
//@end
//@implementation UITableView (debug)
//- (instancetype)init {
//    self = [super init];
//    [[DebugLoger sharedInstance] registObject:self];
//    return self;
//}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [[DebugLoger sharedInstance] registObject:self];
//}
//@end