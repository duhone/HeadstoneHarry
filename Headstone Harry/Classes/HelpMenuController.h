/*
 *  HelpMenuController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/29/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Controller2.h"

class HelpMenuController : public Controller2
{
public:
	HelpMenuController(bool skipCredits = false);
	virtual ~HelpMenuController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// View Events
	virtual void OnBeforeUpdate();
	
	// Delegate Methods
	virtual void OnExitButtonTouched();
	virtual void OnLeftTouched();
	virtual void OnRightTouched();
	virtual void OnHowToPlayTouched();

private:
	CR::UI::ImageCycler *imageCycler;
	CR::UI::Button *exitButton;
	CR::UI::Button *mainMenuButton;
	CR::UI::Button *howToPlayButton;
	CR::UI::Button *leftButton;
	CR::UI::Button *rightButton;
	bool m_credits;
	bool m_skipCredits;
};