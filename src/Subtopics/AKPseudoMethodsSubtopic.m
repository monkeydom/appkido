/*
 * AKPseudoMethodsSubtopic.m
 *
 * Created by Andy Lee on Tue Jun 22 2004.
 * Copyright (c) 2004 Andy Lee. All rights reserved.
 */

#import "AKPseudoMethodsSubtopic.h"

#import "DIGSLog.h"

#import "AKClassNode.h"
#import "AKMethodNode.h"
#import "AKMemberDoc.h"

@implementation AKPseudoMethodsSubtopic

#pragma mark -
#pragma mark Factory methods

+ (id)subtopicForClassNode:(AKClassNode *)classNode
    includeAncestors:(BOOL)includeAncestors
{
    return [[[self alloc] initWithClassNode:classNode
                           includeAncestors:includeAncestors] autorelease];
}

#pragma mark -
#pragma mark Init/awake/dealloc

- (id)initWithClassNode:(AKClassNode *)classNode
       includeAncestors:(BOOL)includeAncestors
{
    if ((self = [super initIncludingAncestors:includeAncestors]))
    {
        _classNode = [classNode retain];
    }

    return self;
}

- (id)initIncludingAncestors:(BOOL)includeAncestors
{
    DIGSLogError_NondesignatedInitializer();
    return nil;
}

- (void)dealloc
{
    [_classNode release];

    [super dealloc];
}

#pragma mark -
#pragma mark Getters and setters

- (AKClassNode *)classNode
{
    return _classNode;
}

#pragma mark -
#pragma mark AKMembersSubtopic methods

- (AKBehaviorNode *)behaviorNode
{
    return _classNode;
}

@end
