//
//  Stack.h
//  __core_sources
//
//  Created by verec on 25/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

+ (id) stack ;
- (void) push:(id) obj ;
- (id) pop ;  
- (id) peek ;
- (BOOL) empty ;

@end
