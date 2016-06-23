//
//  SExpValidityChecker.h
//  __core_sources
//
//  Created by verec on 24/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimpleUnicharInputStream ;

@interface SExpValidityChecker : NSObject {
	SimpleUnicharInputStream *	inStream ;
}

+ (id) simpleValidityChecker: (SimpleUnicharInputStream *) inUnicharStream ;
- (id) initWithUnicharStream: (SimpleUnicharInputStream *) inUnicharStream ;

// checks that there is only whitespace or nothing before the first open "("
// and nothing but whitespace or nothing after the last ")" while making sure
// that all the parens balance
- (BOOL) isBasicSyntaxValid ;

@end
