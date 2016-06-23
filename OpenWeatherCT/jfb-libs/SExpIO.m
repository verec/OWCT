//
//  SExpIO.m
//  __core_sources
//
//  Created by verec on 26/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import "SExp.h"
#import "SExpIO.h"

#import "SExpTokenizer.h" 
#import "SExpValidityChecker.h"
#import "SimpleUnicharInputStream.h"

#import "NSMutableArray+Stack.h"

NSString * SEXPIO_EXPORT_HEADER_PRINT           = @"sexpio/export/header/print" ;
NSString * SEXPIO_EXPORT_HEADER_KEY             = @"sexpio/export/header/key" ;
NSString * SEXPIO_EXPORT_CUSTOM_HEADER          = @"sexpio/export/custom/header/key" ;
NSString * SEXPIO_EXPORT_BLANK_LINES_HEADER     = @"sexpio/export/blank-lines/header" ;
NSString * SEXPIO_EXPORT_BLANK_LINES_PARAGRAPH  = @"sexpio/export/blank-lines/paragraph" ;
NSString * SEXPIO_EXPORT_FLOATING_POINT_FORMAT  = @"sexpio/export/floating-point/format" ;
NSString * SEXPIO_EXPORT_INTEGER_FLOAT_THRESHOLD= @"sexpio/export/integer-float/threshold" ;
NSString * SEXPIO_EXPORT_TAB_COUNT              = @"sexpio/export/tab/count" ;
NSString * SEXPIO_EXPORT_LINE_NUMBERS           = @"sexpio/export/line/numbers" ;
NSString * SEXPIO_EXPORT_LINE_NUMBERS_COLUMN    = @"sexpio/export/line/numbers/column" ;

@interface SExpIO ()

+ (SExpIO *) sexpio ;

- (NSString *) header ;

- (SExp *) read: (SExpTokenizer *) tokenizer ;

- (NSString *) write: (SExp *) root toString: (NSMutableString *) outString ;

- (void) dump: (SExp *) root ;

@property (assign, nonatomic) int contiguousClose ;

@end

@implementation SExpIO

@synthesize contiguousClose ;

+ (NSMutableDictionary *) properties {
    
    static NSMutableDictionary * props = nil ;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSDictionary * dict = @{
            SEXPIO_EXPORT_HEADER_KEY:
                [NSString stringWithFormat:@";;; Generated on %@ [GMT] by SExpIO", [[NSDate date] description]]
        ,   SEXPIO_EXPORT_FLOATING_POINT_FORMAT:
                @"%0.3f"
        ,   SEXPIO_EXPORT_INTEGER_FLOAT_THRESHOLD:
                @0.001
        ,   SEXPIO_EXPORT_BLANK_LINES_HEADER:
                @"2"
        ,   SEXPIO_EXPORT_BLANK_LINES_PARAGRAPH:
                @1
        ,   SEXPIO_EXPORT_TAB_COUNT:
                @2
        ,   SEXPIO_EXPORT_HEADER_PRINT:
                @NO
        ,   SEXPIO_EXPORT_LINE_NUMBERS:
                @YES
        ,   SEXPIO_EXPORT_LINE_NUMBERS_COLUMN:
                @75
        } ;

        props = [NSMutableDictionary dictionaryWithDictionary:dict] ;
    });

    return props ;
}

+ (BOOL) doesPrintHeader {
    return [[self properties][SEXPIO_EXPORT_HEADER_PRINT] boolValue] ;
}

+ (int) headerBlankLines {
    return [[self properties][SEXPIO_EXPORT_BLANK_LINES_HEADER] intValue] ;
}

- (NSString *) header {
    return [[self class] properties] [SEXPIO_EXPORT_HEADER_KEY] ;
}

+ (NSString *) custom {
    return [[self class] properties] [SEXPIO_EXPORT_CUSTOM_HEADER] ;
}

+ (int) paragraphBlankLines {
    return [[self properties][SEXPIO_EXPORT_BLANK_LINES_PARAGRAPH] intValue] ;
}

+ (int) tabCount {
    return [[self properties][SEXPIO_EXPORT_TAB_COUNT] intValue] ;
}

+ (BOOL) lineNumbers {
    return [[self properties][SEXPIO_EXPORT_LINE_NUMBERS] boolValue] ;
}

- (BOOL) lineNumbers {
    return [[self class] lineNumbers] ;
}

+ (NSInteger) lineNumbersColumn {
    return [[self properties][SEXPIO_EXPORT_LINE_NUMBERS_COLUMN] intValue] ;
}

- (NSInteger) lineNumbersColumn {
    return [[self class] lineNumbersColumn] ;
}


+ (SExpIO *) sexpio {
	return [[SExpIO alloc] init] ;
}

