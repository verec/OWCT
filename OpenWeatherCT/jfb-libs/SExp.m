//
//  SExp.mm
//  __core_sources
//
//  Created by verec on 26/06/2010.
//  Copyright 2010 Jean-François Brouillet. All rights reserved.
//

#import "SExp.h"
#import "SExpIO.h"

@implementation SExp

- (id) copyWithZone: (NSZone *) zone {
    return self ;
}

//- (void) dealloc {
//    DDLogInfo(@"%@ going away", self.token) ;
//}
//

#pragma mark - Private
#pragma mark -

- (id) init  {
    if (self = [super init]) {
        self.children = [NSMutableArray arrayWithCapacity:5] ;
        self.attributes = [NSMutableArray arrayWithCapacity:1] ;
        self.token = nil ;
    }
    return self ;
}

#ifdef TRACE_DEALLOC
- (void) dealloc {
    ::NSLog(@"SExp \"%@\"%p going away", self.token, self) ;
}
#endif

#pragma mark - Creation & Life Cycle
#pragma mark -

- (NSString *) description {
    [SExpIO properties][@"author"] = @"JFB" ;
    [SExpIO properties][SEXPIO_EXPORT_LINE_NUMBERS] = @NO ;
    NSString * description = [[NSString alloc] initWithData: [SExpIO encode:self]
                                                   encoding: NSUTF8StringEncoding] ;
    [SExpIO properties][@"author"] = @"" ;
    return description ;
}

- (NSString *) debugDescription {
    return [super debugDescription] ;
}

- (instancetype) objectForKeyedSubscript: (id <NSCopying>)key {
    return [self subnode:(NSString *) key] ;
}

- (NSString *) firstAttribute {
    NSString * attr = nil ;
    if ([self attribute:&attr]) {
        return attr ;
    }
    return nil ;
}

+ (instancetype) sexp  {
    return [[SExp alloc] init] ;
}

+ (instancetype) sexp: (NSString *) token  {
    SExp * e = [SExp sexp] ;
    e.token = token ;
    return e ;
}

- (SExp *) add: (SExp *) child {
    [self.children addObject:child] ;
    return self ;
}

- (SExp *) ensurenode: (NSString *) path {
    NSArray * comps = [path componentsSeparatedByString:@"/"] ;
    if (comps == nil || [comps count] == 0 || [comps[0] length] == 0) {
        return self ;
    }
    __block SExp * node = nil ;
    [self each:^(SExp *child) {
        if ([child.token isEqualToString:comps[0]]) {
            node = child ;
        }
    }] ;
    
    if (node == nil) {
        [self.children addObject:node=[SExp sexp: comps[0]]] ;
    }

    if ([comps count] == 1) {
        return node ;
    } else {
        return [node ensurenode:[[comps subarrayWithRange:(NSRange) {1, [comps count]-1} ] componentsJoinedByString:@"/"]] ;
    }
}

+ (id) sexp: (NSString *) path root: (SExp * __autoreleasing *) root_ {
    
    NSArray * comps = [path componentsSeparatedByString:@"/"] ;
    
    SExp * root = nil ;
    SExp * node = nil ;

    for (NSString * s in comps) {
        SExp * e = [SExp sexp:s] ;
        if (node != nil) {
            [node.children addObject:e] ;
        } else {
            root = e ;
        }
        node = e ;
    }
    
    *root_ = root ;
    return node ;    
}

#pragma mark - Attributes
#pragma mark -

- (SExp *) addAttribute: (NSString *) attribute {
    [self.attributes addObject:attribute ? attribute : @""] ;
    return self ;
}

- (SExp *) setAttribute: (NSString *) attribute index: (NSInteger) index {
    while ([self.attributes count] <= index) {
        [self.attributes addObject: @""] ;
    }
    self.attributes[index] = attribute ? attribute : @"" ;
    return self ;
}

- (SExp *) addIntAttribute: (int) attribute {
    [self.attributes addObject:[NSString stringWithFormat: @"%d", attribute]] ;   
    return self ;
}
     
- (SExp *) addFloatAttribute: (float) attribute {
    [self.attributes addObject:[NSString stringWithFormat: @"%f", attribute]] ;
    return self ;
}
  
- (SExp *) addBoolAttribute: (BOOL) attribute {
    [self.attributes addObject:attribute ? @"true" : @"false"] ;
    return self ;
}

- (SExp *) addCGPointAttribute: (CGPoint) attribute {
    [self addFloatAttribute:attribute.x] ;
    return [self addFloatAttribute:attribute.y] ;
}

- (BOOL) attribute: (NSString * __autoreleasing *) value {
    return [self stringValue:value at:0] ;
}

- (BOOL) attribute: (NSString * __autoreleasing *) value at: (NSUInteger) index {
    return [self stringValue:value at:index] ;
}

- (BOOL) stringValue: (NSString * __autoreleasing *) value {
    return [self stringValue:value at:0] ;
}

- (BOOL) stringValue: (NSString * __autoreleasing *) value at: (NSUInteger) index {
    if (self.attributes && [self.attributes count] > index) {
        *value = (self.attributes)[index] ;
        return YES ;
    }
    return NO ;
}

- (BOOL) intValue: (int *) value {
    return [self intValue:value at:0] ;
}

