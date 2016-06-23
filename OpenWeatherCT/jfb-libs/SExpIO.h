//
//  SExpIO.h
//  __core_sources
//
//  Created by verec on 26/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SExp ;

extern NSString * SEXPIO_EXPORT_HEADER_PRINT ;
extern NSString * SEXPIO_EXPORT_HEADER_KEY ;
extern NSString * SEXPIO_EXPORT_CUSTOM_HEADER ;
extern NSString * SEXPIO_EXPORT_BLANK_LINES_HEADER ;
extern NSString * SEXPIO_EXPORT_BLANK_LINES_PARAGRAPH ;
extern NSString * SEXPIO_EXPORT_FLOATING_POINT_FORMAT ;
extern NSString * SEXPIO_EXPORT_INTEGER_FLOAT_THRESHOLD ;
extern NSString * SEXPIO_EXPORT_TAB_COUNT ;
extern NSString * SEXPIO_EXPORT_LINE_NUMBERS ;
extern NSString * SEXPIO_EXPORT_LINE_NUMBERS_COLUMN ;

@interface SExpIO : NSObject

+ (NSData *) encode: (SExp   *) sexp ;
+ (SExp   *) decode: (NSData *) data ;

+ (NSMutableDictionary *) properties ;

@end
