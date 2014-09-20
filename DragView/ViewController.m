//
//  ViewController.m
//  DragView
//
//  Created by lingyj on 14-9-17.
//  Copyright (c) 2014年 lingyongjian. All rights reserved.
//

#import "ViewController.h"
#import "DragViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<DragViewDatasource,DragViewDelegate>
{
    DragViewController *dragVC;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dragVC = [[UIStoryboard storyboardWithName:@"DragView" bundle:nil] instantiateViewControllerWithIdentifier:@"DragViewController"];
    [self.view addSubview:dragVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
