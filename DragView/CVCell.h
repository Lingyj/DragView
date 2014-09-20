//
//  CVCell.h
//  DragTest
//
//  Created by lingyj on 14-9-16.
//  Copyright (c) 2014年 lingyongjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragViewCellProtocol.h"

@interface CVCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *button;

//@interface CVCell : UICollectionViewCell<DragViewCellProtocol>

@end
