/*
 *  PauseMenuController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/3/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Controller2.h"
#include "UIEngine.h"
#include "IGameController.h"

class ArcadeModeController;

class PauseMenuController : public CR::UI::Controller2
{
public:
	PauseMenuController(IGameController *controller);
	virtual ~PauseMenuController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// View Events
	virtual void OnBeforeUpdate();
	
	// Delegate Methods
	virtual void OnPauseButtonTouched();
	virtual void OnMainMenuButtonTouched();
	virtual void OnOptionsMenuButtonTouched();
	virtual void OnHowToPlayButtonTouched();
	
private:
	IGameController *m_controller;
	Button *resumeGameButton;
	Button *mainMenuButton;
	Button *optionsMenuButton;
	Button *howToPlayButton;
};