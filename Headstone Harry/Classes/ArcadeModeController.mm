/*
 *  ArcadeModeController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/3/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "ArcadeModeController.h"
#include "ArcadeModeSaveInfo.h"
#include "SettingsSaveInfo.h"

using namespace CR::UI;
using namespace CR::Sound;

extern ArcadeModeSaveInfo *arcadeModeSaveInfo;
extern SettingsSaveInfo *settingsSaveInfo;

ArcadeModeController::ArcadeModeController() : Controller2(false)
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
	scoreTallyController = new ScoreTallyController(this);
	
	m_controllerFSM << pauseMenuController << optionsMenuController << helpMenuController << bonusGameController << scoreTallyController;
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

ArcadeModeController::~ArcadeModeController()
{
}

Control* ArcadeModeController::OnGenerateView()
{
	ArcadeModeView *view = new ArcadeModeView();
	view->BeforeUpdate += Delegate(this, &ArcadeModeController::OnBeforeUpdate);
	view->AfterRender += Delegate(this, &ArcadeModeController::OnAfterRender);
	view->resourcePuzzle->ResourcesRetrieved += Delegate2<ArcadeModeController, TileType, int>(this,&ArcadeModeController::OnResourcesRetrieved);
	view->resourcePuzzle->MoveMade += Delegate(this, &ArcadeModeController::OnMoveMade);
	
	pauseButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Pause_Button, 900);
	pauseButton->SetPosition(266, 13);
	pauseButton->TouchUpInside += Delegate(this, &ArcadeModeController::OnPauseButtonTouched);
	pauseButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	timerBar = UIEngine::Instance().CreateTimerBar(view, CR::AssetList::Timer1Base, 900);
	timerBar->UseFillQuad();
	timerBar->ColorSprite(CR::AssetList::Timer1Color);
	timerBar->NoiseSprite(CR::AssetList::Timer1Bubble);
	timerBar->SetPosition(133, 63);
	timerBar->TopLeft().Set(10,54);
	timerBar->TopRight().Set(257,54);
	timerBar->BottomLeft().Set(10,72);
	timerBar->BottomRight().Set(257,72);
	timerBar->SetMaxTime(60);
	timerBar->TimerExpired += Delegate(this, &ArcadeModeController::OnTimerExpired);

	timeTag = UIEngine::Instance().CreateSpriteLabel(view, CR::AssetList::Time_Tag, 895);
	timeTag->SetPosition(37, 61);
	
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
	bonusBar->TimerExpired += Delegate(this, &ArcadeModeController::OnBonusExpired);
	
	bonusLabel = UIEngine::Instance().CreateSpriteLabel(view, CR::AssetList::Bonus_Tags, 895);
	bonusLabel->SetPosition(160, 467);
	bonusLabel->Visible(false);
	
	scoreLabel = UIEngine::Instance().CreateNumberLabel(view, CR::AssetList::Font_Score_1, 900);
	scoreLabel->SetPosition(150, 35);
	scoreLabel->SetAlignment(CR::UI::AlignFontCenter);
	scoreLabel->SetValue(0);
	//OnBonusExpired();
	return view;
}

void ArcadeModeController::OnInitialized()
{
	pauseMenuController->Initialize();
	optionsMenuController->Initialize();
	helpMenuController->Initialize();
	bonusGameController->Initialize();
	scoreTallyController->Initialize();
	
	m_multiplier = 1;
	m_isPaused = false;
	m_isBonusGame = false;
	m_isScoreTally = false;
	//m_puzzleBonus = NoBonus;
	m_score = 0;
	m_timeBack = 1;
	m_totalTime = 0;

	m_currBonus = NoBonus;
	
	((ArcadeModeView*)m_view)->resourcePuzzle->SetHintsEnabled(settingsSaveInfo->GetOptionsHintsOn());
	((ArcadeModeView*)m_view)->resourcePuzzle->SetEasyAssistEnabled(settingsSaveInfo->GetEasyAssistOn());
	
	ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
	m_newGamePlayer.PlaySound();
}

void ArcadeModeController::OnDestroyed()
{
	pauseMenuController->DeInitialize();
	optionsMenuController->DeInitialize();
	helpMenuController->DeInitialize();
	bonusGameController->DeInitialize();
	scoreTallyController->DeInitialize();
}

void ArcadeModeController::OnBeforeUpdate()
{
	scoreLabel->SetValue(m_score);
	
	float timePassed = Globals::Instance().GetTimer()->GetLastFrameTime();
	m_totalTime += timePassed;
	
	//if (m_currBonus == Sec30 || m_currBonus == Sec15)
	//{
	//	timerBar->ResetTimer();
	//}
}

void ArcadeModeController::OnAfterRender()
{
	if (m_isPaused || m_isBonusGame || m_isScoreTally)
		m_controllerFSM();
}

void ArcadeModeController::OnPauseButtonTouched()
{
	m_isPaused = true;
	m_controllerFSM.State = 0;
	
	PauseGame(true);
}

void ArcadeModeController::OnResumeGame()
{
	m_isPaused = false;
	ResumeControl();
	
	((ArcadeModeView*)m_view)->resourcePuzzle->SetHintsEnabled(settingsSaveInfo->GetOptionsHintsOn());
	((ArcadeModeView*)m_view)->resourcePuzzle->SetEasyAssistEnabled(settingsSaveInfo->GetEasyAssistOn());
	
	PauseGame(false);
}

void ArcadeModeController::OnExitGame()
{
	SetRequestState(4);
}

void ArcadeModeController::OnResetGame()
{
	m_multiplier = 1;
	m_totalTime = 0;
	m_isScoreTally = false;
	PauseGame(false);
	
	UIEngine::Instance().SetRootControl(m_view);
	
	m_score = 0;
	bonusBar->Stop();
	timerBar->ResetTimer();
	
	((ArcadeModeView*)m_view)->resourcePuzzle->ResetPuzzle();
	//((ArcadeModeView*)m_view)->resourcePuzzle->AnimatePuzzleSlideIn();
	
	
	// HACK: Hard reset the puzzle
	//((ArcadeModeView*)m_view)->HardResetPuzzle();
	//((ArcadeModeView*)m_view)->resourcePuzzle->ResourcesRetrieved += Delegate2<ArcadeModeController, TileType, int>(this,&ArcadeModeController::OnResourcesRetrieved);
	//((ArcadeModeView*)m_view)->resourcePuzzle->MoveMade += Delegate(this, &ArcadeModeController::OnMoveMade);
	
	
	
	ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
}

void ArcadeModeController::OnEndGame()
{
	m_isPaused = false;
	OnTimerExpired();
}

void ArcadeModeController::OnResourcesRetrieved(TileType rType, int cnt)
{	
	//OnTriggerBonusRound();
	//return;
	
	if (m_currBonus == NoBonus && rType == BonusTile)
	{
		OnTriggerBonusRound();
	}
	else if (rType == BonusTile && 
			 (m_currBonus == Mult2X || m_currBonus == Mult3X || m_currBonus == Mult4X ||
			 m_currBonus == Mult6X || m_currBonus == Mult8X || m_currBonus == Mult12X/* ||
			 m_currBonus == Mult16X*/))
	{
		IncreaseMultiplierBonus();
	}
	else if (rType == BonusTile && 
			 (m_currBonus == Sec15 || m_currBonus == Sec30 || m_currBonus == Sec45 ||
			 m_currBonus == Sec60 || m_currBonus == Sec75 || m_currBonus == Sec90/* ||
			 m_currBonus == Sec120*/))
	{
		IncreaseTimeBonus();
	}
	else if (rType == BonusTile && m_currBonus == SuperCharger)
	{
		//bonusBar->SetMaxTime(m_superChargeBonusTime);
		//bonusBar->ResetTimer();
	}
	else if (rType == BonusTile && m_currBonus == WildHearts)
	{
		//bonusBar->SetMaxTime(m_wildHeartBonusTime);
		//bonusBar->ResetTimer();
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

	m_score += (50 * cnt) * ((ArcadeModeView *) m_view)->resourcePuzzle->ChainCount() * m_multiplier;
	timerBar->IncreaseTimer(m_timeBack);
}

