//
// ViewController.m
// ZXPlacePicker
//
// Created by ziv on 2017/7/14.
// Copyright © 2017年 ziv. All rights reserved.
//

#import "ViewController.h"
#import "ZXPlacePickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushToPlacePickerViewController:(UIButton *)sender {
	ZXPlacePickerViewController *viewController = [[ZXPlacePickerViewController alloc] init];
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
