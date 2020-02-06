/*
 *  HomeMenuController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/29/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "HomeMenuController.h"
#include "MainMenuController.h"

HomeMenuController::HomeMenuController(MainMenuController *mainController) : Controller2(true) // TODO: This should be true to make the menu stay in memory!
{
	//InitializeView(OnGenerateView(), true);
	m_mainController = mainController;
}

HomeMenuController::~HomeMenuController()
{
}

Control* HomeMenuController::OnGenerateView()
{
	View *view = new View(CR::AssetList::Menu_Background, 1000);
	
	arcadeModeButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Menu_Play_Game_Button, 800);
	arcadeModeButton->SetPosition(15, 315);
	arcadeModeButton->TouchUpInside += Delegate(this, &HomeMenuController::OnArcadeModeTouched);
	arcadeModeButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	highScoresButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Menu_High_Scores_Button_2, 800);
	highScoresButton->SetPosition(177, 380);
	highScoresButton->TouchUpInside += Delegate(this, &HomeMenuController::OnHighScoresTouched);
	highScoresButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	freeModeButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Menu_Free_Play_Button, 800);
	freeModeButton->SetPosition(12, 380);
	freeModeButton->TouchUpInside += Delegate(this, &HomeMenuController::OnFreeModeTouched);
	freeModeButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	optionsButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Menu_Options_Button, 800);
	optionsButton->SetPosition(8, 433);
	optionsButton->TouchUpInside += Delegate(this, &HomeMenuController::OnOptionsTouched);
	optionsButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	helpButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Menu_Help_Info_Button, 800);
	helpButton->SetPosition(111, 433);
	helpButton->TouchUpInside += Delegate(this, &HomeMenuController::OnHelpTouched);
	helpButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	moreGamesButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Menu_More_Games_Button, 800);
	moreGamesButton->SetPosition(204, 433);
	moreGamesButton->TouchUpInside += Delegate(this, &HomeMenuController::OnMoreGamesTouched);
	moreGamesButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	return view;
}

void HomeMenuController::OnInitialized()
{

}

void HomeMenuController::OnDestroyed()
{
}

void HomeMenuController::OnArcadeModeTouched()
{
	m_mainController->SetRequestState(2);
}

void HomeMenuController::OnFreeModeTouched()
{
	m_mainController->SetRequestState(5);
}

void HomeMenuController::OnHighScoresTouched()
{
	SetRequestState(4);
}

void HomeMenuController::OnHelpTouched()
{
	SetRequestState(2);
}

void HomeMenuController::OnOptionsTouched()
{
	SetRequestState(3);
}

void HomeMenuController::OnMoreGamesTouched()
{
	SetRequestState(1);
}