- (BOOL) intValue: (int *) value at: (NSUInteger) index {
    NSString * r = nil ;
    if ([self stringValue:&r at:index]) {
        *value = [r intValue] ;
        return YES ;
    }
    return NO ;
}

- (BOOL) unicharValue: (unichar *) value {
    return [self unicharValue:value at:0] ;
}

- (BOOL) unicharValue: (unichar *) value at: (NSUInteger) index {
    NSString * r = nil ;
    if ([self stringValue:&r at:index]) {
        *value = [r characterAtIndex:0] ;
        return YES ;
    }
    return NO ;
}


- (BOOL) CGFloatValue: (CGFloat *) value {
    return [self CGFloatValue:value at:0] ;
}

- (BOOL) CGFloatValue: (CGFloat *) value at: (NSUInteger) index {
    NSString * r = nil ;
    if ([self stringValue:&r at:index]) {
        *value = (CGFloat) [r floatValue] ;
        return YES ;
    }
    return NO ;
}

- (BOOL) boolValue: (BOOL *) value {
    return [self boolValue: value at: 0] ;
}

- (BOOL) boolValue: (BOOL *) value at: (NSUInteger) index {
    NSString * r = nil ;
    if ([self stringValue:&r at:index]) {
        if (r && [r length]) {
            unichar c = [r characterAtIndex:0] ;
            switch (c) {
                case 't':
                case 'T':
                case 'y':
                case 'Y':
                case '1':
                    *value = YES ;
                    return YES ;
                default: ;
                    *value = NO ;
                    return YES ;
            }
        }
    }
    
    return NO ;    
}

- (BOOL) CGPointValue: (CGPoint *) value {
    return [self CGPointValue:value at:0] ;
}

- (BOOL) CGPointValue: (CGPoint *) value at: (NSUInteger) index {
    CGFloat x = nanf("") ;
    CGFloat y = nanf("") ;

    if ([self CGFloatValue:&x at:index+0]
    &&  [self CGFloatValue:&y at:index+1]) {
        value->x = x ;
        value->y = y ;
        return YES ;
    }

    return NO ;
}

#pragma mark - Navigation
#pragma mark -

- (BOOL) matches: (NSString *) target {
    return [self.token isEqualToString:target] ;
}

/* @what    Locates and returns the node at the corresponding path in the
 *          hierarchy or nil if no such node exists.
 * @why     This provides direct, drilling like access to any node accessible
 *          from self.
 * @how     Uses subnode:path:sibling: with a sibling value of 0
 */
- (SExp *) subnode: (NSString *) path {
    return [self subnode:path sibling:0] ;
}

- (SExp *) subnode: (NSString *) path
          sibling: (NSUInteger) sibling {
    
    NSArray * pathComponents = [path componentsSeparatedByString:@"/"] ;
    
    NSEnumerator * enumerator = [pathComponents objectEnumerator] ;
    NSString * firstPathElement = [enumerator nextObject] ;
    
    return [self subnode: firstPathElement 
              enumerator: enumerator
                 sibling: sibling] ;
}

- (SExp *) subnode: (NSString *) sought
        enumerator: (NSEnumerator *) enumerator
           sibling: (NSUInteger) sibling {
    
    if (sought == nil) return nil ;

    NSArray * kids = self.children ;
    
    if (kids == nil) return nil ;
    
    NSString * nextPathElement = [enumerator nextObject] ;
    
    int sibIndex = -1 ;
    for (SExp * child in kids) {
        if ([sought compare:child.token] == NSOrderedSame) {
            if (nextPathElement) {
                return [child subnode: nextPathElement
                           enumerator: enumerator
                              sibling: sibling] ;
            } else if (++sibIndex == sibling) {
                // we're done
                return child ;
            }            
        }
    }
    
    return nil ;
}

#pragma mark - Iteration
#pragma mark -

/* @what    Iterates over children, calling `block` on each.
 * @why     Hubris. Looked cool to show how learnt I am by providing external
 *          iterators even though the children member is already fully
 *          exposed. Also a way to slow down things as `fast iteration` was
 *          really too fast.
 * @how     The mundane way.
 */
- (void) each: (void (^)(SExp * child)) block {
    for (SExp * e in [self.children copy]) {
        block(e) ;
    }
}

- (void) each: (NSString *) path
        block: (void (^)(SExp *)) block {

    int sibling = -1 ;

    while (YES) {

        ++sibling ;

        SExp * e = [self subnode:path sibling:sibling] ;

        if (e) {
            [e each:block] ;
        } else {
            return ;
        }
    }
}

#pragma mark - Deprecated
#pragma mark -

- (NSDateFormatter *) dateFormatter {
    static NSDateFormatter * formatter = nil ;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyyMMdd"] ;
    }
    return formatter ;
}

- (SExp *) addDateAttribute: (NSDate *) attribute {
    [self.attributes addObject:[[self dateFormatter] stringFromDate:attribute]] ;
    return self ;
}

- (BOOL) dateValue: (NSDate * __autoreleasing *) value {
    return [self dateValue:value at:0] ;
}

- (BOOL) dateValue: (NSDate * __autoreleasing *) value at: (NSUInteger) index {
    NSString * r = nil ;
    if ([self stringValue:&r at:index]) {
        *value = [[self dateFormatter] dateFromString:r] ;
        return YES ;
    }
    return NO ;
}

@end
