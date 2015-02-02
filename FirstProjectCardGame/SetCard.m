//
//  SetCard.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/26/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

// the only place to set value to self
-(instancetype)init{
    self = [super init];
    if(self) {
        self.numberOfInitialSettingOfMatchingCard = 3;
    }
    
    return self;
    
}

// change the getter and setter both.
@synthesize color=_color, shading = _shading, symbol = _symbol;

-(NSString *) color{
    return _color ? _color : @"?";
}

-(void) setColor:(NSString *)color {
    if([[SetCard validColor] containsObject:color]) _color=color;
}

-(NSString *)shading {
    return _shading ? _shading : @"?";
}

-(void) setShading:(NSString *)shading {
    if([[SetCard validShading] containsObject:shading]) _shading=shading;
}

-(NSString *)symbol{
    return _symbol ? _symbol : @"?";
}

-(void) setSymbol:(NSString *)symbol {
    if([[SetCard validSymbol] containsObject:symbol]) _symbol=symbol;
}


-(void) setNumber:(NSInteger)number {
    if(number<=[SetCard maxNumber]) _number = number;
}


+(NSArray *) validColor {
    return @[@"red", @"green",@"purple"];
}

+(NSArray *) validSymbol {
    return @[@"diamond", @"squiggle", @"oval"];
}

+(NSArray *) validShading {
    return @[@"solid", @"striped", @"open"];
}

+(NSInteger) maxNumber {
    return 3;
}


//later update
-(NSString *) contents {
    return [NSString stringWithFormat:@"%@,%@,%@,%ld",self.symbol,self.shading,self.color, self.number];
}

-(NSInteger)match:(NSArray *)otherCards {
    
    NSInteger score = 0;
    
    if([otherCards count] == self.numberOfInitialSettingOfMatchingCard-1){
        NSMutableArray *colors = [[NSMutableArray alloc]init];
        NSMutableArray *symbols = [[NSMutableArray alloc]init];
        NSMutableArray *shadings = [[NSMutableArray alloc]init];
        NSMutableArray *numbers = [[NSMutableArray alloc]init];
        
        [colors addObject:self.color];
        [symbols addObject:self.symbol];
        [shadings addObject:self.shading];
        [numbers addObject:[NSNumber numberWithInteger:self.number]];
        
        // kind of a introspection:id because you have to iterate different kind of card
        for(id otherCard in otherCards){
            if([otherCard isKindOfClass:[SetCard class]]){
                SetCard * otherSetCard = (SetCard *)otherCard;
                if(![colors containsObject:otherSetCard.color]) [colors addObject:otherSetCard.color];
                if(![symbols containsObject:otherSetCard.symbol]) [symbols addObject:otherSetCard.symbol];
                if(![shadings containsObject:otherSetCard.shading]) [shadings addObject:otherSetCard.shading];
                if(![numbers containsObject:[NSNumber numberWithInteger:otherSetCard.number]]) [numbers addObject: [NSNumber numberWithInteger:otherSetCard.number]];
                
            }
        }
        if(([colors count] == 1 || [colors count] == self.numberOfInitialSettingOfMatchingCard)
           && ([symbols count] == 1 || [symbols count] == self.numberOfInitialSettingOfMatchingCard)
           && ([shadings count] == 1 || [shadings count] == self.numberOfInitialSettingOfMatchingCard)
           && ([numbers count] == 1 || [numbers count] == self.numberOfInitialSettingOfMatchingCard)) {
            score =4;
        }
        
    }
    return score;
}

+ (NSArray *)cardsFromText:(NSString *)text{
    return nil;
}


@end




