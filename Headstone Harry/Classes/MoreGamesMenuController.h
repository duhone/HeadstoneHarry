/*
 *  MoreGamesMenuController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/29/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Controller2.h"

class MoreGamesMenuController : public CR::UI::Controller2
{
public:
	MoreGamesMenuController();
	virtual ~MoreGamesMenuController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// Delegate Methods
	virtual void OnExitButtonTouched();
	virtual void OnAFTBTouched();
	virtual void OnBoBTouched();
	virtual void OnBTalesTouched();
	virtual void OnBoB2Touched();
private:
	//SpriteLabel *spriteLabel;
	Button *exitButton;
	Button *AFTBButton;
	Button *BoBButton;
	Button *BTalesButton;
	Button *BoB2Button;
};