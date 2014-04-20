//
//  BoradView.m
//  SampleOthello01
//
//  Created by YuichiSawada on 2014/02/12.
//  Copyright (c) 2014年 YuichiSawada. All rights reserved.
//

#import "BoradView.h"
#import "Computer.h"
#import "ViewController.h"

@implementation BoradView
{
    NSString *black[3];
    NSString *white[3];
    NSString *side[2];
    NSTimer *timer_;
    Computer *computer;
    int placeX, placeY;
    int PLACEX,PLACEY;
    int turn;                   //今０の番か１の番かの記憶
    int playerTurn;             //プレイヤーの順番を記憶
    int computerTurn;
    int PieceOthello[10][10];
    int extinctFlag;
    int finishFlag;
    int playerPutFlag;
    int eachPutFlag;
    
    //const
    int WALL;
	int EMPTY;
    int FIRST;
	int SECOND;
	int FINISH_FLAG;
	int PASS_FLAG;
    int DoPut;
}

static BoradView *boradview_ = nil;

+ (BoradView *)sharedManager{
    if (!boradview_) {
        boradview_ = [BoradView new];
    }
    return boradview_;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        placeX = -20;
        placeY = -20;
        turn = 0;
         [self setGamePrepare];
    }
    return self;
}

- (int)getBoradPiece: (int) x : (int)y
{
    return PieceOthello[y][x];
}

- (void)setGamePrepare
{
    WALL = -99;
    EMPTY = -1;
    FIRST = 0;
    SECOND = 1;
    FINISH_FLAG = -1;
    PASS_FLAG = 1;
    DoPut = 0;
    eachPutFlag = 0;
    black[0] = @"Black";
    white[0] = @"White";
    black[1] = [NSString stringWithFormat:@"%d",placeX];
    white[1] = [NSString stringWithFormat:@"%d",placeY];
    black[2] = @"PlayerTurn";
    white[2] = @"A16";
    side[0] = @"Territory";
    side[1] = @"Turn";
    //ボードの状態を整える
    [self setStartPiece];
    turn = FIRST;
}

- (void)setPlayerTurn:(int)playerturn
{
    playerTurn = playerturn;
    computerTurn = (playerTurn == FIRST) ? SECOND : FIRST;
    computer = [[Computer alloc] init];
    [computer setComputer:computerTurn : playerTurn];
    if(computerTurn == FIRST){
        [computer StartComputerThink];
        turn = playerTurn;
    }

}

