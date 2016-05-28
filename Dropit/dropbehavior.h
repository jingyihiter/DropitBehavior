//
//  dropbehavior.h
//  Dropit
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 马晶义. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dropbehavior : UIDynamicBehavior
- (void)addItem:(id<UIDynamicItem>)item;

- (void)removeItem:(id<UIDynamicItem>)item;

@end
