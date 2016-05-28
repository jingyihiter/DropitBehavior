//
//  ViewController.m
//  Dropit
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 马晶义. All rights reserved.
//

#import "ViewController.h"
#import "dropbehavior.h"
@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property(strong,nonatomic) UIDynamicAnimator *animator;
@property(strong,nonatomic)dropbehavior *dropitBehavior;
@end

@implementation ViewController

static const CGSize DROP_SIZE = {40, 40};

- (UIDynamicAnimator *)animator{
    if(!_animator){
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return  _animator;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    [self removeComleteRows];
}

- (BOOL)removeComleteRows{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc]init];
    for (CGFloat y = self.gameView.bounds.size.height-DROP_SIZE.height/2;y>0;y-=DROP_SIZE.height)
    {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc]init];
        for(CGFloat x =DROP_SIZE.width/2;x<=self.gameView.bounds.size.width-DROP_SIZE.width/2;x+=DROP_SIZE.width)
        {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if([hitView superview] == self.gameView){
                [dropsFound addObject:hitView];
            }
            else{
                rowIsComplete = NO;
                break;
            }
        }
        if(![dropsFound count]) break;
        if(rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    if([dropsToRemove count]){
        for(UIView *drop in dropsToRemove){
            [self.dropitBehavior removeItem:drop];
        }
        [self animatorRemovingDrops:dropsToRemove];
    }
    return  NO;
}
-(void)animatorRemovingDrops:(NSArray *)dropsToRemove{
    [UIView animateWithDuration:1.0 animations:^{
        for(UIView *drop in dropsToRemove){
            int x = (arc4random()%(int)(self.gameView.bounds.size.width*5))-(int)self.gameView.bounds.size.width*2;
            int y = self.gameView.bounds.size.height;
            drop.center = CGPointMake(x, -y);
        }
    }completion:^(BOOL finished) {
        [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

-(dropbehavior *)dropitBehavior{
    if(!_dropitBehavior){
        _dropitBehavior =[[dropbehavior alloc]init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (void)drop{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.gameView.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    UIView *dropView = [[UIView alloc]initWithFrame:frame];
    dropView.backgroundColor=[self randomColor];
    [self.gameView addSubview:dropView];
    
    [self.dropitBehavior addItem:dropView];
    
    
}
- (UIColor *)randomColor{
    switch (arc4random()%5) {
        case 0:
            return [UIColor greenColor];
        case 1:
            return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return  [UIColor blackColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
