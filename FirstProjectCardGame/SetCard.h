//
//  SetCard.h
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/26/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong,nonatomic) NSString* color;
@property (strong,nonatomic) NSString* shading;
@property (strong,nonatomic) NSString* symbol;

@property (nonatomic) NSInteger number;

+(NSArray *) validColor;
+(NSArray *) validShading;
+(NSArray *) validSymbol;
+(NSInteger) maxNumber;

+ (NSArray *)cardsFromText:(NSString *)text;
@end
