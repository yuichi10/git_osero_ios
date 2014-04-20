//
//  BoradView.h
//  SampleOthello01
//
//  Created by YuichiSawada on 2014/02/12.
//  Copyright (c) 2014年 YuichiSawada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoradView : UIView
     <UIAlertViewDelegate>
- (void)setPlayerTurn:(int)playerturn;
+ (BoradView *)sharedManager;

- (int)getBoradPiece:(int) x : (int)y;
- (bool) UpdatePiece;
- (bool) ComUpdatePiece:(int) pointx :(int) pointy;
- (void)setTurnToPlayerturn;
@end
