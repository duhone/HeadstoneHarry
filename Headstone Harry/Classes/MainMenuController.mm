/*
 *  MainMenuController.mm
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 5/22/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "MainMenuController.h"
#include <UIKit/UIApplication.h>
#include "Game.h"
#include "HomeMenuController.h"
#include "OptionsMenuController.h"
#include "MainMenuController.h"

using namespace CR::Sound;
using namespace CR::UI;

extern CR::Graphics::GraphicsEngine *graphics_engine;

MainMenuController::MainMenuController()
{
	homeMenuController = new HomeMenuController(this);
	moreGamesMenuController = new MoreGamesMenuController();
	helpMenuController = new HelpMenuController();
	optionsMenuController = new OptionsMenuController();
	highScoresMenuController = new HighScoresMenuController();
	
	m_controllerFSM << homeMenuController << moreGamesMenuController << helpMenuController << optionsMenuController << highScoresMenuController;
	m_controllerFSM.State = 0;
}

MainMenuController::~MainMenuController()
{
}

bool MainMenuController::Begin()
{
	// initialize all the controllers
	
	// TODO: This is where the menus were loaded
	homeMenuController->Initialize();
	moreGamesMenuController->Initialize();
	helpMenuController->Initialize();
	optionsMenuController->Initialize();
	highScoresMenuController->Initialize();
	
	// other stuff
	m_requestState = CR::Utility::IState::UNCHANGED;
	ISound::Instance().PlaySong(CR::AssetList::music::BGMMenu::ID);
	m_controllerFSM.SetState(0);
	
	return true;
}

void MainMenuController::End()
{
	// deinitialize all the controllers
	
	// TODO: This is where the menus were unloaded
	homeMenuController->DeInitialize();
	moreGamesMenuController->DeInitialize();
	helpMenuController->DeInitialize();
	optionsMenuController->DeInitialize();
	highScoresMenuController->DeInitialize();
}

int MainMenuController::Process()
{
	m_controllerFSM();
	
	return m_requestState;
}

void MainMenuController::SetRequestState(int state)
{
	m_requestState = state;
}