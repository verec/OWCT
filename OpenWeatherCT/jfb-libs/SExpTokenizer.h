//
//  SExpTokenizer.h
//  __core_sources
//
//  Created by verec on 22/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, SExpTokenizerTokenTypes) {
	SExpTokenizerTokenType_EOF 			= 0
,	SExpTokenizerTokenType_LeftParen
,	SExpTokenizerTokenType_RightParen
,	SExpTokenizerTokenType_Token
,	SExpTokenizerTokenType_String
} NS_ENUM_AVAILABLE(10_8, 6_0) ;

@class SimpleUnicharInputStream ;

@interface SExpTokenizer : NSObject

@property (nonatomic, strong) NSString *                stringValue ;

+ (instancetype) simpleSExpTokenizer: (SimpleUnicharInputStream *) inputStream ;

- (SExpTokenizerTokenTypes) nextToken ;

@end
