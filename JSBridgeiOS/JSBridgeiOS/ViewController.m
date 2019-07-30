//
//  ViewController.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/7/22.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSInteger, JSBModuleType) {
    getSystemInfo = 0,
    showModal
};

const NSArray *___JSBModuleType;

@interface ViewController ()

@property (nonatomic, assign) NSInteger moduleType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _moduleType = cJSBModuleTypeEnum(@"showModal");
    NSLog(@"%ld", _moduleType);
}


@end
