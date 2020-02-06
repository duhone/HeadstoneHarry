/*
 *  FreePlayModeController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/9/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#include "FreePlayModeController.h"
#include "ArcadeModeSaveInfo.h"
#include "SettingsSaveInfo.h"

using namespace CR::UI;
using namespace CR::Sound;

extern ArcadeModeSaveInfo *arcadeModeSaveInfo;
extern SettingsSaveInfo *settingsSaveInfo;

FreePlayModeController::FreePlayModeController() : Controller2(false)
{/*
  BonusGameController *bGameController = new BonusGameController(this);
  bGameController->Initialize();	
  m_controllerFSM << new PauseMenuController(this) << new OptionsMenuController() << new HelpMenuController() << bGameController << new ScoreTallyController(this);
  m_controllerFSM.State = 0;
  */
	
	pauseMenuController = new PauseMenuController(this);
	optionsMenuController = new OptionsMenuController();
	helpMenuController = new HelpMenuController(true);
	bonusGameController = new BonusGameController(this);
	//scoreTallyController = new ScoreTallyController(this);
	
	m_controllerFSM << pauseMenuController << optionsMenuController << helpMenuController << bonusGameController;// << scoreTallyController;
	m_controllerFSM.State = 0;
	
	m_multBonusTime = 60;
	m_superChargeBonusTime = 60;
	m_wildHeartBonusTime = 60;
	m_multiplier = 1;
	m_totalTime = 0;
	
	m_newGamePlayer.AddSound(CR::AssetList::sounds::newgame1::ID);
	m_newGamePlayer.AddSound(CR::AssetList::sounds::newgame2::ID);
	//m_newGamePlayer.AddSound(CR::AssetList::sounds::newgame3::ID);
	//m_newGamePlayer.AddSound(CR::AssetList::sounds::newgame4::ID);
	//m_newGamePlayer.AddSound(CR::AssetList::sounds::newgame5::ID);
	//m_newGamePlayer.AddSound(CR::AssetList::sounds::newgame6::ID);
	//m_newGamePlayer.AddSound(CR::AssetList::sounds::newgame7::ID);
	//m_newGamePlayer.AddSound(CR::AssetList::sounds::newgame8::ID);
	//m_newGamePlayer.AddSound(CR::AssetList::sounds::newgame9::ID);
}

FreePlayModeController::~FreePlayModeController()
{
}

Control* FreePlayModeController::OnGenerateView()
{
	FreePlayModeView *view = new FreePlayModeView();
	view->BeforeUpdate += Delegate(this, &FreePlayModeController::OnBeforeUpdate);
	view->AfterRender += Delegate(this, &FreePlayModeController::OnAfterRender);
	view->resourcePuzzle->ResourcesRetrieved += Delegate2<FreePlayModeController, TileType, int>(this,&FreePlayModeController::OnResourcesRetrieved);
	view->resourcePuzzle->MoveMade += Delegate(this, &FreePlayModeController::OnMoveMade);
	
	pauseButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Pause_Button, 900);
	pauseButton->SetPosition(266, 13);
	pauseButton->TouchUpInside += Delegate(this, &FreePlayModeController::OnPauseButtonTouched);
	pauseButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	/*
	timerBar = UIEngine::Instance().CreateTimerBar(view, CR::AssetList::Timer1Base, 900);
	timerBar->UseFillQuad();
	timerBar->ColorSprite(CR::AssetList::Timer1Color);
	timerBar->NoiseSprite(CR::AssetList::Timer1Bubble);
	timerBar->SetPosition(133, 63);
	timerBar->TopLeft().Set(10,54);
	timerBar->TopRight().Set(258,54);
	timerBar->BottomLeft().Set(10,73);
	timerBar->BottomRight().Set(254,73);
	timerBar->SetMaxTime(60);
	timerBar->TimerExpired += Delegate(this, &FreePlayModeController::OnTimerExpired);
	*/
	
	
	bonusBar = UIEngine::Instance().CreateTimerBar(view, CR::AssetList::Timer2Base, 900);
	bonusBar->UseFillQuad();
	bonusBar->ColorSprite(CR::AssetList::Timer2Color);
	//bonusBar->NoiseSprite(CR::AssetList::Timer1Bubble);
	bonusBar->SetPosition(160, 467);
	bonusBar->TopLeft().Set(7,457);
	bonusBar->TopRight().Set(313,457);
	bonusBar->BottomLeft().Set(7,477);
	bonusBar->BottomRight().Set(313,477);
	bonusBar->SetMaxTime(60);
	bonusBar->Stop();
	bonusBar->TimerExpired += Delegate(this, &FreePlayModeController::OnBonusExpired);
	
	bonusLabel = UIEngine::Instance().CreateSpriteLabel(view, CR::AssetList::Bonus_Tags, 895);
	bonusLabel->SetPosition(160, 467);
	bonusLabel->Visible(false);
	
	//scoreLabel = UIEngine::Instance().CreateNumberLabel(view, CR::AssetList::Font_Score_1, 900);
	//scoreLabel->SetPosition(150, 35);
	//scoreLabel->SetAlignment(CR::UI::AlignFontCenter);
	//scoreLabel->SetValue(0);
	
	OnBonusExpired();

	return view;
}

