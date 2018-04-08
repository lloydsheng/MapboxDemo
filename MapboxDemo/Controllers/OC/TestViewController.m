//
//  TestViewController.m
//  MapboxDemo
//
//  Created by mapboxchina on 28/02/2018.
//  Copyright © 2018 lloydsheneg. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    [NSException raise:NSInvalidArgumentException format:@"arguments"];

//    @try {
////        dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
//            [NSException raise:NSInvalidArgumentException format:@"arguments"];
//        //        });
//    }
//    @catch (NSException * e) {
//        NSLog(@"Exception: %@", e);
//    }
//    @finally {
//        NSLog(@"finally");
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
