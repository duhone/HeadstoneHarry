/*
 *  ScoreTallyController.h
 *  Headstone Harry
 *
 *  Created by Robert on 11/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Controller2.h"
#include "UIEngine.h"
#include <string>
#include "TextLabel.h"
#include "Sound.h"
#include "IGameController.h"

class ArcadeModeController;

class ScoreTallyController : public CR::UI::Controller2
{
public:
	ScoreTallyController(IGameController *controller);
	virtual ~ScoreTallyController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// View Events
	virtual void OnBeforeUpdate();
	
	// Delegate Methods
	virtual void OnYesButtonTouched();
	virtual void OnNoButtonTouched();
	virtual void OnEnterInitialsTouched();
	virtual void OnUploadScoreButtonTouched();
	virtual void OnViewTouched();
	
	// Keyboard Delegate Methods
	virtual void OnKeyTyped(char key);
	virtual void OnKeyboardShown();
	virtual void OnKeyboardHidden();
	
protected:
	virtual void SaveHighScore();
	virtual void SubmitHighScoreToLeaderboard(string _name, float _score, string _url);
	
private:
	IGameController *m_controller;
	SpriteLabel *playAgainTag;
	SpriteLabel *timeTag;
	SpriteLabel *newHighScoreTag;
	Button *yesButton;
	Button *noButton;
	Button *enterInitialsButton;
	Button *uploadScoreButton;
	
	NumberLabel *scoreTally;
	TextLabel *initialsLabel;
	TimeLabel *timeLabel;
	
	std::string m_initials;
	int m_score;
	int m_totalTime;
	bool m_isNewHighScore;
	bool m_scoreUploaded;
	vector<std::tr1::shared_ptr<CR::Sound::ISoundFX> > sounds;
	//std::tr1::shared_ptr<CR::Sound::ISoundFX> endGameSound;
	// Keyboard interaction
	//UITextField *textField;
	
	int cursorPos;
};