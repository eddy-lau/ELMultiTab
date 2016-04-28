/*
 *  DeleteBadgeDelegate.h
 *  TouchBible
 *
 *  Created by Eddie Lau on 13/03/2009.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

@class DeleteBadge;

@protocol DeleteBadgeDelegate

- (void) deleteBadgeTouchesEnded:(DeleteBadge *)DeleteBadge;

@end
