//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Liu Yisi on 1/9/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//


// Try to implement it as generic as possible.

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (nonatomic,strong) NSString *suit;
@property (nonatomic) BOOL faceUp;


- (void)pinch: (UIPinchGestureRecognizer *)gesture; 
@end
 