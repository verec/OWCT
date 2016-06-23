//
//  SimpleUnicharInputStream.m
//  __core_sources
//
//  Created by verec on 24/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import "SimpleUnicharInputStream.h"

@interface SimpleUnicharInputStream ()

@property (nonatomic, strong)   NSString *	backingStore ;
@property (nonatomic, assign)   NSInteger	current ;
@property (nonatomic, assign)   NSInteger	limit ;

@end

@implementation SimpleUnicharInputStream

+ (instancetype) simpleStreamWithString: (NSString *) dataIn {
	return [[SimpleUnicharInputStream alloc] initWithString: dataIn] ;
}

- (instancetype) initWithString: (NSString *) dataIn {
	if (self = [super init]) {
		self.backingStore = dataIn ;
		self.current = 0 ;
		self.limit = [self.backingStore length] ;
	}
	
	return self ;
}

- (BOOL) hasNext {
	return self.current < self.limit ;
}

- (void) back {
	if (--self.current < 0) {
		// this is unrecoverable: we don't have GC on the iPhone, and the
		// top level logic is obviously screwed. Better call JFB and give
		// him an earful!
		[[NSException exceptionWithName: NSRangeException
								 reason: @"Bug in production code: stream back call results in negative position" 
							   userInfo: nil] raise] ;
	}
}

- (unichar) next {
	if (self.current >= self.limit) {
		// this is unrecoverable: we don't have GC on the iPhone, and the
		// top level logic is obviously screwed. Better call JFB and give
		// him an earful!
		[[NSException exceptionWithName: NSRangeException
								 reason: @"Bug in production code: stream next call results in beyond limit position" 
							   userInfo: nil] raise] ;
	}
	return [self.backingStore characterAtIndex: self.current++] ;
}

- (NSInteger) mark {
	return self.current ;
}

- (NSString *) chunk: (NSRange) range {
	return [self.backingStore substringWithRange: range] ;
}

- (void) dealloc {
	self.backingStore = nil ;
}

@end
