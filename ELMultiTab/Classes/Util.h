/*
 *  Util.h
 *  Browser
 *
 *  Created by Eddie Lau on 24/12/2010.
 *  Copyright 2010 TouchUtility.com. All rights reserved.
 *
 */

#ifndef __UTIL_H__
#define __UTIL_H__

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD 0
#endif

#endif