- (void)setTurnToPlayerturn
{
    turn = playerTurn;
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    placeX = p.x;
    placeY = p.y;
    for(int i=1;i<9;i++){
        for(int j=1;j<9;j++){
            if(placeX>35*(j-1)+20 && placeX<35*j+20 && placeY>35*(i-1)+180 && placeY<35*i+180){
                placeX = j;
                placeY = i;
                PLACEX = placeX;
                PLACEY = placeY;
                black[2] = [NSString stringWithFormat:@"%d",i];
                white[2] = [NSString stringWithFormat:@"%d",j];
            }
        }
    }
    if(turn == playerTurn){
        if([self UpdatePiece]){
            turn = computerTurn;
        }
    }
    /*
    if([self UpdatePiece] == true){
        if(turn == playerTurn){
       //////////////////Computer//////////////
            turn = computerTurn;
            next = [self SerchNext];
            if(next == FINISH_FLAG){
                [self getResult];
            }else if(next == PASS_FLAG){
                black[2] = [NSString stringWithFormat:@"Comパス"];
            }else{
                [computer StartComputerThink];
                turn = playerTurn;
            }
        ////////////////////////////////////
        ///////////////////Player/////////////
            if(turn == playerTurn){
            while(1){
                next = [self SerchNext];
                    if(next == FINISH_FLAG){
                        [self getResult];
                        break;
                    }else if(next == PASS_FLAG){
                        white[2] = [NSString stringWithFormat:@"Perパス"];
                        [computer StartComputerThink];
                        [self setNeedsDisplay];
                        turn = playerTurn;
                    }else {
                        eachPutFlag = 0;
                        break;
                    }
                }
            }
        }
        [self setNeedsDisplay];
    }
     */
    [self setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *)event
{
    int next;
    if(turn == computerTurn){
        next = [self SerchNext];
        if(next == FINISH_FLAG){
            [self getResult];
        }else if(next == PASS_FLAG){
            black[2] = [NSString stringWithFormat:@"Comパス"];
            turn = playerTurn;
        }else{
            eachPutFlag = 0;
            [self computerPut];
            turn = playerTurn;
        }
    }
    if(turn == playerTurn){
        while((next = [self SerchNext]) == PASS_FLAG){
            black[1] = [NSString stringWithFormat:@"Playパス"];
            [self computerPut];
        }
        if(next == FINISH_FLAG){
            [self getResult];
        }
    }
}

- (void)computerPut
{
    sleep(3);
    [computer StartComputerThink];
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    [self drawBorad];
}

- (void) setStartPiece
{
	for(int i=0;i<10;i++){
		for(int j=0;j<10;j++){
			if(i == 0 || i == 9 || j == 0 || j == 9){
				PieceOthello[i][j] = -99;
			}else if((i == 4 && j==4) || (i==5 && j==5)){
				PieceOthello[i][j] = 1;
			}else if ((i == 4 && j==5) || (i==5 && j==4)){
				PieceOthello[i][j] = 0;
			}else {
				PieceOthello[i][j] = -1;
			}
		}
	}
}

- (void) drawBorad
{
    
    
    NSString *num[8];
    NSString *eng[8];
/*
    for(int i=1;i<9;i++){
        for(int j=1;j<9;j++){
            if(placeX>35*(j-1)+20 && placeX<35*j+20 && placeY>35*(i-1)+180 && placeY<35*i+180){
                borad[i][j] = turn;
                black[2] = [NSString stringWithFormat:@"%d",i];
                white[2] = [NSString stringWithFormat:@"%d",j];
                if(turn == 0){
                    turn = 1;
                }else {
                    turn = 0;
                }
            }
        }
    }
*/
    //縦の数字、横の英語を並べる
    for(int i=0;i<8;i++){
        num[i] = [NSString stringWithFormat:@"%d",i+1];
        eng[i] = [NSString stringWithFormat:@"%c",65+i];
    }
    
    //上の部分の画像
    for(int i=0;i<3;i++){
        [black[i] drawAtPoint:CGPointMake(100.0, 40.0+i*30) withFont:[UIFont systemFontOfSize:20.0]];
        [white[i] drawAtPoint:CGPointMake(220.0, 40.0+i*30) withFont:[UIFont systemFontOfSize:20.0]];
        if(i < 2){
            [side[i] drawAtPoint:CGPointMake(0.0, 70.0+i*30) withFont:[UIFont systemFontOfSize:20.0]];
        }
    }
    //ボードの色を塗る
    CGContextRef context = UIGraphicsGetCurrentContext();  // コンテキストを取得
    CGContextStrokeRect(context, CGRectMake(20,180,280,280));  // 四角形の描画
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.5, 1.0);  // 塗りつぶしの色を指定
    CGContextFillRect(context, CGRectMake(20,180,280,280));  // 四角形を塗りつぶす
    
    //縦
    for(int i=0;i<9;i++){
        if(i < 8){
            [eng[i] drawAtPoint:CGPointMake(35*i+32, 165) withFont:[UIFont systemFontOfSize:10.0]];
        }
        CGContextMoveToPoint(context, 35*i+20, 180);  // 始点
        CGContextAddLineToPoint(context, 35*i+20, 460);  // 終点
        CGContextSetLineWidth(context, 2.0);  // 12ptに設定
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextStrokePath(context);  // 描画！
    }
    //横
    for(int i=0;i<9;i++){
        if(i < 8){
            [num[i] drawAtPoint:CGPointMake(10, 193+35*i) withFont:[UIFont systemFontOfSize:10.0]];
        }
        CGContextMoveToPoint(context, 20, 35*i+180);  // 始点
        CGContextAddLineToPoint(context, 300, 35*i+180);  // 終点
        CGContextSetLineWidth(context, 2.0);  // 12ptに設定
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextStrokePath(context);  // 描画！
    }
    
    for(int i=0;i<10;i++){
		for(int j=0;j<10;j++){
            if(PieceOthello[i][j] ==  0) {
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextFillEllipseInRect(context, CGRectMake(35*(j-1)+24, 35*(i-1)+184, 28, 28));
                CGContextFillPath(context);
            }
            if(PieceOthello[i][j] ==  1) {
                CGContextSetRGBFillColor(context, 1, 1, 1, 1);
                CGContextFillEllipseInRect(context, CGRectMake(35*(j-1)+24, 35*(i-1)+184, 28, 28));
                CGContextFillPath(context);
            }
		}
	}
    
}

- (void) drawPiece
{
    CGContextRef context = UIGraphicsGetCurrentContext();  // コンテキストを取得
    for(int i=0;i<10;i++){
		for(int j=0;j<10;j++){
            if(PieceOthello[i][j] ==  0) {
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextFillEllipseInRect(context, CGRectMake(35*(j-1)+24, 35*(i-1)+184, 28, 28));
                CGContextFillPath(context);
            }
            if(PieceOthello[i][j] ==  1) {
                CGContextSetRGBFillColor(context, 1, 1, 1, 1);
                CGContextFillEllipseInRect(context, CGRectMake(35*(j-1)+24, 35*(i-1)+184, 28, 28));
                CGContextFillPath(context);
            }
		}
	}

    //コマを書く
    
}

- (void) getResult
{
	int player_count = 0;
	int computer_count = 0;
//	cout << "Ç‡Ç§ë≈ÇƒÇÈÇ∆Ç±ÇÎÇ™Ç†ÇËÇ‹ÇπÇÒ" << endl;
	for(int i=1;i<9;i++){
		for(int j=1;j<9;j++){
			if(PieceOthello[i][j] == playerTurn){
				player_count += 1;
			}else if(PieceOthello[i][j] == computerTurn){
				computer_count += 1;
			}
		}
	}
    black[1] = [NSString stringWithFormat:@"%d",computer_count];
    white[1] = [NSString stringWithFormat:@"%d",player_count];
    NSString *winner;
    NSString *result;
    winner = (player_count > computer_count) ? @"Playerの勝利です" : @"Computerの勝利です";
    result = [NSString stringWithFormat:@"player:%d computer:%d",player_count,computer_count];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:winner message:result delegate:self cancelButtonTitle:@"ゲームを終了する" otherButtonTitles:nil, nil];
    [av show];