void FreePlayModeController::OnInitialized()
{
	pauseMenuController->Initialize();
	optionsMenuController->Initialize();
	helpMenuController->Initialize();
	bonusGameController->Initialize();
	//scoreTallyController->Initialize();
	
	m_multiplier = 1;
	m_isPaused = false;
	m_isBonusGame = false;
	m_isScoreTally = false;
	//m_puzzleBonus = NoBonus;
	//m_score = 0;
	m_timeBack = 1;
	m_totalTime = 0;
	ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
	m_newGamePlayer.PlaySound();
	
	((FreePlayModeView*)m_view)->resourcePuzzle->SetHintsEnabled(settingsSaveInfo->GetOptionsHintsOn());
	((FreePlayModeView*)m_view)->resourcePuzzle->SetEasyAssistEnabled(settingsSaveInfo->GetEasyAssistOn());
}

void FreePlayModeController::OnDestroyed()
{
	pauseMenuController->DeInitialize();
	optionsMenuController->DeInitialize();
	helpMenuController->DeInitialize();
	bonusGameController->DeInitialize();
	//scoreTallyController->DeInitialize();
}

void FreePlayModeController::OnBeforeUpdate()
{
	//scoreLabel->SetValue(m_score);
	
	float timePassed = Globals::Instance().GetTimer()->GetLastFrameTime();
	m_totalTime += timePassed;
	
	//if (m_currBonus == Sec30 || m_currBonus == Sec15)
	//{
	//	timerBar->ResetTimer();
	//}
}

void FreePlayModeController::OnAfterRender()
{
	if (m_isPaused || m_isBonusGame || m_isScoreTally)
		m_controllerFSM();
}

void FreePlayModeController::OnPauseButtonTouched()
{
	m_isPaused = true;
	m_controllerFSM.State = 0;
	
	PauseGame(true);
}

void FreePlayModeController::OnResumeGame()
{
	m_isPaused = false;
	ResumeControl();
	
	((FreePlayModeView*)m_view)->resourcePuzzle->SetHintsEnabled(settingsSaveInfo->GetOptionsHintsOn());
	((FreePlayModeView*)m_view)->resourcePuzzle->SetEasyAssistEnabled(settingsSaveInfo->GetEasyAssistOn());
	
	PauseGame(false);
}

void FreePlayModeController::OnExitGame()
{
	SetRequestState(4);
}

void FreePlayModeController::OnResetGame()
{
	m_multiplier = 1;
	m_totalTime = 0;
	m_isScoreTally = false;
	PauseGame(false);
	
	UIEngine::Instance().SetRootControl(m_view);
	
	//m_score = 0;
	bonusBar->Stop();
	//timerBar->ResetTimer();
	
	((FreePlayModeView*)m_view)->resourcePuzzle->ResetPuzzle();
}

void FreePlayModeController::OnEndGame()
{
	OnExitGame();
}

