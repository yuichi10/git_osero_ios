//
//  Computer.m
//  SampleOthello01
//
//  Created by YuichiSawada on 2014/02/16.
//  Copyright (c) 2014年 YuichiSawada. All rights reserved.
//

#import <stdio.h>
#import <stdlib.h>
#import <time.h>
#import "Computer.h"
#import "BoradView.h"

@implementation Computer
{
    int Computer_Turn;
	int Player_turn;
	int CountReverseNum;
	int CountTurnNum;
	int DoReturn;
    int BoradPoint[10][10];
    int NowBorad;
    BoradView *cBoradview;
}

- (void) setComputer:(int) compter_turn : (int) player_turn
{
    Computer_Turn = compter_turn;
	Player_turn = player_turn;
	CountReverseNum = 0;
	CountTurnNum = 0;
	DoReturn = 0;
    cBoradview = [BoradView sharedManager];
}

- (int) GetPointForRecerse
{
	int point = 0;
	if(CountTurnNum < 8){
		switch(CountReverseNum){
			case 1: point  += 35;
                break;
			case 2: point  += 15;
                break;
			case 3: point  +=  5;
                break;
			default: point +=  0;
		}
	}else if(CountTurnNum > 20){
		switch(CountReverseNum){
			case 1: point  +=  1;
			case 2: point  +=  5;
			case 3: point  += 25;
			case 4: point  += 15;
			default: point +=  0;
		}
	}else {
		switch(CountReverseNum){
			case 6: point  += 35;
				break;
			case 5: point  += 25;
				break;
			case 4: point  += 15;
				break;
			case 3: point  +=  5;
				break;
			default: point +=  0;
		}
	}
	return point;
}

- (int) GetRandamPoint
{
    srand((unsigned int)time(NULL));
	int point = 0;
    
	if(CountTurnNum < 3){
		point += rand() % 60;
	}else if(CountTurnNum < 5){
		point += rand() % 30;
	}else if(CountTurnNum < 8){
		point += rand() % 15;
	}
    
	if(point % 10 == 0 && point != 0){
		point += 1;
	}
	return point;
}

- (int) GetNextPutNumberPoint:(int) placeX : (int) placeY
{
	int NextBorad[10][10];
	int PreserveBorad[10][10];
	int countCanPutNum = 0;
	int min = 60;
	for(int i=0;i<10;i++){
		for(int j=0;j<10;j++){
			NextBorad[i][j] = [cBoradview getBoradPiece:j : i];
		}
	}
	//Ç‹Ç∏é©ï™ÇÃèÍèäÇë≈Ç¬
	[self MakeFutureBorad:placeX:placeY:NextBorad:Computer_Turn];
	//ç°ÇÃèÛë‘ÇÃÉoÉbÉNÉAÉbÉv
	for(int i=0;i<10;i++){
		for(int j=0;j<10;j++){
			PreserveBorad[i][j] = NextBorad[i][j];
		}
	}
//	cout << placeX <<  " : " << placeY << "-> ";  //ÇØÇµÇƒÇnÇjÅ@
	//ëäéËÇ™ë≈Ç¬èÍèäÇ≤Ç∆Ç≈çlÇ¶ÇÈ
	for(int i=1;i< 9;i++){
		for(int j=1;j<9;j++){
			if([self ThinkSearchBorad:j:i:NextBorad:Player_turn]){
				[self MakeFutureBorad:j:i:NextBorad:Player_turn];
				//é©ï™Ç™âΩÇ©èäë≈ÇƒÇÈèÍèäÇ™Ç†ÇÈÇ©
				countCanPutNum = 0;
				for(int k=1;k<9;k++){
					for(int l=1;l<9;l++){
						if([self ThinkSearchBorad:l:k:NextBorad:Computer_Turn]){
							countCanPutNum++;
						}
					}
				}
				if(countCanPutNum){
//					cout <<"(" << j << "," << i << ")" << countCanPutNum <<"  "; //ÇØÇµÇƒÇnÇj
					if(min > countCanPutNum){
						min = countCanPutNum;
					}
				}
				for(int k=0;k<10;k++){
					for(int l=0;l<10;l++){
						NextBorad[k][l] = PreserveBorad[k][l];
					}
				}
			}
		}
	}
//	cout << endl; //ÇØÇµÇƒÇnÇj
	
	return 0;
}

