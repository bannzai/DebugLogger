//
//  DebugLoger.h
//  DebugLogger
//
//  Created by hirose yudai on 2015/07/22.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DebugLoger : NSObject {
    NSMutableDictionary *m_dicCache;
}

+ (instancetype)sharedInstance;
- (void)registObject:(id)object;
- (BOOL)compareObject:(NSArray*)array object:(id)object;
- (id)getObject:(NSArray*)array object:(id)object ;
- (void)logWithClass:(Class)c;
- (void)descriptionLogWithClass:(Class)c;
- (void)descriptionLogWithViewController:(UIViewController*)viewController;
- (void)viewControllerSubViewsLog:(UIViewController*)viewController;
- (void)viewSubViewsLog:(UIView*)view;
- (void)descriptionLogWithView:(UIView*)view;
- (void)allDescription;

@end

@interface DebugLogerContainer : NSObject
@property (weak ,nonatomic) id object;
@end

//@interface UIViewController (debug)
//
//- (void)didReceiveMemoryWarning;;
//@end
//@interface UICollectionView (debug)
//- (instancetype)init;
//- (void)awakeFromNib;
//@end
//@interface UITableView (debug)
//- (instancetype)init;
//- (void)awakeFromNib;
//@end