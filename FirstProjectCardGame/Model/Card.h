//
//  Card.h
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 12/28/14.
//  Copyright (c) 2014 Cornell University. All rights reserved.
//

#import <Foundation/Foundation.h>
// OR for only IOS7 @import Foundation;

@interface Card : NSObject


@property (strong,nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;


@property (nonatomic) NSInteger numberOfInitialSettingOfMatchingCard;
-(NSInteger)match:(NSArray *)otherCards;

@end


