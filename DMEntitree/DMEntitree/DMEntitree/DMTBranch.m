//
//  DMTBranch.m
//  DMEntitree
//
//  Created by Dana Craig Maher on 11/1/13.
/*
 Copyright (c) 2014 Dana Maher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/
//

#import "DMTBranch.h"
#import <QuartzCore/QuartzCore.h>

@interface DMTBranch()

- (void)drawSelf;

@end

@implementation DMTBranch

- (void)drawSelf
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    switch (_branchType) {
        case Branch_Connector:
        {
            
        }
            break;
        case Branch_LeftCap:
        {
            
        }
            break;
        default:
            break;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self refresh];
    }
    return self;
}

- (void)refresh
{
    [self setNeedsDisplay];
    
    [self drawSelf];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextClearRect(c, self.bounds);
    CGFloat color[4] = {7.0/255.0, 56.0/255.0, 151.0/255.0, 0.6f};
    CGContextSetStrokeColor(c, color);
    CGContextBeginPath(c);
    
    //basic type
    switch (_branchType) {
        case Branch_Connector:
        {
            CGContextMoveToPoint(c, 0, self.frame.size.height/2);
            CGContextAddLineToPoint(c, self.frame.size.width, self.frame.size.height/2);
            CGContextMoveToPoint(c, self.frame.size.width/2, self.frame.size.height);
            CGContextAddLineToPoint(c, self.frame.size.width/2, self.frame.size.height/2);
        }
            break;
        case Branch_LeftCap:
        {
            CGContextMoveToPoint(c, self.frame.size.width/2, self.frame.size.height);
            CGContextAddLineToPoint(c, self.frame.size.width/2, self.frame.size.height/2);
            CGContextAddLineToPoint(c, self.frame.size.width, self.frame.size.height/2);
        }
            break;
        case Branch_RightCap:
        {
            CGContextMoveToPoint(c, self.frame.size.width/2, self.frame.size.height);
            CGContextAddLineToPoint(c, self.frame.size.width/2, self.frame.size.height/2);
            CGContextAddLineToPoint(c, 0, self.frame.size.height/2);
        }
            break;
        case Branch_SingleDown:
        {
            CGContextMoveToPoint(c, self.frame.size.width/2, self.frame.size.height);
            CGContextAddLineToPoint(c, self.frame.size.width/2, 0);
            CGContextMoveToPoint(c, 0, self.frame.size.height/2);
            CGContextAddLineToPoint(c, self.frame.size.width, self.frame.size.height/2);
        }
            break;
        case Branch_SingleDown_LeftCap:
        {
            CGContextMoveToPoint(c, self.frame.size.width/2, self.frame.size.height);
            CGContextAddLineToPoint(c, self.frame.size.width/2, 0);
            CGContextMoveToPoint(c, self.frame.size.width/2, self.frame.size.height/2);
            CGContextAddLineToPoint(c, self.frame.size.width, self.frame.size.height/2);
        }
            break;
        case Branch_SingleDown_RightCap:
        {
            CGContextMoveToPoint(c, self.frame.size.width/2, self.frame.size.height);
            CGContextAddLineToPoint(c, self.frame.size.width/2, 0);
            CGContextMoveToPoint(c, self.frame.size.width/2, self.frame.size.height/2);
            CGContextAddLineToPoint(c, 0, self.frame.size.height/2);
        }
            break;
        default:
            break;
    }
    
    CGContextSetLineWidth(c, 5);
    CGContextSetLineCap(c, kCGLineCapRound);
    CGContextStrokePath(c);
}

@end
