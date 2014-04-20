//
//  ViewController.m
//  SampleOthello01
//
//  Created by YuichiSawada on 2014/02/12.
//  Copyright (c) 2014年 YuichiSawada. All rights reserved.
//

#import "ViewController.h"
#import "BoradView.h"


@interface ViewController ()

@end

@implementation ViewController
{
    UILabel *title;
    UIButton *pattern[2];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self drawHome];

}

- (void) drawHome
{
    title = [[UILabel alloc] init];
    title.text = @"自作オセロ";
    title.font = [UIFont fontWithName:@"AppleGothic" size:30];
    title.frame = CGRectMake(80, 40, 100, 80);
    [title sizeToFit];
    pattern[0] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pattern[0].frame = CGRectMake(70,100,150,80);
    [pattern[0] setTitle:@"人対人" forState:UIControlStateNormal];
    pattern[0].backgroundColor = [UIColor orangeColor];
    pattern[0].layer.borderColor = [UIColor blackColor].CGColor;
    pattern[0].layer.borderWidth = 1.0;
    [pattern[0] addTarget:self action:@selector(human_button:)forControlEvents:UIControlEventTouchDown];
    
    pattern[1] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pattern[1].frame = CGRectMake(70, 200, 150, 80);
    [pattern[1] setTitle:@"コンピューター" forState:UIControlStateNormal];
    pattern[1].layer.borderColor = [UIColor blackColor].CGColor;
    pattern[1].layer.borderWidth = 1.0;
    
    pattern[1].backgroundColor = [UIColor orangeColor];
    [pattern[1] addTarget:self action:@selector(computer_button:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:title];
    [self.view addSubview:pattern[0]];
    [self.view addSubview:pattern[1]];
}

- (IBAction) human_button:(UIButton *)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"人対人" message:@"版を表示します" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [av show];
}

- (IBAction)computer_button:(UIButton *)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"先行・後攻" message:@"黒か白か選んでください" delegate:self cancelButtonTitle:@"黒" otherButtonTitles:@"白", nil];
    [av show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex
{
        [self showBoradView:buttonIndex];
}

-(void)showBoradView : (int )num
{
    [title removeFromSuperview];
    [pattern[0] removeFromSuperview];
    [pattern[1] removeFromSuperview];
    BoradView *boradview = [BoradView sharedManager];
//    BoradView *boradview;
 //   boradview = [[BoradView alloc] init];
    [boradview setPlayerTurn:num];
    boradview.frame = self.view.frame;
    boradview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:boradview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
