//
//  TSignatureView.m
//  TSignature
//
//  Created by T. A. Weerasooriya on 3/20/14.
//  Copyright (c) 2014 T. A. Weerasooriya. All rights reserved.
//

#import "TSignatureView.h"



// pi is approximately equal to 3.14159265359.
#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@implementation TSignatureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    paths = nil;
    
    [super dealloc];
}

#pragma mark - Drawing code

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    signatureArea = CGRectMake(20, 20, 728, 859);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextFillRect(context, signatureArea);
    
    [[UIColor blackColor] set];
    for (UIBezierPath *path in paths) {
        [path stroke];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    // Get the specific point that was touched
    if (CGRectContainsPoint(signatureArea, [touch locationInView:self])) {
        if (!paths) {
            paths = [[NSMutableArray alloc]init];
        }
        UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:[touch locationInView:self]
                                                             radius:0.5
                                                         startAngle:0
                                                           endAngle:DEGREES_TO_RADIANS(360)
                                                          clockwise:YES];
        [paths addObject:aPath];
        
        
        currentPath = [UIBezierPath bezierPath];
        currentPath.lineWidth = 1.0;
        [currentPath moveToPoint:[touch locationInView:self]];
        [paths addObject:currentPath];
        
        [self setNeedsDisplay];

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    // Get the specific point that was touched
    if (CGRectContainsPoint(signatureArea, [touch locationInView:self])) {
        [currentPath addLineToPoint:[touch locationInView:self]];
        [self setNeedsDisplay];
        
        
    }
}



#pragma mark -

- (IBAction)btnClearTapped:(id)sender{
    if (paths) {
        [paths removeAllObjects];
        [self setNeedsDisplay];
    }
}

- (IBAction)btnSaveTapped:(id)sender{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [[UIColor blackColor] setStroke];
    
    UIImage *signatureImage = nil;

        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds]; // enclosing bitmap by a rectangle defined by another UIBezierPath object
        [[UIColor whiteColor] setFill];
        [rectpath fill]; // filling it with white

    [signatureImage drawAtPoint:CGPointZero];
    for (UIBezierPath *path in paths) {
        [path stroke];
    }
    signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(signatureImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);

    
}

- (void) image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo{
    NSString *message = nil;
    if (!error) {
        message = @"Signature saved to album";
    }else {
        message = @"Error occurred while saving the signature to album. Please check whether you have granted necessary permissions to the app to perform this task";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Signature" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [self btnClearTapped:nil];
}


@end
