//
//  ABViewController.m
//  AbraExample
//
//  Created by Thomas Ricouard on 04/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ABViewController.h"
#import <Abra/Abra.h>

@interface ABViewController ()

@end

@implementation ABViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ABAPI setupWithBaseURL:[NSURL URLWithString:@"http://api.twitter.com"]];
    [[ABAPI manager]setReachbilityStatusChangedBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%d", status);
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
