/*
 * AKInstanceMethodDoc.m
 *
 * Created by Andy Lee on Sun Mar 21 2004.
 * Copyright (c) 2003, 2004 Andy Lee. All rights reserved.
 */

#import "AKInstanceMethodDoc.h"

@implementation AKInstanceMethodDoc

#pragma mark -
#pragma mark AKMemberDoc methods

+ (NSString *)punctuateNodeName:(NSString *)methodName
{
    return [@"-" stringByAppendingString:methodName];
}

@end
