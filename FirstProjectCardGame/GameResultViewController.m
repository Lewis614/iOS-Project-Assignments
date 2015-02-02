//
//  GameResultViewController.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/29/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"


@interface GameResultViewController ()
//never create a outlet to public!
@property (weak, nonatomic) IBOutlet UITextView *scoreStatisticView;

@property (strong,nonatomic) NSArray *results;

@end





@implementation GameResultViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.results = [GameResult allGameResults];
    [self updateUI];

}

-(void)updateUI{
    NSString *finalRes = @"";
    for(GameResult *result in self.results) {
        finalRes = [finalRes stringByAppendingString:[self stringFromResult:result]];
    }
    self.scoreStatisticView.text = finalRes;
    
    //Doing Score sorted by ascend way, the best score is the last one.
    //NSArray * sortedSocres = [self.results sortedArrayUsingSelector:@selector(compareScore:)];
    NSArray * sortedRes = [self.results sortedArrayUsingSelector:@selector(compareScore:)];
    //set the different color for different score.
    [self changeScore:[sortedRes firstObject] toColor:[UIColor redColor]];
    [self changeScore:[sortedRes lastObject] toColor:[UIColor greenColor]];
    
    //Doing Time sorted by ascend way, the best score is the last one.
    //NSArray *sortedDuration = [self.results sortedArrayUsingSelector:@selector(compareDuration:)];

    sortedRes = [self.results sortedArrayUsingSelector:@selector(compareDuration:)];
    [self changeScore:[sortedRes firstObject] toColor:[UIColor orangeColor]];
    [self changeScore:[sortedRes lastObject] toColor:[UIColor blueColor]];
}

//because the NSTimeInterval is double data type, use %g to stand.
-(NSString *)stringFromResult:(GameResult *) result{
    return [NSString stringWithFormat:@" Game Type: %@\n Final Score: %ld\n Finish Time: %@\n Time Used: %g sec\n -----------------\n",
            result.gameType,
            result.score,
            [NSDateFormatter localizedStringFromDate:result.endTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle],
            //c function?
            round(result.duration)];
}

-(void) changeScore:(GameResult *)result toColor:(UIColor *)color {
    //NO * ahead of range!
    NSRange range= [self.scoreStatisticView.text rangeOfString:[self stringFromResult:result]];
    //textStorage is kind  of a place where the text store its settings.
    [self.scoreStatisticView.textStorage addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (IBAction)sortByDuration:(UIButton *)sender {
    self.results = [self.results sortedArrayUsingSelector:@selector(compareDuration:)];
    [self updateUI];
}



- (IBAction)sortByDate:(UIButton *)sender {
    self.results = [self.results sortedArrayUsingSelector:@selector(compareDate:)];
    [self updateUI];

}


- (IBAction)sortByScore:(UIButton *)sender {
    self.results = [self.results sortedArrayUsingSelector:@selector(compareScore:)];
    [self updateUI];
}


- (IBAction)resetHistory:(UIButton *)sender {
    [GameResult reset];
    self.results = [GameResult allGameResults];
    [self updateUI];
}




@end
