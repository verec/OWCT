//
//  SExpValidityChecker.m
//  __core_sources
//
//  Created by verec on 24/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import "SExpValidityChecker.h"
#import "SimpleUnicharInputStream.h"

#import <ctype.h>

@implementation SExpValidityChecker

+ (id) simpleValidityChecker: (SimpleUnicharInputStream *) inUnicharStream {
	return [[SExpValidityChecker alloc] initWithUnicharStream: inUnicharStream] ;
}

- (id) initWithUnicharStream: (SimpleUnicharInputStream *) inUnicharStream {
	if (self = [super init]) {
		inStream = inUnicharStream ;
	}
	
	return self ;
}

- (BOOL) isBasicSyntaxValid {
	
	NSUInteger parenCount = 0 ;
	
    BOOL    inQuote = NO ;
    
	while ([inStream hasNext]) {
		unichar c = [inStream next] ;
	
        // avoid counting possibly unmatched, possibly backquoted parentheses
        if (inQuote) {
            if (c == '"') {
                inQuote = NO ;
            }
            continue ;
        }

		if (c == '(') {
			++parenCount ;
		} else if (c == ')') {
			--parenCount ;
		} else if (c == '"') {
            inQuote = YES ;
        }		
	}
	
	return parenCount == 0 ;
}


- (void) dealloc {
	inStream = nil ;
}

@end
