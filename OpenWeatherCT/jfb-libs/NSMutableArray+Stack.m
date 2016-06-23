//
//  Stack.m
//  __core_sources
//
//  Created by verec on 25/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack) 

+ (id) stack {
    return [NSMutableArray arrayWithCapacity: 10] ;
}

- (void) push:(id) obj {
    [self addObject:obj] ;
}

- (id) pop {
    id obj = [self peek] ;
    [self removeLastObject] ;
    return obj ;
}

- (id) peek {
    return [self lastObject] ;
}

- (BOOL) empty {
    return [self count] == 0 ;
}

@end 
