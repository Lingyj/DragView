//
//  ViewController.h
//  DragTest
//
//  Created by lingyj on 14-9-16.
//  Copyright (c) 2014年 lingyongjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DragViewController;

@protocol DragViewDatasource <NSObject>

@required
- (NSString *)cellClassName;
- (NSString *)cellIndetifier;
@end

@protocol DragViewDelegate <NSObject>
- (void)dragView:(DragViewController *)dragVC dragBeginWithIndex:(NSInteger)index;
- (void)dragView:(DragViewController *)dragVC dragMoveWithIndex:(NSInteger)index;
- (void)dragView:(DragViewController *)dragVC dragEndIndex:(NSInteger)index;
@end

@interface DragViewController : UIViewController

@end
