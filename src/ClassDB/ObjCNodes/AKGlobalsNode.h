/*
 * AKGlobalsNode.h
 *
 * Created by Andy Lee on Sun Mar 28 2004.
 * Copyright (c) 2003, 2004 Andy Lee. All rights reserved.
 */

#import "AKDatabaseNode.h"

/*!
 * Represents a collection of global identifiers such as enums, constant names,
 * global variable names, and typedefs. For example, the node name might be the
 * name of a typedef'ed enumeration, and the names it contains might be the
 * names of the enums. The owned identifiers are not themselves database nodes;
 * they're just strings.
 */
@interface AKGlobalsNode : AKDatabaseNode
{
@private
    // Elements are strings.
    NSMutableArray *_namesOfGlobals;
}

#pragma mark -
#pragma mark Getters and setters

- (void)addNameOfGlobal:(NSString *)nameOfGlobal;

- (NSArray *)namesOfGlobals;

@end
