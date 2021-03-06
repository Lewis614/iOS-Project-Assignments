//
//  SetCardView.h
//  Matchismo
//
//  Created by Liu Yisi on 1/30/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;
@property (nonatomic) BOOL chosen;


@end
