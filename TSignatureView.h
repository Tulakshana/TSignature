//
//  TSignatureView.h
//  TSignature
//
//  Created by T. A. Weerasooriya on 3/20/14.
//  Copyright (c) 2014 T. A. Weerasooriya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSignatureView : UIView{
    NSMutableArray *paths;
    UIBezierPath *currentPath;
    CGRect signatureArea;

}

- (IBAction)btnClearTapped:(id)sender;
- (IBAction)btnSaveTapped:(id)sender;


@end
