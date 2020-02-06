/*
 *  ArcadeModeController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/3/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Controller2.h"
#include "ArcadeModeView.h"
#include "UIEngine.h"
#include "PauseMenuController.h"
#include "OptionsMenuController.h"
#include "HelpMenuController.h"
#include "ScoreTallyController.h"
#include "BonusGameController.h"
#include "SpriteLabel.h"
#include "RandomSoundPlayer.h"
#include "IGameController.h"

//enum PuzzleBonus { NoBonus };

class ArcadeModeController : public CR::UI::Controller2, IGameController
{
public:
	ArcadeModeController();
	virtual ~ArcadeModeController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// View Events
	virtual void OnBeforeUpdate();
	virtual void OnAfterRender();
	
	// Delegate Methods
	void OnPauseButtonTouched();
	void OnResumeGame();
	void OnExitGame();
	void OnResetGame();
	void OnEndGame();

	
	// MatchThreePuzzle Delegates
	void OnResourcesRetrieved(TileType rType, int cnt);
	void OnMoveMade();
	void OnTimerExpired();
	void OnBonusExpired();
	void OnTriggerBonusRound();
	void OnExitBonusRound(BonusType bonusType);
	
	virtual bool Begin();
	
	int GetScore();
	int GetTotalTime();
	
	void IncreaseMultiplierBonus();
	void IncreaseTimeBonus();
	
private:
	TimerBar2 *timerBar;
	TimerBar2 *bonusBar;
	SpriteLabel *bonusLabel;
	SpriteLabel *timeTag;
	
	NumberLabel *scoreLabel;
	Button *pauseButton;
	
	CR::Utility::FSM m_controllerFSM;
	bool m_isPaused;
	bool m_isBonusGame;
	bool m_isScoreTally;
	//PuzzleBonus m_puzzleBonus;
	
	// Scoring Information
	float m_totalTime;
	int m_timeBack;
	int m_score;
	BonusType m_currBonus;
	int m_multiplier;
	int m_multBonusTime;
	int m_superChargeBonusTime;
	int m_wildHeartBonusTime;
	CR::Game::RandomSoundPlayer m_newGamePlayer;
	
	void PauseGame(bool _pause);
	
	// Controllers
	PauseMenuController *pauseMenuController;
	OptionsMenuController *optionsMenuController;
	HelpMenuController *helpMenuController;
	BonusGameController *bonusGameController;
	ScoreTallyController *scoreTallyController;
};