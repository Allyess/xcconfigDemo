//
//  ViewController.m
//  twst
//
//  Created by sijia on 2019/5/29.
//  Copyright © 2019 allyes. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 验证 .xcconfig 是否生效
    NSLog(@"%@",API_BASE_URL);
}


@end
