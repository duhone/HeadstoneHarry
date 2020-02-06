/*
 *  OptionsMenuController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/1/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Controller2.h"
#include "CheckBox.h"

class OptionsMenuController : public Controller2
{
public:
	OptionsMenuController();
	virtual ~OptionsMenuController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// View Events
	virtual void OnBeforeUpdate();
	
	// Delegate Methods
	virtual void OnExitButtonTouched();
	void OnMusicCheckToggled();
	void OnSoundCheckToggled();
	void OnHintsCheckToggled();
	void OnEasyCheckToggled();
	
private:
	CR::UI::Button *exitButton;
	CR::UI::CheckBox *musicCheckBox;
	CR::UI::CheckBox *soundCheckBox;
	CR::UI::CheckBox *hintsCheckBox;
	CR::UI::CheckBox *easyCheckBox;
};