/*
 *  BonusGameController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/6/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "BonusGameController.h"
#include "ArcadeModeController.h"
#include "Globals.h"

using namespace CR::UI;
using namespace CR::Sound;

BonusGameController::BonusGameController(IGameController *controller) : Controller2(true)
{
	maxCardDelay = 0.2;
	cardDelay = maxCardDelay;
	playCards = false;
	currCard = 0;
	
	cardSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::card1::ID));
	cardSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::card2::ID));
	cardSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::card3::ID));
	cardSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::card4::ID));
	//cardSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::card5::ID));
	//cardSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::card6::ID));
	//cardSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::card7::ID));
	//cardSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::card8::ID));
	m_controller = controller;
}

BonusGameController::~BonusGameController()
{
}

Control* BonusGameController::OnGenerateView()
{
	BonusGameView *view = new BonusGameView();
	
	// Generate the cards
	int startX = 38;
	int startY = 80;
	int xPos = startX;
	int yPos = startY;
	bonusCards.clear();
	for (int i = 0; i < 5; i++)
	{
		BonusCard *bCard = new BonusCard(this);
		bCard->SetPosition(xPos, yPos);
		bonusCards.push_back(bCard);
		
		if (i == 2) // update positions for next two rows
		{
			xPos = startX + 65;
			yPos += 130;
		}
		else
		{
			xPos += 93;
		}
	}
	
	for (int i = 0; i < bonusCards.size(); i++)
	{
		bonusCards[i]->BonusReceived += Delegate1<BonusGameController, BonusType>(this,&BonusGameController::OnBonusReceived);
		bonusCards[i]->TouchUpInside += Delegate(this, &BonusGameController::OnBonusTouched);
		
		if (i == bonusCards.size() - 1)
		{
			bonusCards[i]->DoneSpinning += Delegate(this, &BonusGameController::OnCardsDoneSpinning);
		}
	}
	
	for (int i = 0; i < bonusCards.size(); i++)
		view->GetChildren().push_back(bonusCards[i]);
	
	view->BeforeUpdate += Delegate(this, &BonusGameController::OnBeforeUpdate);
	view->skeletonAnim->DonePlaying += Delegate(this, &BonusGameController::OnDonePlayingSkeletonAnim);
	view->bonusBanner->DonePlaying += Delegate(this, &BonusGameController::OnDoneBonusBannerAnim);
	
	return view;
}

void BonusGameController::OnInitialized()
{	
	cardDelay = maxCardDelay;
	playCards = false;
	currCard = 0;
	
	m_isClosing = false;
	closeControllerTime = 2.0f; // close 2 seconds after complete
	bType = Points20K;
	m_cardSelected = false;
	//skeletonAnim->Reset();
	//((BonusGameView*)m_view)->ResetSkeleton();
	
	// reset cards
	for (int i = 0; i < 5; i++)
	{
		bonusCards[i]->Reset();
	}
	
	((BonusGameView*)m_view)->pickACardAnim->Reset();
	((BonusGameView*)m_view)->bonusBanner->Reset();
	((BonusGameView*)m_view)->skeletonAnim->Play();
}

void BonusGameController::OnDestroyed()
{
	// TODO: not sure what to do here, ask eric
	//for (int i = 0; i < cardSounds.size(); i++)
	//{
	//	delete cardSounds[i];
	//}
	//cardSounds.clear();
}

void BonusGameController::OnBeforeUpdate()
{
	if (playCards)
	{
		if (currCard < bonusCards.size())
		{
			cardDelay -= Globals::Instance().GetTimer()->GetLastFrameTime();
			
			if (cardDelay <= 0)
			{
				
				//for (int i = 0; i < bonusCards.size(); i++)
				//	bonusCards[i]->Play();
				
				bonusCards[currCard]->Play();
				
				cardDelay = maxCardDelay;
				currCard++;
			}
		}
		else {
			playCards = false;
		}

	}
	
	if (m_isClosing)
	{
		float timePassed = Globals::Instance().GetTimer()->GetLastFrameTime();
		closeControllerTime -= timePassed;
		
		if (closeControllerTime <= 0)
		{
			m_controller->OnExitBonusRound(bType);
		}
	}
}

void BonusGameController::OnDoneBonusBannerAnim()
{
	playCards = true;
}

void BonusGameController::OnDonePlayingSkeletonAnim()
{
	((BonusGameView*)m_view)->bonusBanner->Play();
}

void BonusGameController::OnCardsDoneSpinning()
{
	((BonusGameView*)m_view)->pickACardAnim->Play();
}

void BonusGameController::OnBonusTouched()
{
	//((BonusGameView*)m_view)->skeletonAnim->PlaySelectAnim();
	
	// Play Select Card Sound
	int isnd = (rand() % 4);
	cardSounds[isnd]->Play();
}

void BonusGameController::OnBonusReceived(BonusType bType)
{
	for (int i = 0; i < bonusCards.size(); i++)
		bonusCards[i]->ShowDimmer();
	
	m_isClosing = true;
	this->bType = bType;
}

void BonusGameController::CardSelected(bool _value)
{
	m_cardSelected = _value;
}

bool BonusGameController::CardSelected()
{
	return m_cardSelected;
}