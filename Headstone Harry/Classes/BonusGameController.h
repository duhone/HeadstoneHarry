/*
 *  BonusGameController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/6/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Controller2.h"
#include "UIEngine.h"
#include "BonusGameView.h"
#include "BonusCard.h"
#include <vector>
#include "Sound.h"
#include "IGameController.h"
#include "IBonusCardController.h"

using namespace CR::UI;

class ArcadeModeController;

class BonusGameController : public CR::UI::Controller2, IBonusCardController
{
public:
	BonusGameController(IGameController *controller);
	virtual ~BonusGameController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// View Events
	virtual void OnBeforeUpdate();
	
	// Delegate Methods
	virtual void OnDoneBonusBannerAnim();
	virtual void OnDonePlayingSkeletonAnim();
	virtual void OnCardsDoneSpinning();
	virtual void OnBonusTouched();
	virtual void OnBonusReceived(BonusType bType);
	
	// IBonusCardController
	void CardSelected(bool _value);
	bool CardSelected();
	
private:
	IGameController *m_controller;
	vector<BonusCard*> bonusCards;
	
	bool m_isClosing;
	float closeControllerTime;
	BonusType bType;
	
	bool playCards;
	float maxCardDelay;
	float cardDelay;
	int currCard;
	
	bool m_cardSelected;
	
	vector<std::tr1::shared_ptr<CR::Sound::ISoundFX> > cardSounds;
};