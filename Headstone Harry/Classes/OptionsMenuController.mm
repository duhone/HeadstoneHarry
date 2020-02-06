/*
 *  OptionsMenuController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/1/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "OptionsMenuController.h"
#include "SettingsSaveInfo.h"
#include "Sound.h"
using namespace CR::Sound;

extern SettingsSaveInfo *settingsSaveInfo;

OptionsMenuController::OptionsMenuController() : Controller2(true) // TODO: This should be true to make the menu stay in memory!
{
	//InitializeView(OnGenerateView(), true);
}

OptionsMenuController::~OptionsMenuController()
{
}

Control* OptionsMenuController::OnGenerateView()
{
	View *view = new View(CR::AssetList::Options_Base, 500);
	view->BeforeUpdate += Delegate(this, &OptionsMenuController::OnBeforeUpdate);
	
	exitButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Options_Exit_Button, 400);
	exitButton->SetPosition(112, 426);
	exitButton->TouchUpInside += Delegate(this, &OptionsMenuController::OnExitButtonTouched);
	exitButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	musicCheckBox = UIEngine::Instance().CreateCheckBox(view, CR::AssetList::Options_Check, 400);
	musicCheckBox->SetPosition(23, 64);
	musicCheckBox->CheckToggled += Delegate(this, &OptionsMenuController::OnMusicCheckToggled);
	musicCheckBox->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	soundCheckBox = UIEngine::Instance().CreateCheckBox(view, CR::AssetList::Options_Check, 400);
	soundCheckBox->SetPosition(23, 149);
	soundCheckBox->CheckToggled += Delegate(this, &OptionsMenuController::OnSoundCheckToggled);
	soundCheckBox->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	hintsCheckBox = UIEngine::Instance().CreateCheckBox(view, CR::AssetList::Options_Check, 400);
	hintsCheckBox->SetPosition(23, 231);
	hintsCheckBox->CheckToggled += Delegate(this, &OptionsMenuController::OnHintsCheckToggled);
	hintsCheckBox->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	easyCheckBox = UIEngine::Instance().CreateCheckBox(view, CR::AssetList::Options_Check, 400);
	easyCheckBox->SetPosition(23, 320);
	easyCheckBox->CheckToggled += Delegate(this, &OptionsMenuController::OnEasyCheckToggled);
	easyCheckBox->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	return view;
}

void OptionsMenuController::OnInitialized()
{
	musicCheckBox->Checked(settingsSaveInfo->GetOptionsMusicOn());
	soundCheckBox->Checked(settingsSaveInfo->GetOptionsSoundOn());
	hintsCheckBox->Checked(settingsSaveInfo->GetOptionsHintsOn());
	easyCheckBox->Checked(settingsSaveInfo->GetEasyAssistOn());
}

void OptionsMenuController::OnDestroyed()
{
}

void OptionsMenuController::OnBeforeUpdate()
{
}

void OptionsMenuController::OnExitButtonTouched()
{
	SetRequestState(0);
}

void OptionsMenuController::OnMusicCheckToggled()
{
	settingsSaveInfo->SetOptionsMusicOn(musicCheckBox->Checked());
	ISound::Instance().MuteMusic(!settingsSaveInfo->GetOptionsMusicOn());
}

void OptionsMenuController::OnSoundCheckToggled()
{
	settingsSaveInfo->SetOptionsSoundOn(soundCheckBox->Checked());
	ISound::Instance().MuteSounds(!settingsSaveInfo->GetOptionsSoundOn());
}

void OptionsMenuController::OnHintsCheckToggled()
{
	settingsSaveInfo->SetOptionsHintsOn(hintsCheckBox->Checked());
}

void OptionsMenuController::OnEasyCheckToggled()
{
	settingsSaveInfo->SetEasyAssistOn(easyCheckBox->Checked());
}
