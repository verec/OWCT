//
//  SExpTokenizer.m
//  __core_sources
//
//  Created by verec on 22/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import <ctype.h>
#import "SExpTokenizer.h"
#import "SimpleUnicharInputStream.h"

@interface SExpTokenizer () 

- (SExpTokenizerTokenTypes) nextTokenInternal ;
- (instancetype) initWithInputStream: (SimpleUnicharInputStream *) inputStream ;

@property (nonatomic, strong) SimpleUnicharInputStream *	inStream ;

@end

@implementation SExpTokenizer

@synthesize inStream ;
@synthesize stringValue ;

static unichar sexp_valid_token_ASCII[128] ;

static void sexp_valid_token_ASCII_range(int from, int upToIncluding) {
	for (int i = from ; i <= upToIncluding ; ++i) {
		sexp_valid_token_ASCII[i] = i ;
	}
}

static void sexp_valid_token_ASCII_init() {
    memset(&sexp_valid_token_ASCII[0], 0, 32) ;
	sexp_valid_token_ASCII_range('A', 'Z') ;
	sexp_valid_token_ASCII_range('a', 'z') ;
	sexp_valid_token_ASCII_range(0x21, 0x21) ;	// !
	sexp_valid_token_ASCII_range(0x23, 0x27) ;	// #$%&
	sexp_valid_token_ASCII_range(0x2a, 0x2f) ;	// *+,-./
	sexp_valid_token_ASCII_range('0', '9') ;	// 0123456789
	sexp_valid_token_ASCII_range(0x3a, 0x3f) ;	// :<=>?
	sexp_valid_token_ASCII_range(0x5b, 0x5f) ;	// [\]^_
	sexp_valid_token_ASCII_range(0x7b, 0x7e) ;	// {|}~
}

static BOOL sexp_valid_token(unichar c) {
	return c > 0x7f || sexp_valid_token_ASCII[c & 0x7f] ;
}

+ (instancetype) simpleSExpTokenizer: (SimpleUnicharInputStream *) inputStream {
	return [[SExpTokenizer alloc] initWithInputStream: inputStream] ;
}

- (instancetype) initWithInputStream: (SimpleUnicharInputStream *) inputStream {
	if (self = [super init]) {		
		inStream = inputStream ;
		
		if (sexp_valid_token_ASCII['A'] == 0) {
			sexp_valid_token_ASCII_init() ;
		}
	}
	
	return self ;
}

- (SExpTokenizerTokenTypes) nextToken {
	// we may potentially generate a reasonable amount of garbage on each pass
	// through: don't rely on the outside autorelease pool that might get called
	// way too late ... better slow (ish) than sorry, right?

    SExpTokenizerTokenTypes token = SExpTokenizerTokenType_EOF ;
    
    @autoreleasepool {
        token = [self nextTokenInternal] ;
    }

	return token ;
}


- (SExpTokenizerTokenTypes) nextTokenInternal {
	// last time I was called I returned in a known state, whichever it was.
	// start afresh
	NSMutableString * 	text 		= [NSMutableString stringWithCapacity: 128] ;
	BOOL 				inQuote ;
startOver:	
	inQuote = NO ;

startInQuote:	
	while ([self.inStream hasNext]) {
		unichar c = [self.inStream next] ;
		
		// -- Quote handling (in quote)		
		if (inQuote) {
			if (c == '"') {
				// finish off the string
				self.stringValue = text ;
				return SExpTokenizerTokenType_String ;
			} else if (c == '\\') {
				if ([self.inStream hasNext]) {
					unichar c2 = [self.inStream next] ;
					switch (c2) {
						case '\\':
						case '(':
						case ')':
						case '"':
							// TODO: ++startMark INSTEAD of on the fly garbage strings
							[text appendString: [NSString stringWithCharacters: &c2 
																		length:1]] ;
							break;
						default:
							[text appendString: [NSString stringWithCharacters: &c
																		length:1]] ;
							[text appendString: [NSString stringWithCharacters: &c2
																		length:1]] ;
							break;
					}
				} else {
					return SExpTokenizerTokenType_EOF ;
				}
			} else {
				[text appendString: [NSString stringWithCharacters: &c
															length:1]] ;
			}
		}
		
		
		// -- white space -- don't really trust std c isspace
		else if (c <= 0x20) {
			while ([self.inStream hasNext]) {
				unichar c2 = [self.inStream next] ;
				if (c2 > 0x20) {
					[self.inStream back] ;
					goto startOver ;	
				}
			}
			return SExpTokenizerTokenType_EOF ;
		}
		
		// -- Comment char		
		else if (c == ';') {
			// skip to end of line
			while ([self.inStream hasNext]) {
				unichar c2 = [self.inStream next] ;
				if (c2 == 0x0a) {	// line-feed? we break and resume
					goto startOver ;	
				}
			}
			return SExpTokenizerTokenType_EOF ;
		}
		
		// -- Quote handling (start quote)
		else if (c == '"') {
			inQuote = YES ;
			goto startInQuote ;	
		}
		
		// -- Left parenthesis		
		else if (c == '(') {
			return SExpTokenizerTokenType_LeftParen ;
		}
		
		// -- Right parenthesis		
		else if (c == ')') {
			return SExpTokenizerTokenType_RightParen ;
		}
		
		// -- otherwise that's a token: keep accumulating
		else {
			[text appendString: [NSString stringWithCharacters: &c
														length:1]] ;
			while ([self.inStream hasNext]) {
				unichar c2 = [self.inStream next] ;
				if (sexp_valid_token(c2)) {
					[text appendString: [NSString stringWithCharacters: &c2
																length:1]] ;
				} else {
					[self.inStream back] ;
					self.stringValue = text ;
					return SExpTokenizerTokenType_Token ;
				}
			}			
			return SExpTokenizerTokenType_EOF ;
		}
	}
	return SExpTokenizerTokenType_EOF ;
}

@end