//	cout << "åãâ ÇÕ\n" << PlayerName[PlayerTurn] <<" : " << player_count << " "<< PlayerName[ComputerTurn] << " : " << computer_count << endl;
//	cout << ((player_count > computer_count) ? PlayerName[PlayerTurn] : PlayerName[ComputerTurn]) << "Ç≥ÇÒÇÃèüóòÇ≈Ç∑" << endl;
}

- (int) SerchNext
{
	playerPutFlag= 0;
    extinctFlag = 0;
	finishFlag = 0;
	for(int i=1;i<9;i++){
		for(int j=1;j<9;j++){
            placeX = j;
            placeY = i;
			if([self searchCanPut]){
				playerPutFlag += 1;
			}
			if(PieceOthello[i][j] == -1){
				finishFlag += 1;
			}
			if(PieceOthello[i][j] == turn){
				extinctFlag += 1;
			}
		}
	}
	//èIóπÇÃîªíË
	if(finishFlag == 0){
		return FINISH_FLAG;
	}
	//ëSñ≈îªíË
	if(extinctFlag == 0){
//		cout << PlayerName[PlayerFlag] << "Ç≥ÇÒÇÕëSñ≈ÇµÇ‹ÇµÇΩ" << endl;
//		cout << PlayerName[GetEnemy()] << "Ç≥ÇÒÇÃèüóòÇ≈Ç∑" << endl;
		return FINISH_FLAG;
	}
	//ÉpÉXîªíË
	if(playerPutFlag == 0){
//		cout << PlayerName[PlayerFlag] << "Ç≥ÇÒÇÃë≈ÇƒÇÈÇ∆Ç±ÇÎÇ™Ç†ÇËÇ‹ÇπÇÒ\n" << "ÉpÉXÇµÇ‹Ç∑"<<endl;
		turn = [self getEnemy];
		eachPutFlag += 1;
		if(eachPutFlag == 2){
			return FINISH_FLAG;
		}
		return PASS_FLAG;
	}
	return 0;
}

- (int) getEnemy
{
    if(turn == FIRST){
        return SECOND;
    }else{
        return FIRST;
    }
}

- (bool) judgeCanPut:(int) GapX : (int) GapY
{
	if(PieceOthello[placeY+GapY][placeX+GapX] == [self getEnemy]){
		if(GapX > 0){
			GapX += 1;
		}else if(GapX < 0){
			GapX -= 1;
		}
		if(GapY > 0){
			GapY += 1;
		}else if(GapY < 0){
			GapY -= 1;
		}
		//é©ï™ÇåƒÇ‘
		return [self judgeCanPut:GapX :GapY];
	}else if(PieceOthello[placeY+GapY][placeX+GapX] == -99 || PieceOthello[placeY+GapY][placeX+GapX] == -1){
		return false;
	}else{
		if(DoPut){
			int gapX = 0;
			int gapY = 0;
			if(GapX != 0){
				gapX = (GapX > 1) ? 1 : -1;
			}
			if(GapY != 0){
				gapY = (GapY > 1) ? 1 : -1;
			}
			PieceOthello[placeY][placeX] = turn;
			for(int i = placeY+gapY,j = placeX+gapX;PieceOthello[i][j] == [self getEnemy];i += gapY ,j += gapX ){
				PieceOthello[i][j] = turn;
			}
		}
		return true;
	}
}
- (BOOL) searchCanPut
{
    int PlaceX, PlaceY;
    int GapX, GapY;
	PlaceX = placeX;
	PlaceY = placeY;
	GapX = 0;
	GapY = 0;
	bool judge[10] = {false};
	//
	if(PieceOthello[PlaceY][PlaceX] != -1){
		return false;
	}
	int judge_flag = 0;
	for(int i=PlaceY-1;i<=PlaceY+1;i++){
		for(int j=PlaceX-1;j<=PlaceX+1;j++){
			if(PieceOthello[i][j] == [self getEnemy]){
				GapY = i - PlaceY;
				GapX = j - PlaceX;
				//
				judge[judge_flag++] = [self judgeCanPut:GapX:GapY];
			}
		}
	}
	//
	for(int i=0;i<9;i++){
		if(judge[i] == true) {
			return true;
		}
	}
	return false;
}

- (bool) UpdatePiece
{
	bool update;
	DoPut = 1;
	update = [self searchCanPut];
	DoPut = 0;
	return update;
}

- (bool) ComUpdatePiece:(int) pointx :(int) pointy
{
    placeX = pointx;
    placeY = pointy;
    bool update;
	DoPut = 1;
	update = [self searchCanPut];
	DoPut = 0;
	return update;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        exit(1);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