void FreePlayModeController::OnResourcesRetrieved(TileType rType, int cnt)
{	
	//OnTriggerBonusRound();
	//return;
	
	if (m_currBonus == NoBonus && rType == BonusTile)
	{
		OnTriggerBonusRound();
	}
	else if (rType == BonusTile && 
			 (m_currBonus == Mult2X || m_currBonus == Mult3X || m_currBonus == Mult4X ||
			  m_currBonus == Mult6X || m_currBonus == Mult8X || m_currBonus == Mult12X ||
			  m_currBonus == Mult16X))
	{
		IncreaseMultiplierBonus();
	}
	else if (rType == BonusTile && 
			 (m_currBonus == Sec15 || m_currBonus == Sec30 || m_currBonus == Sec45 ||
			  m_currBonus == Sec60 || m_currBonus == Sec75 || m_currBonus == Sec90 ||
			  m_currBonus == Sec120))
	{
		IncreaseTimeBonus();
	}
	else if (rType == BonusTile && m_currBonus == SuperCharger)
	{
		bonusBar->SetMaxTime(m_superChargeBonusTime);
		bonusBar->ResetTimer();
	}
	else if (rType == BonusTile && m_currBonus == WildHearts)
	{
		bonusBar->SetMaxTime(m_wildHeartBonusTime);
		bonusBar->ResetTimer();
	}
	
	//int multiplier = 1;
	//if (m_currBonus == Mult2X)
	//{
	//	multiplier = 2;
	//}
	//else if (m_currBonus == Mult3X)
	//{
	//	multiplier = 3;
	//}
	
	//m_score += (10 * cnt) * ((FreePlayModeView *) m_view)->resourcePuzzle->ChainCount() * m_multiplier;
	//timerBar->IncreaseTimer(m_timeBack);
}

void FreePlayModeController::OnMoveMade()
{
	
}

void FreePlayModeController::OnTimerExpired()
{
	if (m_isScoreTally) return;
	
	OnBonusExpired();

	m_isScoreTally = true;
	PauseGame(true);
	m_controllerFSM.State = 4;
}

void FreePlayModeController::OnBonusExpired()
{
	if (m_currBonus == SuperCharger)
	{
		((FreePlayModeView *) m_view)->resourcePuzzle->EndSuperChargeMode();
	}
	else if (m_currBonus == WildHearts)
	{
		((FreePlayModeView *) m_view)->resourcePuzzle->EndWildHeartsMode();
	}
	else if (m_currBonus == Sec15 || m_currBonus == Sec30 || m_currBonus == Sec45 ||
			 m_currBonus == Sec60 || m_currBonus == Sec75 || m_currBonus == Sec90 ||
			 m_currBonus == Sec120)
	{
		//timerBar->ResumeTimer();
	}
	
	m_multiplier = 1;
	m_currBonus = NoBonus;
	bonusLabel->Visible(false);
}

void FreePlayModeController::OnTriggerBonusRound()
{
	m_isBonusGame = true;
	m_controllerFSM.State = 3;
	
	PauseGame(true);
}

void FreePlayModeController::OnExitBonusRound(BonusType bonusType)
{
	// debug: for testing purposes only
	//bonusType = WildHearts;
	
	m_isBonusGame = false;
	PauseGame(false);
	
	UIEngine::Instance().SetRootControl(m_view);
	
	// Clear timer and hide the bonus label
	bonusBar->Stop();
	bonusLabel->Visible(false);
	((FreePlayModeView *) m_view)->resourcePuzzle->EndSuperChargeMode();
	
	switch (bonusType)
	{
		case Points20K:
			m_currBonus = NoBonus;
			//m_score += 20000;
			ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
			break;
		case Points10K:
			m_currBonus = NoBonus;
			//m_score += 10000;
			ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
			break;
		case Points5K:
			m_currBonus = NoBonus;
			//m_score += 5000;
			ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
			break;
		case Mult3X:
			bonusBar->SetMaxTime(m_multBonusTime);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			m_multiplier = 3;
			bonusLabel->SetFrame(1);
			bonusLabel->Visible(true);
			break;
		case Mult2X:
			bonusBar->SetMaxTime(m_multBonusTime);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			m_multiplier = 2;
			bonusLabel->SetFrame(0);
			bonusLabel->Visible(true);
			break;
		case SuperCharger:
			bonusBar->SetMaxTime(m_superChargeBonusTime);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			bonusLabel->SetFrame(14);
			bonusLabel->Visible(true);
			((FreePlayModeView *) m_view)->resourcePuzzle->StartSuperChargeMode();
			break;
		case WildHearts:
			bonusBar->SetMaxTime(m_wildHeartBonusTime);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			bonusLabel->SetFrame(15);
			bonusLabel->Visible(true);
			((FreePlayModeView *) m_view)->resourcePuzzle->StartWildHeartsMode();
			break;
		case Sec30:
			bonusBar->SetMaxTime(30);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			bonusLabel->SetFrame(8);
			bonusLabel->Visible(true);
			//timerBar->HaltTimer();
			break;
		case Sec15:
			bonusBar->SetMaxTime(15);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			bonusLabel->SetFrame(7);
			bonusLabel->Visible(true);
			//timerBar->HaltTimer();
			break;
		default:
			break;
	};
}