void ArcadeModeController::OnMoveMade()
{

}

void ArcadeModeController::OnTimerExpired()
{
	if (m_isScoreTally) return;
	OnBonusExpired();
	m_isScoreTally = true;
	PauseGame(true);
	m_controllerFSM.State = 4;
}

void ArcadeModeController::OnBonusExpired()
{
	((ArcadeModeView*)m_view)->resourcePuzzle->EnableBonusUpAnim(false);
	
	if (m_currBonus == SuperCharger)
	{
		((ArcadeModeView *) m_view)->resourcePuzzle->EndSuperChargeMode();
	}
	else if (m_currBonus == WildHearts)
	{
		((ArcadeModeView *) m_view)->resourcePuzzle->EndWildHeartsMode();
	}
	else if (m_currBonus == Sec15 || m_currBonus == Sec30 || m_currBonus == Sec45 ||
			 m_currBonus == Sec60 || m_currBonus == Sec75 || m_currBonus == Sec90 ||
			 m_currBonus == Sec120)
	{
		timerBar->ResumeTimer();
	}
	
	m_multiplier = 1;
	m_currBonus = NoBonus;
	bonusLabel->Visible(false);
	ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
}

void ArcadeModeController::OnTriggerBonusRound()
{
	m_isBonusGame = true;
	m_controllerFSM.State = 3;

	ISound::Instance().PlaySong(CR::AssetList::music::BGMBonus::ID);
	
	PauseGame(true);
}