+ (SExp *) decode: (NSData *) data {
    
    @autoreleasepool {
        
        NSString * payload      = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        
        SExpValidityChecker * checker = [SExpValidityChecker simpleValidityChecker:
                                         [SimpleUnicharInputStream simpleStreamWithString: payload]] ;
        
        if (![checker isBasicSyntaxValid]) {
            return nil ;
        }
        
        SExpTokenizer * tokenizer = [SExpTokenizer simpleSExpTokenizer:
                                     [SimpleUnicharInputStream simpleStreamWithString: payload]] ;
        
        return [[SExpIO sexpio] read: tokenizer] ;
    }
}

- (SExp *) read: (SExpTokenizer *) tokenizer {
    // root must survive the pool
    SExp * 				root 	= [SExp sexp] ;

    NSMutableArray *	stack	= [NSMutableArray stack] ;
    SExp * 				child	= nil ;
    SExp * 				parent	= nil ;
    
    root.token = @"<root>" ;
    
    [stack push:root] ;
    
    int token = -1 ;
    
    @autoreleasepool {
        
        while ((token = [tokenizer nextToken]) != SExpTokenizerTokenType_EOF) {
            
            switch (token) {
                    
                case	SExpTokenizerTokenType_LeftParen:
                    child = [SExp sexp] ;
                    parent= [stack peek] ;
                    [parent.children addObject:child] ;
                    [stack push:child] ;
                    continue ;
                    
                case	SExpTokenizerTokenType_RightParen:
                    [stack pop] ;
                    continue ;
                    
                case	SExpTokenizerTokenType_String:
                case	SExpTokenizerTokenType_Token:
                    parent= [stack peek] ;
                    if (parent.token == nil) {
                        parent.token = tokenizer.stringValue ;
                    } else {
                        [parent.attributes addObject:tokenizer.stringValue] ;
                    }
                    continue ;
            }
        }
    }
    
    
    return root ;
}

+ (NSData *) encode: (SExp *) root {
    NSMutableString * s = [NSMutableString stringWithCapacity:200] ;
    NSString * custom = [self custom] ;
    if (custom && [custom length] > 0) {
        if (![custom hasPrefix:@";"]) {
            [s appendString:@";;; "] ;
        }
        [s appendString:custom] ;
    }
    NSString * r = [[SExpIO sexpio] write:root toString:s] ;
    return [r dataUsingEncoding:NSUTF8StringEncoding] ;
}

- (NSString *) write: (SExp *) root toString: (NSMutableString *) outString {

    if ([[self class] doesPrintHeader]) {
        [outString appendFormat: @";;; \n"] ;
        [outString appendString:[self header]] ;
        [outString appendFormat: @"\n;;; "] ;

        NSDictionary * props = [[self class] properties] ;
        for (NSString * key in props) {
            if (![key isEqualToString:SEXPIO_EXPORT_HEADER_KEY]) {
                [outString appendString:[NSString stringWithFormat:@"\n;;; %-40s: ", [key UTF8String]]] ;
                [outString appendString:[NSString stringWithFormat:@"%@", [props[key] description]]] ;
            }
        }

        [outString appendFormat: @"\n;;; \n"] ;
    }
    
    self.contiguousClose = [[self class] headerBlankLines] ;
    return [self write: root toString: outString atLevel: 0 siblingIndex:0] ;
}

- (NSString *) trim: (NSMutableString *) s {
    NSCharacterSet * ws = [NSCharacterSet whitespaceAndNewlineCharacterSet] ;
    return [s stringByTrimmingCharactersInSet:ws] ;
}

- (BOOL) needsQuoting: (NSString *) text {
    NSCharacterSet * ws = [NSCharacterSet whitespaceAndNewlineCharacterSet] ;
    return [text rangeOfCharacterFromSet:ws options:0].location != NSNotFound ;
}