bool FreePlayModeController::Begin()
{
	return Controller2::Begin();
}

void FreePlayModeController::PauseGame(bool _pause)
{
	m_view->Paused(_pause);
	((FreePlayModeView*)m_view)->resourcePuzzle->PauseAnimation(_pause);
}

int FreePlayModeController::GetScore()
{
	//return m_score;
	return 0;
}

int FreePlayModeController::GetTotalTime()
{
	return (int)m_totalTime;
}

void FreePlayModeController::IncreaseMultiplierBonus()
{
	switch (m_currBonus)
	{
		case Mult2X: // to 3X
			bonusLabel->SetFrame(1);
			m_multiplier = 3;
			m_currBonus = Mult3X;
			break;
		case Mult3X: // to 4X
			bonusLabel->SetFrame(2);
			m_multiplier = 4;
			m_currBonus = Mult4X;
			break;
		case Mult4X: // to 6X
			bonusLabel->SetFrame(3);
			m_multiplier = 6;
			m_currBonus = Mult6X;
			break;
		case Mult6X: // to 8X
			bonusLabel->SetFrame(4);
			m_multiplier = 8;
			m_currBonus = Mult8X;
			break;
		case Mult8X: // to 12X
			bonusLabel->SetFrame(5);
			m_multiplier = 12;
			m_currBonus = Mult12X;
			break;
		case Mult12X: // to 16X
			bonusLabel->SetFrame(6);
			m_multiplier = 16;
			m_currBonus = Mult16X;
			break;
		case Mult16X: // this is the max, just do it again
			bonusLabel->SetFrame(6);
			m_multiplier = 16;
			m_currBonus = Mult16X;
			break;
		default:
			bonusLabel->SetFrame(1);
			m_multiplier = 3;
			m_currBonus = Mult3X;
			break;
	}
	
	// reset the bonus timer to full
	bonusBar->SetMaxTime(m_multBonusTime);
	bonusBar->ResetTimer();
}

void FreePlayModeController::IncreaseTimeBonus()
{
	int timeBonus;
	
	switch (m_currBonus)
	{
		case Sec15: // to 30
			bonusLabel->SetFrame(8);
			m_currBonus = Sec30;
			timeBonus = 30;
			break;
		case Sec30: // to 45
			bonusLabel->SetFrame(9);
			m_currBonus = Sec45;
			timeBonus = 45;
			break;
		case Sec45: // to 60
			bonusLabel->SetFrame(10);
			m_currBonus = Sec60;
			timeBonus = 60;
			break;
		case Sec60: // to 75
			bonusLabel->SetFrame(11);
			m_currBonus = Sec75;
			timeBonus = 75;
			break;
		case Sec75: // to 90
			bonusLabel->SetFrame(12);
			m_currBonus = Sec90;
			timeBonus = 90;
			break;
		case Sec90: // to 120
			bonusLabel->SetFrame(13);
			m_currBonus = Sec120;
			timeBonus = 120;
			break;
		case Sec120: // this is the max, just use it again
			bonusLabel->SetFrame(13);
			m_currBonus = Sec120;
			timeBonus = 120;
			break;
		default:
			// max bonus is 120 seconds
			bonusLabel->SetFrame(8);
			m_currBonus = Sec30;
			timeBonus = 30;
			break;
	}
	
	bonusBar->SetMaxTime(timeBonus);
	bonusBar->ResetTimer();
}