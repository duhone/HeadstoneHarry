/*
 *  PauseMenuController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/3/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "PauseMenuController.h"
#include "ArcadeModeController.h"
using namespace CR::UI;

PauseMenuController::PauseMenuController(IGameController *controller) : Controller2(true)
{
	m_controller = controller;
}

PauseMenuController::~PauseMenuController()
{
}

Control* PauseMenuController::OnGenerateView()
{
	View *view = new View(CR::AssetList::Pause_Menu_Background, 500);
	
	optionsMenuButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Pause_Options_Button, 400);
	optionsMenuButton->SetPosition(25, 95);
	optionsMenuButton->TouchUpInside += Delegate(this, &PauseMenuController::OnOptionsMenuButtonTouched);
	optionsMenuButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	howToPlayButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Pause_How_To_Play_Button, 400);
	howToPlayButton->SetPosition(25, 182);
	howToPlayButton->TouchUpInside += Delegate(this, &PauseMenuController::OnHowToPlayButtonTouched);
	howToPlayButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	mainMenuButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Pause_Main_Menu_Button, 400);
	mainMenuButton->SetPosition(25, 269);
	mainMenuButton->TouchUpInside += Delegate(this, &PauseMenuController::OnMainMenuButtonTouched);
	mainMenuButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	resumeGameButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Pause_Resume_Game_Button, 400);
	resumeGameButton->SetPosition(25, 346);
	resumeGameButton->TouchUpInside += Delegate(this, &PauseMenuController::OnPauseButtonTouched);
	resumeGameButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	return view;
}

void PauseMenuController::OnInitialized()
{
}

void PauseMenuController::OnDestroyed()
{
}

void PauseMenuController::OnBeforeUpdate()
{
}

void PauseMenuController::OnPauseButtonTouched()
{
	m_controller->OnResumeGame();
}

void PauseMenuController::OnMainMenuButtonTouched()
{
	//m_controller->OnExitGame();
	m_controller->OnEndGame();
}

void PauseMenuController::OnOptionsMenuButtonTouched()
{
	SetRequestState(1);
}

void PauseMenuController::OnHowToPlayButtonTouched()
{
	SetRequestState(2);
}