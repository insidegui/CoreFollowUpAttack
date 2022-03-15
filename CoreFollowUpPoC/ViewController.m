//
//  ViewController.m
//  CoreFollowUpPoC
//
//  Created by Gui Rambo on 23/12/20.
//

#import "ViewController.h"

#import "CFUPhishingAttack.h"

@interface ViewController ()

@property (strong) CFUPhishingAttack *attack;
@property (strong) id ctx;
@property (strong) id promptController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.attack = [CFUPhishingAttack new];
}

- (IBAction)triggerAttack:(id)sender
{
    [self.attack postNotification];
}

- (IBAction)clearAttack:(id)sender {
    [self.attack clearNotification];
}


@end
