/*
 *  HighScoresMenuController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/5/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Controller2.h"
#include <vector>
#include "TextLabel.h"

class HighScoresMenuController : public Controller2
{
public:
	HighScoresMenuController();
	virtual ~HighScoresMenuController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// View Events
	virtual void OnBeforeUpdate();
	
	// Delegate Methods
	virtual void OnExitButtonTouched();
	//virtual void OnUploadScoresButtonTouched();
	virtual void OnLeaderboardsButtonTouched();
	
protected:
	//virtual void SubmitHighScoreToLeaderboard(string _name, float _score, string _url);
	
private:
	std::vector<CR::UI::NumberLabel*> numberLabels;
	std::vector<CR::UI::TextLabel*> initialsLabels;
	CR::UI::Button *exitButton;
	//CR::UI::Button *uploadScoresButton;
	CR::UI::Button *leaderboardsButton;
};