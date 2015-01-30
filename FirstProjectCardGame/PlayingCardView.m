//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Liu Yisi on 1/9/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end


@implementation PlayingCardView

# pragma mark - Properties


@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.82
-(CGFloat) faceCardScaleFactor {
    // Make sure at least it will have a default value.
    if(!_faceCardScaleFactor) {
        _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    }
    return _faceCardScaleFactor;
}

-(void) setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
    _faceCardScaleFactor = faceCardScaleFactor;
    //anytime it changed, I tell the system it should be redrawn.
    [self setNeedsDisplay];
}





- (void) setSuit:(NSString *)suit
{
    _suit = suit;
    //anytime it changed, I tell the system it should be redrawn.
    if(_suit != suit) [self setNeedsDisplay];

}

- (void) setRank:(NSUInteger)rank {
    _rank = rank;
    if(_rank != rank) [self setNeedsDisplay];
}

- (void) setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}


#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat) cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat) cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat) cornerOffset { return [self cornerRadius] /3.0; }


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code --- using UIBezierPath
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    //shorthand for setpath and set the fill. but the background is white as default as well, so need to setup the background as transparent as well
    UIRectFill (self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    
    if(self.faceUp) {
    //draw the contents next
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[self rankAsString],self.suit]];
        if(faceImage) {
            CGRect imageRect = CGRectInset(self.bounds,
                                           self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                           self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
            
        } else {
            [self drawPips];
        }
    
        [self drawCorners];
    } else {
        [[UIImage imageNamed:@"cardBack"] drawInRect:self.bounds];
    }
    
    
    
}


- (void)pinch: (UIPinchGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

- (void) drawPips {  // draw the number on the card.
    //different from the lecture, you can copy the code from github, but there just implemented by image, but how to implement drawPips method to the card system, this should see the video in Wangyi.
}


- (NSString *) rankAsString{
     // @[][index]
     return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

-(void) drawCorners{
    NSMutableParagraphStyle *paragraphStyle  = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
    cornerFont =[cornerFont fontWithSize: cornerFont.pointSize*[self cornerScaleFactor]];
    

    UIColor *foregroundColor=[UIColor blackColor];
    //String is an object can not use == to implement equal content, it compares the pointer instead
    if([self.suit isEqualToString: @"♥︎"] || [self.suit isEqualToString: @"♦︎"]){
        foregroundColor =[UIColor redColor];
    }
    
    
    NSAttributedString *cornerText =  [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",[self rankAsString],self.suit] attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:foregroundColor}];
    
    
    
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    
    //use a C function to rotate the number upside down.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    
    [cornerText drawInRect:textBounds];
    
    
}


#pragma mark - Initialization

- (void) setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    // If bound is changed, it need to redraw.
    self.contentMode = UIViewContentModeRedraw;
}


// Crate the card from storyboard not using alloc init.
- (void) awakeFromNib {
    [self setup];
}


// super class UIView, so it is the designated initializer.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // you should redraw the card in the designated initialization.
        [self setup];
    }
    return self;
}



@end
