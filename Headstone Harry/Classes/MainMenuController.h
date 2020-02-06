/*
 *  MainMenuController.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 5/22/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#include "FSM.h"
#include "Sound.h"
#include "HomeMenuController.h"
#include "OptionsMenuController.h"
#include "MoreGamesMenuController.h"
#include "HelpMenuController.h"
#include "HighScoresMenuController.h"

#define SPLASH_MENU_STATE 0
#define HOME_MENU_STATE 1
#define OPTIONS_MENU_STATE 2
#define HELP_MENU_STATE 3
#define MORE_GAMES_MENU_STATE 4

class MainMenuController : public CR::Utility::IState
{
public:
	MainMenuController();
	virtual ~MainMenuController();
	
	//IState
	virtual bool Begin();
	virtual void End();
	virtual int Process();
	
	void SetRequestState(int state);
	
private:
	CR::Utility::FSM m_controllerFSM;
	int m_requestState;
	
	HomeMenuController *homeMenuController;
	MoreGamesMenuController *moreGamesMenuController;
	HelpMenuController *helpMenuController;
	OptionsMenuController *optionsMenuController;
	HighScoresMenuController *highScoresMenuController;
};