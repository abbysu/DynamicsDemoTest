
//  FirstViewController.m
//  DynamicsDemo
//
//  Created by Changsu Dong on 11/18/15.
//  Copyright © 2015 Changsu Dong. All rights reserved.
//

#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>//;


@interface FirstViewController ()


@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) UIView *orangeBall;


-(void)demoGravity;

-(void)playWithBall;


@end


@implementation FirstViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
  //set up ball view.
    self.orangeBall = [[UIView alloc] initWithFrame:CGRectMake(300.0, 100.0, 50.0, 50.0)];
    self.orangeBall.backgroundColor = [UIColor orangeColor];
    self.orangeBall.layer.cornerRadius = 25.0;
    self.orangeBall.layer.borderColor = [UIColor blackColor].CGColor;
    self.orangeBall.layer.borderWidth = 0.0;
    [self.view addSubview:self.orangeBall];
    
    //initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    [self demoGravity];
    
    [self playWithBall];
    

}

-(void)demoGravity{
    
    //add the gravity to the ball so the ball'd fall.
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.orangeBall]];
    
    [self.animator addBehavior:gravityBehavior];
    
    
    gravityBehavior.action = ^{
        NSLog(@"%f", self.orangeBall.center.y);
        
    };
    
    //stop the ball from getting lost by adding collision
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall]];
    [collisionBehavior addBoundaryWithIdentifier:@"tabbar"
                                        fromPoint:self.tabBarController.tabBar.frame.origin
                                         toPoint:CGPointMake(self.tabBarController.tabBar.frame.origin.x + self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.origin.y)];
    
    [self.animator addBehavior:collisionBehavior];
    
    //let the ball bounce. adding the elasticity
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.orangeBall]];
    ballBehavior.elasticity = 0.9;
    
    //add the resistance and friction(0.0-1.0).
    ballBehavior.resistance = 0.0;
    ballBehavior.friction = 0.0;
    ballBehavior.allowsRotation = NO;
    
    [self.animator addBehavior:ballBehavior];

    [self.animator addBehavior:collisionBehavior];
    collisionBehavior.collisionDelegate = self;
  
    
}


-(void)playWithBall{
    
    //make 3 obstacle bars.
    UIView *obstacle1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 5, 550, 50, 20.0)];
    obstacle1.backgroundColor = [UIColor blueColor];
    
    UIView *obstacle2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 120, 350.0, 150.0, 20.0)];
    obstacle2.backgroundColor = [UIColor redColor];
    
    UIView *obstacle3 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75, 420, 250.0, 20.0)];
    obstacle3.backgroundColor = [UIColor orangeColor];
    
    
    [self.view addSubview:obstacle1];
    [self.view addSubview:obstacle2];
    [self.view addSubview:obstacle3];
    
    
    //create a collision behavior object and add it to the animator
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall, obstacle1, obstacle2, obstacle3]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    
    [collisionBehavior addBoundaryWithIdentifier:@"tabbar"
                                       fromPoint:self.tabBarController.tabBar.frame.origin
                                         toPoint:CGPointMake(self.tabBarController.tabBar.frame.origin.x + self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.origin.y)];
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    
    
    //addes more density to the objects to make them "extra-heavy".
    UIDynamicItemBehavior *obstacles1and2Behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[obstacle1, obstacle2]];
    obstacles1and2Behavior.allowsRotation = NO;
    obstacles1and2Behavior.density = 100000.0;
    [self.animator addBehavior:obstacles1and2Behavior];
    
    //make the object do exact the oppsite of the 1&2.
    UIDynamicItemBehavior *obstacle3Behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[obstacle3]];
    obstacle3Behavior.allowsRotation = YES;
    [self.animator addBehavior:obstacle3Behavior];
    

}


//change the ball color when the ball hit the boundary.
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item withBoundaryIdentifier:(id)identifier atPoint:(CGPoint)p{
    
    self.orangeBall.backgroundColor = [UIColor blueColor];
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id)item withBoundaryIdentifier:(id)identifier{
    
    self.orangeBall.backgroundColor = [UIColor orangeColor];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


