//
//  ViewController.m
//  RotateRugby
//
//  Created by Hoàng Thái on 3/18/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate> {
    UIImageView *photo;
    NSTimer *timer;
    CGFloat angle;
    BOOL checkGestureRecognizerDone;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    angle = 0;
    checkGestureRecognizerDone = false;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                             target:self 
                                           selector:@selector(onRotate) 
                                           userInfo:nil 
                                            repeats:true];
    
    photo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rugby.png"]];
    photo.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    photo.userInteractionEnabled = YES;
    photo.multipleTouchEnabled= YES;
    [self.view addSubview:photo];
    
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(rotateBall:)];
    [photo addGestureRecognizer:rotate];
}

- (void) onRotate {
    if (checkGestureRecognizerDone) {
        if (angle > 0.001) {
            angle -= 0.001;
            photo.transform = CGAffineTransformRotate(photo.transform, angle * M_PI);
            NSLog(@"angle = %3.1f", angle);
        }
        else if (angle < -0.001) {
            angle += 0.001;
            photo.transform = CGAffineTransformRotate(photo.transform, angle * M_PI);
            NSLog(@"angle = %3.1f", angle);
            
        }
        else{
            checkGestureRecognizerDone = false;
        }
    }
}

- (void) rotateBall: (UIRotationGestureRecognizer *) rotate {
    [self adjustAnchorPointForGestureRecognizer:rotate];
    if (rotate.state == UIGestureRecognizerStateChanged ||
        rotate.state == UIGestureRecognizerStateBegan) {
        photo.transform = CGAffineTransformRotate(photo.transform, rotate.rotation);
        rotate.rotation = 0.0;
        //        NSLog(@"%f", angle);
        NSLog(@"velocity = %f", rotate.velocity);
        NSLog(@"rotation = %f", rotate.rotation);
    }
    else if (rotate.state == UIGestureRecognizerStateEnded) {
        checkGestureRecognizerDone = true;
        if (rotate.velocity >= 10) {
            angle = 0.1;
        }
        else if (rotate.velocity <= 10) {
            angle = -0.1;
        }
        else {
            angle = 0.01 * rotate.velocity;
        }
        
    }
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

@end
