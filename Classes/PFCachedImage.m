//
//  PFCachedImage.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/21/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFCachedImage.h"


@interface PFCachedImage ()

-(UIImage *) getRealImage;

@end

@implementation PFCachedImage

@synthesize  timestamp;

-(void) dealloc 
{
    SafeRelease( path );
    SafeRelease( realImage );
    
    [super dealloc];
}

-(id) init 
{
    NSAssert( NO, @"Must use the initWithPath: method with a real path." );    
    return nil;
}

+(id) cachedImageWithPath: (NSString *) path
{
    if( ! [[NSFileManager defaultManager] fileExistsAtPath: path ] )
        return nil;
    
    return [[[PFCachedImage alloc] initWithPath: path] autorelease];
}

-(id) initWithPath: (NSString *) newPath
{
    NSAssert( newPath != nil, @"Cached images require a path" );

    if( ! [[NSFileManager defaultManager] fileExistsAtPath: newPath ] )
        return nil;
    
    if( self = [super init] )
    {
        path = [newPath copy];        
        timestamp = time( NULL );
    }
    
    return self;
}

-(oneway void) release
{
    int count = self.retainCount;
    
    [super release];

    // If we're down to only one retain count - held by the PFImageCache - then we can release
    // the real image
    if( count == 2 )
        [self trim];
    
}


-(UIImage *) getRealImage
{
    if( realImage == nil )
    {
        realImage = [[UIImage alloc] initWithContentsOfFile: path];
    }

    timestamp = time( NULL );

    return realImage;
}


-(UIImageOrientation) imageOrientation { return [self getRealImage].imageOrientation; }
-(CGImageRef) CGImage { return [self getRealImage].CGImage; }
-(NSInteger) leftCapWidth{ return [self getRealImage].leftCapWidth; }
-(CGFloat) scale{ return [self getRealImage].scale; }
-(CGSize) size{ return [self getRealImage].size; }
-(NSInteger) topCapHeight{ return [self getRealImage].topCapHeight; }


-(void) drawAtPoint: (CGPoint) point 
{
    [[self getRealImage] drawAtPoint: point];
}

-(void) drawAtPoint: (CGPoint) point blendMode: (CGBlendMode) blendMode alpha: (CGFloat) alpha
{
    [[self getRealImage] drawAtPoint: point blendMode: blendMode alpha: alpha];
}

-(void) drawInRect: (CGRect) rect
{
    [[self getRealImage] drawInRect: rect];
}

-(void) drawInRect: (CGRect) rect blendMode: (CGBlendMode) blendMode alpha: (CGFloat) alpha
{
    [[self getRealImage] drawInRect: rect blendMode: blendMode alpha: alpha];
}


-(void) trim
{
    SafeRelease( realImage );
}


@end
