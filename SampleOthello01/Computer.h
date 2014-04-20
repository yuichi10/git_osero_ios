//
//  Computer.h
//  SampleOthello01
//
//  Created by YuichiSawada on 2014/02/16.
//  Copyright (c) 2014年 YuichiSawada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Computer : NSObject

- (void) StartComputerThink;
- (void) MakeFutureBorad:(int) placeX : (int) placeY : (int[][10]) borad : (int) playerFlag;
- (void) setComputer:(int) compter_turn : (int) player_turn;

@end
