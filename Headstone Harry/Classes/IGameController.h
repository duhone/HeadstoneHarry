/*
 *  IGameController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/9/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once

#include "BonusCard.h"

class IGameController
{
public:
	virtual ~IGameController() {};
	
	virtual void OnPauseButtonTouched() = 0;
	virtual void OnResumeGame() = 0;
	virtual void OnExitGame() = 0;
	virtual void OnResetGame() = 0;
	virtual int GetScore() = 0;
	virtual int GetTotalTime() = 0;
	virtual void OnExitBonusRound(BonusType bonusType) = 0;
	virtual void OnEndGame() = 0;
	
protected:
	IGameController() {};
};