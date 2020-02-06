/*
 *  HomeMenuController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/29/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#include "Controller2.h"
#include "InputEngine.h"
#include "Event.h"
#include "Graphics.h"
#include "View.h"
#include "Control.h"
#include "Button.h"
#include <vector>
#include "UIEngine.h"
using namespace std;
using namespace CR::UI;

class MainMenuController;

class HomeMenuController : public CR::UI::Controller2
{
public:
	HomeMenuController(MainMenuController *mainController);
	virtual ~HomeMenuController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// Delegate Methods
	void OnArcadeModeTouched();
	void OnHighScoresTouched();
	void OnFreeModeTouched();
	void OnHelpTouched();
	void OnOptionsTouched();
	void OnMoreGamesTouched();
	
private:
	MainMenuController *m_mainController;
	Button *arcadeModeButton;
	Button *highScoresButton;
	Button *freeModeButton;
	Button *helpButton;
	Button *optionsButton;
	Button *moreGamesButton;
};