- (bool) ThinkJudgePiece:(int) placeX : (int) placeY : (int) gapX :(int) gapY : (int[][10]) borad : (int) playerFlag
{
	int enemy;
	if(playerFlag == Computer_Turn){
		enemy = Player_turn;
	}else {
		enemy = Computer_Turn;
	}
	if(borad[placeY+gapY][placeX+gapX] == enemy){
		if(gapX > 0){
			gapX += 1;
		}else if(gapX < 0){
			gapX -= 1;
		}
		if(gapY > 0){
			gapY += 1;
		}else if(gapY < 0){
			gapY -= 1;
		}
		//é©ï™ÇåƒÇ‘
		return [self ThinkJudgePiece:placeX:placeY:gapX:gapY:borad:playerFlag];
	}else if(borad[placeY+gapY][placeX+gapX] == -99 || borad[placeY+gapY][placeX+gapX] == -1){
		return false;
	}else{
		if(DoReturn){
			int GapX = 0;
			int GapY = 0;
			if(gapX != 0){
				GapX = (gapX > 1) ? 1 : -1;
			}
			if(gapY != 0){
				GapY = (gapY > 1) ? 1 : -1;
			}
			borad[placeY][placeX] = playerFlag;
			for(int i = placeY+GapY,j = placeX+GapX;borad[i][j] == enemy;i += GapY ,j += GapX ){
				borad[i][j] = playerFlag;
			}
		}
		return true;
	}
}

- (bool) ThinkSearchBorad:(int) pointX : (int) pointY : (int[][10]) borad : (int) playerFlag
{
	int gapX = 0;
	int gapY = 0;
	int enemy = -1;
	if(playerFlag == Computer_Turn){
		enemy = Player_turn;
	}else {
		enemy = Computer_Turn;
	}
	bool judge[10] = {false};
	//ë≈Ç¡ÇΩèÍèäÇ™äJÇ¢ÇƒÇ»Ç©Ç¡ÇΩÇÁfalseÇï‘Ç∑
	if(borad[pointY][pointX] != -1){
		return false;
	}
	int judge_flag = 0;
	for(int i=pointY-1;i<=pointY+1;i++){
		for(int j=pointX-1;j<=pointX+1;j++){
			if(borad[i][j] == enemy){
				gapY = i - pointY;
				gapX = j - pointX;
				//Ç–Ç¡Ç≠ÇËï‘Ç∑Ç±Ç∆Ç™Ç≈Ç´ÇÈÇ©í≤Ç◊ÇÈä÷êîÇåƒÇ‘
				judge[judge_flag++] = [self ThinkJudgePiece:pointX:pointY:gapX:gapY:borad:playerFlag];
			}
		}
	}
	//Ç«Ç±Ç©àÍÇ¬Ç≈Ç‡trueÇ™Ç†Ç¡ÇΩÇÁtrueÇï‘Ç∑
	for(int i=0;i<9;i++){
		if(judge[i] == true) {
			return true;
		}
	}
	return false;
}

- (int) GetNextCornerPoint:(int) placeX : (int) placeY
{
	int NextBorad[10][10];
	for(int i=0;i<10;i++){
		for(int j=0;j<10;j++){
			NextBorad[i][j] = [cBoradview getBoradPiece:j : i];
		}
	}
	[self MakeFutureBorad: placeX : placeY : NextBorad : Computer_Turn];
	if([self ThinkSearchBorad:1 :1 :NextBorad:Player_turn] || [self ThinkSearchBorad:1 :8 :NextBorad:Player_turn] || [self ThinkSearchBorad:8 :1 :NextBorad:Player_turn] || [self ThinkSearchBorad:8:8:NextBorad:Player_turn]){
        return -255;
	}
	return 0;
}

