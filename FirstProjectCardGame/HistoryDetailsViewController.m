//
//  HistoryDetailsViewController.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/28/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "HistoryDetailsViewController.h"

@interface HistoryDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end




@implementation HistoryDetailsViewController

//When the array gets set and is on screen, or when the view appears on screen we will update the interface:
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void) setHistory:(NSArray *)history {
    _history = history;
    if (self.view.window) [self updateUI];
}


-(void)updateUI{
    if([[self.history firstObject] isKindOfClass:[NSAttributedString class]]){
        NSMutableAttributedString *historyText = [[NSMutableAttributedString alloc]init];
        NSInteger count = 1;
        for(NSAttributedString *item in self.history){
            [historyText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"-----STEP %2d:-----\n", count++]]];
            [historyText appendAttributedString:item];
            [historyText appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n\n"]];
        }
        UIFont *font = [self.historyTextView.textStorage attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
        [historyText addAttribute: NSFontAttributeName value:font range:NSMakeRange(0,historyText.length)];
        self.historyTextView.attributedText = historyText;
    }
    else{
        NSInteger count = 1;
        NSString *historyText = @"";
        for(NSString *item in self.history) {
            historyText = [NSString stringWithFormat:@"%@-----STEP %2d:-----\n%@\n\n",historyText,count++,item];
        }
        self.historyTextView.text = historyText;
    }
}
@end
