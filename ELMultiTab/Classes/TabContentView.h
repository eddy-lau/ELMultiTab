//
//  TabContentView.h
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 10/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabView.h"
#import "ELTabOrientation.h"

@interface TabContentView : UIView {

	id                            delegate;
	TabView                      *tabView;
	UIView                       *contentView;
	ELTabOrientation                 tabOrientation;
    BOOL                          hasTab;
	
}

@property (nonatomic,assign)     id        delegate;
@property (nonatomic,readonly)   TabView  *tabView;
@property (nonatomic,readonly)   UIView   *contentView;
@property (nonatomic)            BOOL      hasTab;
@property (nonatomic)            ELTabOrientation tabOrientation;

@end