- (void) JudgePiece: (int) placeX : (int) placeY : (int) gapX : (int) gapY
{
	int borad_point [10][10] = {{0,  0,  0, 0, 0, 0, 0, 0,  0, 0},
        {0,100,-50,60,50,50,60,-50,100,0},
        {0,-50,-90,30,40,30,40,-90,-50,0},
        {0, 60, 40,70,20,10,70, 30, 60,0},
        {0, 50, 30,20, 0, 0,10, 40, 50,0},
        {0, 50, 40,10, 0, 0,20, 30, 50,0},
        {0, 60, 30,70,10,20,70, 40, 60,0},
        {0,-50,-90,40,30,40,30,-90,-50,0},
        {0,100,-50,60,50,50,60,-50,100,0},
        {0,  0,  0, 0, 0, 0, 0,  0, 0, 0}};
	if([cBoradview getBoradPiece:placeX+gapX : placeY+gapY] == Player_turn){
		//Ç–Ç¡Ç≠ÇËï‘ÇµÇΩêîÇêîÇ¶ÇÈ
		CountReverseNum += 1;
        
		if(gapX > 0){
			gapX += 1;
		}else if(gapX < 0){
			gapX -= 1;
		}
		if(gapY > 0){
			gapY += 1;
		}else if(gapY < 0){
			gapY -= 1;
		}
		[self JudgePiece:placeX:placeY:gapX:gapY];
	}else if([cBoradview getBoradPiece:(placeX+gapX) : (placeY+gapY)] == Computer_Turn){
		BoradPoint[placeY][placeX] = borad_point[placeY][placeX];
	}
}

- (void) SearchBorad:(int) placeX :  (int) placeY
{
	int gapX = 0;
	int gapY = 0;
	if([cBoradview getBoradPiece:placeX:placeY] == -1){
		for(int i=placeY-1;i<=placeY+1;i++){
			for(int j=placeX-1;j<=placeX+1;j++){
				if([cBoradview getBoradPiece:j : i] == Player_turn){
					gapY = i - placeY;
					gapX = j - placeX;
					//Ç–Ç¡Ç≠ÇËï‘Ç∑Ç±Ç∆Ç™Ç≈Ç´ÇÈÇ©í≤Ç◊ÇÈä÷êîÇåƒÇ‘
					[self JudgePiece:placeX:placeY:gapX:gapY];
				}
			}
		}
	}
}

- (void) ComputerThink
{
	int maxPlace = -10000;
	int maxX = 0;
	int maxY = 0;
	int ReverseNumPoint = 0;	//Ç–Ç¡Ç≠ÇËï‘Ç∑êîÇ≈åàÇﬂÇÈì_êî
	int RandumPoint = 0;		//ÉâÉìÉ_ÉÄÇ≈ó^Ç¶ÇÈÉ|ÉCÉìÉg
	int EnemycornerPoint = 0;    //éüÇÃëäéËÇÃî‘Ç≈äpÇéÊÇÁÇÍÇÈéûÇÃÉ|ÉCÉìÉg
	int NumberOfPutPlaceNum = 0;
	int check_exist_point = 0;
    
	for(int i=1;i<9;i++){
		for(int j=1;j<9;j++){
			[self SearchBorad:j:i];
			if(BoradPoint[i][j] != 0){
				CountReverseNum = 0;
				ReverseNumPoint = [self GetPointForRecerse];
				RandumPoint = [self GetRandamPoint];
				EnemycornerPoint = [self GetNextCornerPoint: j: i];
				[self GetNextPutNumberPoint: j : i ];
				BoradPoint[i][j] = BoradPoint[i][j] + ReverseNumPoint + RandumPoint + EnemycornerPoint;
				
				if(BoradPoint[i][j] == 0){
					BoradPoint[i][j] = 1;
				}
			}
		}
	}
	for(int i=1;i<9;i++){
		for(int j=1;j<9;j++){
			if(maxPlace < BoradPoint[i][j] && BoradPoint[i][j] != 0){
				maxPlace = BoradPoint[i][j];
				maxX = j;
				maxY = i;
			}
		}
	}
//	cout << "ÉRÉìÉsÉÖÅ[É^Å[" << maxX << ":" << maxY << "Ç…ë≈ÇøÇ‹ÇµÇΩ" << endl;
	if(![cBoradview ComUpdatePiece:maxX:maxY]){
//		cout << "Computer(Err)" << endl;
	}
}

- (void) MakeFutureBorad:(int) placeX : (int) placeY : (int[][10]) borad : (int) playerFlag
{
	DoReturn = 1;
	[self ThinkSearchBorad:placeX:placeY:borad:playerFlag];
	DoReturn = 0;
}

- (void) StartComputerThink
{
	CountTurnNum += 1;
	for(int i=0;i<10;i++){
		for(int j=0;j<10;j++){
			BoradPoint[i][j] = 0;
		}
	}
	[self ComputerThink];
}


@end
