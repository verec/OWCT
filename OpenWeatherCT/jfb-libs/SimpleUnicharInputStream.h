//
//  SimpleUnicharInputStream.h
//  __core_sources
//
//  Created by verec on 24/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimpleUnicharInputStream : NSObject

+ (instancetype) simpleStreamWithString: (NSString *) dataIn ;
- (instancetype) initWithString: (NSString *) dataIn ;

- (BOOL) hasNext ;
- (unichar) next ;

// "pushes" the mark one notch back, hence leading `next' to return the same
// value it did
- (void) back ;

// returns the `mark' ie where the next character to be read is going to be
// fetched from
- (NSInteger) mark ;

// returns a chunk of the backingStore
- (NSString *) chunk: (NSRange) range ;

@end
