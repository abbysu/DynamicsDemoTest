
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

@property (nonatomic) BOOL isBallRolling; //this indicate the ball is rolling or not.

@property (nonatomic, strong) UIView *paddle; //it can be visible privately to the class & it's going to be used more than one methods.

@property (nonatomic) CGPoint paddleCenterPoint; //be used to store the initial paddle center point.

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
    
    //[self demoGravity];
    
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
    ballBehavior.elasticity = 0.5;
    
    //add the resistance and friction(0.0-1.0).
    ballBehavior.resistance = 0.0;
    ballBehavior.friction = 0.5;
    ballBehavior.allowsRotation = NO;
    
    [self.animator addBehavior:ballBehavior];

    [self.animator addBehavior:collisionBehavior];
    collisionBehavior.collisionDelegate = self;
  
    
}



-(void)playWithBall{
    
    //make 3 obstacle bars.
    UIView *obstacle1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 200, 550, 100, 20.0)];
    obstacle1.backgroundColor = [UIColor blueColor];
    
    UIView *obstacle2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 120, 350.0, 150.0, 20.0)];
    obstacle2.backgroundColor = [UIColor redColor];
    
    UIView *obstacle3 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 420, 250.0, 20.0)];
    obstacle3.backgroundColor = [UIColor orangeColor];
    
    
    [self.view addSubview:obstacle1];
    [self.view addSubview:obstacle2];
    [self.view addSubview:obstacle3];
    
    
    //add the paddle to the screen to play the ball.
    self.paddle = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75,
                                                           self.tabBarController.tabBar.frame.origin.y - 35.0,
                                                           150.0, 30.0)];
    
    self.paddle.backgroundColor = [UIColor greenColor];
    self.paddle.layer.cornerRadius = 15.0;
    self.paddleCenterPoint = self.paddle.center;
    [self.view addSubview:self.paddle];
    
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.orangeBall]];
    [self.animator addBehavior:gravityBehavior];

    
    
    //create a collision behavior object and add it to the animator. added the paddle later to the initWithItem
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall, self. paddle, obstacle1, obstacle2, obstacle3]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    
    [collisionBehavior addBoundaryWithIdentifier:@"tabbar"
                                       fromPoint:self.tabBarController.tabBar.frame.origin
                                         toPoint:CGPointMake(self.tabBarController.tabBar.frame.origin.x + self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.origin.y)];
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    
    //let the ball bounce. adding the elasticity
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.orangeBall]];
    ballBehavior.elasticity = 0.5;
    
    //add the resistance and friction(0.0-1.0).
    ballBehavior.resistance = 0.0;
    ballBehavior.friction = 0.5;
    ballBehavior.allowsRotation = NO;
    
    [self.animator addBehavior:ballBehavior];
    
    
    //addes more density to the objects to make them "extra-heavy".
    UIDynamicItemBehavior *obstacles1and2Behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[obstacle1, obstacle2]];
    obstacles1and2Behavior.allowsRotation = NO;
    obstacles1and2Behavior.density = 100000.0;
    [self.animator addBehavior:obstacles1and2Behavior];
    
    //make the object do exact the oppsite of the 1&2.
    UIDynamicItemBehavior *obstacle3Behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[obstacle3]];
    obstacle3Behavior.allowsRotation = YES;
    [self.animator addBehavior:obstacle3Behavior];
    
    
    //disable the movement of the green paddle & no rotation.
    UIDynamicItemBehavior *paddleBehahavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddle]];
    paddleBehahavior.allowsRotation = NO;
    paddleBehahavior.density = 100000.0;
    [self.animator addBehavior:paddleBehahavior];

}

//the push behavior when a touch occurs on the screen.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (!self.isBallRolling) {
        
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.orangeBall] mode:UIPushBehaviorModeInstantaneous];
        pushBehavior.magnitude = 1.5;
        [self.animator addBehavior:pushBehavior];
        
        self.isBallRolling = YES;
        
    }
}

//to move the paddles around.
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    CGFloat yPoint = self.paddleCenterPoint.y;
    CGPoint paddleCenter = CGPointMake(touchLocation.x, yPoint);
    
    self.paddle.center = paddleCenter;
    [self.animator updateItemUsingCurrentState:self.paddle];
    
}


//delegate method that is called when two dynamics items collide (ball & paddle)
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item1 withItem:(id)item2 atPoint:(CGPoint)p{
    
    if (item1 == self.orangeBall && item2 == self.paddle) {
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.orangeBall] mode:UIPushBehaviorModeInstantaneous];
        pushBehavior.angle = 0.0;
        pushBehavior.magnitude = 0.75;
        [self.animator addBehavior:pushBehavior];
        
    }
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


