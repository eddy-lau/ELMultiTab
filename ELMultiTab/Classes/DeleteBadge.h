//
//  DeleteBadge.h
//  TouchBible
//
//  Created by Eddie Lau on 12/03/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DeleteBadge : UIView {
    id delegate; 
}

- (void) handleTouchAtPoint:(CGPoint)point;

@property (nonatomic,assign) id delegate;

@end
