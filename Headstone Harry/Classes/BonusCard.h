/*
 *  BonusCard.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/7/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Graphics.h"
#include "UIEngine.h"
#include "IBonusCardController.h"
#include <vector>

enum BonusType { Points20K, Points10K, Points5K, Mult2X, Mult3X,
				 SuperCharger, WildHearts, Sec15, Sec30, NoBonus, 
				 Mult4X, Mult6X, Mult8X, Mult12X, Mult16X, Sec45, Sec60, Sec75, Sec90, Sec120};

class BonusCard : public CR::UI::TouchControl
{
public:
	BonusCard(IBonusCardController *pController);
	virtual ~BonusCard();
	
	void Reset();
	void RandomizeType();
	void Play();
	void ShowDimmer();
	
	// Events
	Event DoneSpinning;
	Event TouchUpInside;
	Event1<BonusType> BonusReceived;
	
protected:
	// Control Methods
	virtual void OnBeforeUpdate();
	virtual void OnBeforeRender();
	
	// TouchControl Methods
	virtual void OnTouchDown();
	virtual void OnTouchDownWhileDisabled();
	virtual void OnTouchUpInside();
	virtual void OnTouchUpOutside();
	virtual void OnSetPosition(float x, float y);
	virtual void OnSetBounds(float x, float y) {}
	//virtual void OnSetBounds(float left, float top, float width, float height);
	
private:
	std::vector<Sprite*> spriteList;
	int currSprite;
	bool m_isPlaying;
	BonusType m_bonusType;
	
	bool m_touched;
	bool m_bonusNotified;
	
	IBonusCardController *parentController;
};