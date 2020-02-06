/*
 *  BonusGameView.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/7/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "TouchControl.h"
#include "MatchThreePuzzle.h"
#include "Graphics.h"
#include "SkeletonAnim.h"
#include "BonusBanner.h"
#include "PickACardAnim.h"
#include <vector>

class BonusGameView : public CR::UI::View
{
public:
	BonusGameView();
	virtual ~BonusGameView();
	
	// TouchControl
	virtual void OnTouchDown() {};
	virtual void OnTouchDownWhileDisabled() {};
	virtual void OnTouchUpInside() {};
	virtual void OnTouchUpOutside() {};
	virtual void OnSetPosition(float x, float y) {};
	virtual void OnSetBounds(float x, float y) {};
	
	// Control Methods
	virtual void OnBeforeUpdate();
	virtual void OnBeforeRender();
	
	//private:
	std::vector<CR::Graphics::Sprite*> cardSprites;
	SkeletonAnim *skeletonAnim;
	BonusBanner *bonusBanner;
	PickACardAnim *pickACardAnim;
};