- (NSString *) format: (NSString *) text isNumber: (out BOOL *) isNumber {
    NSDictionary * props = [[self class] properties] ;
    NSString * fmt = nil ;
    if (props && [props count] && (fmt = props[SEXPIO_EXPORT_FLOATING_POINT_FORMAT])) {
        int count = (int) [text length] ;
        for (int i = 0 ; i < count ; ++i) {
            unichar c = [text characterAtIndex:i] ;
            // minus sign accepted only in head position
            if (c == '.' || (c == '-' && (i == 0)) || ((c >= '0') && (c <= '9'))) continue ;
            return text ;
        }
        // special case for when text is exactly "."
        if (count == 1 && [text characterAtIndex:0] == '.') {
            return text ;
        }
        // special case for when text is exactly "-"
        if (count == 1 && [text characterAtIndex:0] == '-') {
            return text ;
        }
        *isNumber = YES ;
        CGFloat threshold = [props[SEXPIO_EXPORT_INTEGER_FLOAT_THRESHOLD] floatValue] ;
        CGFloat value = [text floatValue] ;
        NSInteger intValue = (NSInteger) value ;
        CGFloat error = value - (CGFloat) intValue ;
        if (error < 0) error *= -1.0f ;
        if (error < threshold) {
            return [NSString stringWithFormat:@"%ld", (long)intValue] ;
        }
        NSString * s = [NSString stringWithFormat:fmt, value] ;
        // if s is of the form xyz.abc, kill off trailing zeroes
        NSArray * comps = [s componentsSeparatedByString:@"."] ;
        if ([comps count] > 1) {
            // we're looking at abc
            NSString * abc = comps[1] ;
            while ([abc length] > 1) {
                unichar c = [abc characterAtIndex:[abc length] -1] ;
                if (c == '0') {
                    abc = [abc substringToIndex:[abc length]-1] ;
                    continue ;
                }
                return s ;
            }
            NSMutableArray * ma = [comps mutableCopy ];
            ma[1] = abc ;
            return [ma componentsJoinedByString:@"."] ;
        }
        return s ;
    }
    return text ;
}

- (void) appendLineLevelCounter: (NSMutableString *) outString
                   siblingIndex: (NSInteger) siblingIndex {

    if (![self lineNumbers]) {
        return ;
    }
    if (siblingIndex == 0) {
        return ;
    }
    --siblingIndex ;
    NSRange SOL = [outString rangeOfString:@"\n" options:NSBackwardsSearch] ;
    NSInteger lineLength = [outString length] ;
    if (SOL.location != NSNotFound) {
        lineLength -= SOL.location ;
    }
    NSInteger columns = [self lineNumbersColumn] ;
    // we're going to append:";; xx", that is 5 characters. Make the line 80
    // characters if possible by appending enough spaces to reach 75
    if (lineLength < columns) {
        NSInteger spaces = columns - lineLength ;
        [outString appendFormat:@"%*s", (int) spaces, " "] ;
    }
    [outString appendFormat:@";; %ld", (long)siblingIndex] ;
}

- (NSString *) write: (SExp *) root
            toString: (NSMutableString *) outString
             atLevel: (NSInteger) level
        siblingIndex: (NSInteger) siblingIndex {

    NSInteger columns = [self lineNumbersColumn] ;

    if (self.contiguousClose > [[self class] paragraphBlankLines]) {
        [outString appendFormat: @"\n"] ; 
    } else {
        [self appendLineLevelCounter: outString siblingIndex:siblingIndex] ;
    }
    self.contiguousClose = 0 ;


    if (level) {
        [outString appendFormat: @"\n%*s(%@", (int) ([[self class] tabCount] * level), " ", root.token] ;
    } else {
        [outString appendFormat: @"\n(%@", root.token] ; 
    }

    NSMutableString * outs = [NSMutableString stringWithCapacity:100] ;

    if ([root.attributes count] == 1) {
        NSString * s = root.attributes[0] ;
        if ([self needsQuoting:s]) {
            [outString appendFormat:@" \"%@\"", s] ;
        } else {
            [outString appendFormat:@" %@", s] ;
        }
    } else if ([root.attributes count] > 1) {

        int index = -1 ;
        for (NSString * attr in root.attributes) {
            ++index ;
            BOOL isNumber = NO ;
            NSString * attrStr = [self format:[attr description] isNumber:&isNumber] ;

            if ([outs length] + [attrStr length] > columns) {
                NSString * s = [self trim:outs] ;
                if (level) {
                    [outString appendFormat: @"\n%*s %@", (int) ([[self class] tabCount] * level), " ", s] ;
                } else {
                    [outString appendFormat: @"\n%@", s] ;
                }
                outs = [NSMutableString stringWithCapacity:100] ;
            }

            if (isNumber || ![self needsQuoting:attr]) {
                [outs appendFormat:@" %@", attrStr] ;
            } else {
                [outs appendFormat:@" \"%@\"", attrStr] ;
            }
        }
    }

    if ([outs length]) {
        NSString * s = [self trim:outs] ;
        [outString appendFormat: @"\n%*s %@", (int) ([[self class] tabCount] * level), " ", s] ;
    }

    int sibIndex = -1 ;
    for (SExp * child in root.children) {
        ++sibIndex ;
        [self write: child toString: outString atLevel: 1+level siblingIndex: sibIndex] ;
    }
    
    [outString appendString: @")"] ;
    ++self.contiguousClose  ;

    return outString ;
}

- (void) dump: (SExp *) root {
    NSMutableString * logString = [NSMutableString stringWithCapacity: 256] ;
    NSLog(@"%@", [self write:root toString:logString]) ;
}

@end
