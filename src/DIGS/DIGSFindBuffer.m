/*
 * DIGSFindBuffer.m
 *
 * Created by Andy Lee on Sat May 17 2003.
 * Copyright (c) 2003, 2004 Andy Lee. All rights reserved.
 */

#import "DIGSFindBuffer.h"

@interface DIGSFindBuffer ()
@property (nonatomic, copy) NSString *realFindString;  // Setter is called by setFindString:.
@end

@implementation DIGSFindBuffer

#pragma mark -
#pragma mark Factory methods

@dynamic findString;
@synthesize realFindString = _findString;

+ (DIGSFindBuffer *)sharedInstance
{
    static DIGSFindBuffer *s_sharedInstance = nil;
    
    if (!s_sharedInstance)
    {
        s_sharedInstance = [[self alloc] init];
    }

    return s_sharedInstance;
}

#pragma mark -
#pragma mark Init/awake/dealloc

- (id)init
{
    if ((self = [super init]))
    {
        _findString = @"";
        _delegatePointerValues = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_handleAppDidActivateNotification:)
                                                     name:NSApplicationDidBecomeActiveNotification
                                                   object:NSApp];
        [self _loadFindStringFromPasteboard];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_findString release];
    [_delegatePointerValues release];

    [super dealloc];
}

#pragma mark -
#pragma mark Getters and setters

- (NSString *)findString
{
    return _findString;
}

- (void)setFindString:(NSString *)string
{
    if (string == nil)
    {
        string = @"";
    }
    [self _setFindString:string writeToPasteboard:YES];
}

#pragma mark -
#pragma mark Delegates

- (void)addDelegate:(id <DIGSFindBufferDelegate>)delegate;
{
    NSValue *pointerHolder = [NSValue valueWithNonretainedObject:delegate];
    NSUInteger delegateIndex = [_delegatePointerValues indexOfObject:pointerHolder];

    if (delegateIndex == NSNotFound)
    {
        [_delegatePointerValues addObject:pointerHolder];
    }
}

- (void)removeDelegate:(id <DIGSFindBufferDelegate>)delegate;
{
    NSValue *pointerHolder = [NSValue valueWithNonretainedObject:delegate];
    NSUInteger delegateIndex = [_delegatePointerValues indexOfObject:pointerHolder];

    if (delegateIndex != NSNotFound)
    {
        [_delegatePointerValues removeObjectAtIndex:delegateIndex];
    }
}

#pragma mark -
#pragma mark Private methods

- (void)_setFindString:(NSString *)string writeToPasteboard:(BOOL)flag
{
    if ([string isEqualToString:_findString])
    {
        return;
    }

    [self setRealFindString:string];

    if (flag)
    {
        [self _writeFindStringToPasteboard];
    }

    [self _notifyDelegatesBufferDidChange];
}

- (void)_loadFindStringFromPasteboard
{
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSFindPboard];

    if ([[pasteboard types] containsObject:NSStringPboardType])
    {
        NSString *string = [pasteboard stringForType:NSStringPboardType];

        if ([string length])
        {
            [self _setFindString:string writeToPasteboard:NO];
        }
    }
}

- (void)_writeFindStringToPasteboard
{
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSFindPboard];

    [pasteboard declareTypes:@[NSStringPboardType] owner:nil];
    [pasteboard setString:[self findString] forType:NSStringPboardType];
}

- (void)_handleAppDidActivateNotification:(NSNotification *)notif
{
    NSString *oldFindString = _findString;

    [self _loadFindStringFromPasteboard];
    if (![_findString isEqualToString:oldFindString])
    {
        [self _notifyDelegatesBufferDidChange];
    }
}

- (void)_notifyDelegatesBufferDidChange
{
    for (NSValue *pointerHolder in _delegatePointerValues)
    {
        id <DIGSFindBufferDelegate> delegate = [pointerHolder nonretainedObjectValue];

        [delegate findBufferDidChange:self];
    }
}

@end
