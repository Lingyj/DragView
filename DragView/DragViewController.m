//
//  ViewController.m
//  DragTest
//
//  Created by lingyj on 14-9-16.
//  Copyright (c) 2014年 lingyongjian. All rights reserved.
//

#import "DragViewController.h"
#import "CVCell.h"

#define Duration 0.2

@interface DragViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *data;
    
    BOOL isMoving;
    
    IBOutlet UICollectionView *_collectionView;
    
    UIButton *movingBtn;
//    NSInteger movingIndex;
}

@end

@implementation DragViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    data = [NSMutableArray array];
    for (int i = 0 ; i < 30 ; i++)
    {
        [data addObject:@(i)];
    }
    
//    movingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 30)];
//    [movingBtn setBackgroundColor:[UIColor redColor]];
//    [movingBtn addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
//    [movingBtn addTarget:self action:@selector(dragEnd:withEvent:) forControlEvents:UIControlEventTouchUpInside |
//     UIControlEventTouchUpOutside];
//    [self.view addSubview:movingBtn];
//    
//    movingBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
//    if (movingBtn)
//    {
//        CGPoint center = movingBtn.center;
//        CGRect frame = movingBtn.frame;
//        frame.size = CGSizeMake(70, 30);
//        movingBtn.frame = frame;
//        movingBtn.center = center;
//    }
//}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    
//    if (movingBtn)
//    {
//        CGPoint center = movingBtn.center;
//        CGRect frame = movingBtn.frame;
//        frame.size = CGSizeMake(70, 30);
//        movingBtn.frame = frame;
//        movingBtn.center = center;
//    }
//}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = cell.button.tag = indexPath.row;
    [cell.button setTitle:[data[indexPath.row] stringValue] forState:UIControlStateNormal];
    
    UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell.button addGestureRecognizer:lp];
//    [cell.button addTarget:self action:@selector(touchInside:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark -
- (void)longPress:(UILongPressGestureRecognizer *)sender
{
    UIButton *btn = (UIButton *)sender.view;
    CGPoint touchPoint = [sender locationInView:self.view];
    CVCell *movingCell = (CVCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:btn.tag inSection:0]];

    if (sender.state == UIGestureRecognizerStateBegan)
    {
        CGRect frame = [self.view convertRect:btn.frame fromView:movingCell];
        CGPoint center = [self.view convertPoint:btn.center fromView:movingCell];

        btn.frame = frame;
        btn.center = center;
        [self.view addSubview:btn];
        
        [UIView animateWithDuration:Duration animations:^{
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            btn.alpha = 0.7;
        }];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        btn.center = touchPoint;

        for (CVCell *cell in [_collectionView visibleCells])
        {
            if (CGRectContainsPoint(cell.frame, touchPoint))
            {
                if (movingCell.tag != cell.tag)
                {
                    //交换数组元素
                    id obj = [data objectAtIndex:movingCell.tag];
                    [data removeObject:obj];
                    [data insertObject:obj atIndex:cell.tag];
                    //判断后面的挪到前面还是前面的挪到后面
                    int max = MAX(movingCell.tag, cell.tag);
                    int min = MIN(movingCell.tag, cell.tag);
                    BOOL isUp = (max == movingCell.tag);
                    //因为不会刷新，刷新会闪下很难看，所以需要计算新的tag
                    for (int i = min; i < max+1; i++)
                    {
                        CVCell *tempCell = (CVCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                        //tag重新标识
                        if (isUp && i == max)
                        {
                            tempCell.tag = tempCell.button.tag = min;
                        }
                        else if (!isUp && i == min)
                        {
                            tempCell.tag = tempCell.button.tag = max;
                        }
                        else
                        {
                            NSInteger tag = (isUp?i+1:i-1);
                            tempCell.tag = tempCell.button.tag = tag;
                        }
                    }
                    
                    movingBtn = nil;
                    
                    [_collectionView moveItemAtIndexPath:[_collectionView indexPathForCell:movingCell] toIndexPath:[_collectionView indexPathForCell:cell]];
                }
                
                break;
            }
        }
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:Duration animations:^{
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.f;
        }];
        
        [movingCell addSubview:btn];
        btn.center = CGPointMake(movingCell.frame.size.width/2, movingCell.frame.size.height/2);
        
        for (CVCell *cell in [_collectionView visibleCells])
        {
            if (CGRectContainsPoint(cell.frame, touchPoint))
            {
                if (movingCell.tag != cell.tag)
                {
                    id obj = [data objectAtIndex:movingCell.tag];
                    [data removeObject:obj];
                    [data insertObject:obj atIndex:cell.tag];
                    
                    int max = MAX(movingCell.tag, cell.tag);
                    int min = MIN(movingCell.tag, cell.tag);
                    BOOL isUp = (max == movingCell.tag);
                    
                    for (int i = min; i < max+1; i++)
                    {
                        CVCell *tempCell = (CVCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                        
                        if (isUp && i == max)
                        {
                            tempCell.tag = tempCell.button.tag = min;
                        }
                        else if (!isUp && i == min)
                        {
                            tempCell.tag = tempCell.button.tag = max;
                        }
                        else
                        {
                            NSInteger tag = (isUp?i+1:i-1);
                            tempCell.tag = tempCell.button.tag = tag;
                        }
                    }
                    
                    movingBtn = nil;
                    
                    [_collectionView moveItemAtIndexPath:[_collectionView indexPathForCell:movingCell] toIndexPath:[_collectionView indexPathForCell:cell]];
                }
                
                break;
            }
        }

    }

    
}

@end
