//
//  SExp.h
//  __core_sources
//
//  Created by verec on 26/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface SExp : NSObject <NSCopying>

@property (nonatomic, strong) NSMutableArray * 	children ;
@property (nonatomic, strong) NSMutableArray * 	attributes ;
@property (nonatomic, strong) NSString *		token ;

// returns a new SExp with no token and no children
+ (instancetype) sexp ;

// returns a new SExp with specified token but no children
+ (instancetype) sexp: (NSString *) token ;

// returns a new new SExp with no token and no children, creating first a root
// SExp whose path to the returned SExp node is specifed by path. Uses the
// customary "sub1/sub2/ .../subn" path format specifier

+ (instancetype) sexp: (NSString *) path root: (SExp **) root ;

- (NSString *) description ;

- (instancetype) objectForKeyedSubscript: (id <NSCopying>)key ;


@end

@interface SExp (Attributes)

- (SExp *) add: (SExp *) child ;

- (SExp *) addAttribute: (NSString *) attribute ;
- (SExp *) setAttribute: (NSString *) attribute index: (NSInteger) index ;

- (BOOL) attribute: (NSString **) value ;
- (BOOL) attribute: (NSString **) value at: (NSUInteger) index ;

- (NSString *) firstAttribute ;

@end

@interface SExp (Creation)

- (SExp *) ensurenode: (NSString *) path ;

@end

@interface SExp (Navigation)

- (BOOL) matches: (NSString *) target ;

// if path can point to at most one node returns it, or nil if no such node.
- (SExp *) subnode: (NSString *) path ;

// if path can point to more than one node at the final level, then sibling
// is the index of the desired node, or nil if no such node exists.
- (SExp *) subnode: (NSString *) path
           sibling: (NSUInteger) sibling ;
@end

@interface SExp (Iteration)
// Iterates over all children, calling `block'
- (void) each: (void (^)(SExp * child)) block ;

// Iterates over all children, path away from self, calling `block', `path'
// away from self. Uses the customary "sub1/sub2/ .../subn" path format specifier
- (void) each: (NSString *) path block:(void (^)(SExp *)) block ;

@end

@interface SExp (Deprecated)

- (BOOL) stringValue: (NSString **) value ;
- (BOOL) stringValue: (NSString **) value at: (NSUInteger) index ;

- (SExp *) addIntAttribute:     (int)           attribute ;
- (SExp *) addFloatAttribute:   (float)         attribute ;
- (SExp *) addBoolAttribute:    (BOOL)          attribute ;
- (SExp *) addCGPointAttribute: (CGPoint)       attribute ;

- (SExp *) addDateAttribute:    (NSDate *)      attribute ;
- (BOOL) dateValue: (NSDate **) value ;
- (BOOL) dateValue: (NSDate **) value at: (NSUInteger) index ;

- (BOOL) unicharValue: (unichar *) value ;
- (BOOL) unicharValue: (unichar *) value at: (NSUInteger) index ;
- (BOOL) intValue: (int *) value ;
- (BOOL) intValue: (int *) value at: (NSUInteger) index ;
- (BOOL) CGFloatValue: (CGFloat *) value ;
- (BOOL) CGFloatValue: (CGFloat *) value at: (NSUInteger) index ;
- (BOOL) boolValue: (BOOL *) value ;
- (BOOL) boolValue: (BOOL *) value at: (NSUInteger) index ;

- (BOOL) CGPointValue: (CGPoint *) value ;
- (BOOL) CGPointValue: (CGPoint *) value at: (NSUInteger) index ;

@end