void ArcadeModeController::OnExitBonusRound(BonusType bonusType)
{
	// debug: for testing purposes only
	//bonusType = WildHearts;
	
	m_isBonusGame = false;
	PauseGame(false);
	
	UIEngine::Instance().SetRootControl(m_view);
	
	// Clear timer and hide the bonus label
	bonusBar->Stop();
	bonusLabel->Visible(false);
	((ArcadeModeView *) m_view)->resourcePuzzle->EndSuperChargeMode();
	
	switch (bonusType)
	{
		case Points20K:
			m_currBonus = NoBonus;
			m_score += 20000;
			ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
			break;
		case Points10K:
			m_currBonus = NoBonus;
			m_score += 10000;
			ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
			break;
		case Points5K:
			m_currBonus = NoBonus;
			m_score += 5000;
			ISound::Instance().PlaySong(CR::AssetList::music::BGMArcade::ID);
			break;
		case Mult3X:
			bonusBar->SetMaxTime(m_multBonusTime);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			m_multiplier = 3;
			bonusLabel->SetFrame(1);
			bonusLabel->Visible(true);
			ISound::Instance().PlaySong(CR::AssetList::music::BGMScore::ID);
			((ArcadeModeView*)m_view)->resourcePuzzle->EnableBonusUpAnim(true);
			break;
		case Mult2X:
			bonusBar->SetMaxTime(m_multBonusTime);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			m_multiplier = 2;
			bonusLabel->SetFrame(0);
			bonusLabel->Visible(true);
			ISound::Instance().PlaySong(CR::AssetList::music::BGMScore::ID);
			((ArcadeModeView*)m_view)->resourcePuzzle->EnableBonusUpAnim(true);
			break;
		case SuperCharger:
			bonusBar->SetMaxTime(m_superChargeBonusTime);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			bonusLabel->SetFrame(14);
			bonusLabel->Visible(true);
			((ArcadeModeView *) m_view)->resourcePuzzle->StartSuperChargeMode();
			ISound::Instance().PlaySong(CR::AssetList::music::BGMScore::ID);
			break;
		case WildHearts:
			bonusBar->SetMaxTime(m_wildHeartBonusTime);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			bonusLabel->SetFrame(15);
			bonusLabel->Visible(true);
			((ArcadeModeView *) m_view)->resourcePuzzle->StartWildHeartsMode();
			ISound::Instance().PlaySong(CR::AssetList::music::BGMScore::ID);
			break;
		case Sec30:
			bonusBar->SetMaxTime(30);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			bonusLabel->SetFrame(8);
			bonusLabel->Visible(true);
			timerBar->HaltTimer();
			ISound::Instance().PlaySong(CR::AssetList::music::BGMScore::ID);
			((ArcadeModeView*)m_view)->resourcePuzzle->EnableBonusUpAnim(true);
			break;
		case Sec15:
			bonusBar->SetMaxTime(15);
			bonusBar->ResetTimer();
			m_currBonus = bonusType;
			bonusLabel->SetFrame(7);
			bonusLabel->Visible(true);
			timerBar->HaltTimer();
			ISound::Instance().PlaySong(CR::AssetList::music::BGMScore::ID);
			((ArcadeModeView*)m_view)->resourcePuzzle->EnableBonusUpAnim(true);
			break;
		default:
			break;
	};
}


bool ArcadeModeController::Begin()
{
	return Controller2::Begin();
}

void ArcadeModeController::PauseGame(bool _pause)
{
	m_view->Paused(_pause);
	((ArcadeModeView*)m_view)->resourcePuzzle->PauseAnimation(_pause);
}

int ArcadeModeController::GetScore()
{
	return m_score;
}

int ArcadeModeController::GetTotalTime()
{
	return (int)m_totalTime;
}

void ArcadeModeController::IncreaseMultiplierBonus()
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
			((ArcadeModeView*)m_view)->resourcePuzzle->EnableBonusUpAnim(false);
			break;
		default:
			bonusLabel->SetFrame(1);
			m_multiplier = 3;
			m_currBonus = Mult3X;
			break;
	}
	
	// reset the bonus timer to full
	bonusBar->SetMaxTime(m_multBonusTime);
	bonusBar->IncreaseTimer(m_multBonusTime/2);
	//bonusBar->ResetTimer();
}

void ArcadeModeController::IncreaseTimeBonus()
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
			((ArcadeModeView*)m_view)->resourcePuzzle->EnableBonusUpAnim(false);
			break;
		default:
			// max bonus is 120 seconds
			bonusLabel->SetFrame(8);
			m_currBonus = Sec30;
			timeBonus = 30;
			break;
	}
	
	bonusBar->SetMaxTime(timeBonus, true);
	//bonusBar->ResetTimer();
}