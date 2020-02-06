/*
 *  BonusCard.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/7/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "BonusCard.h"
#include "AssetList.h"
using namespace CR::Graphics;
using namespace std;

extern CR::Graphics::GraphicsEngine *graphics_engine;

BonusCard::BonusCard(IBonusCardController *pController)
{	
	currSprite = 0;
	m_isPlaying = false;
	m_touched = false;
	m_bonusNotified = false;
	
	Sprite *tmpSprite = graphics_engine->CreateSprite1(true, 500);
	tmpSprite->SetImage(CR::AssetList::Bonus_Card_Spin_Out);
	spriteList.push_back(tmpSprite);
	
	tmpSprite = graphics_engine->CreateSprite1(true, 500);
	tmpSprite->SetImage(CR::AssetList::Bonus_Card_Blink);
	SetBounds(tmpSprite->GetFrameWidth(), tmpSprite->GetFrameHeight());
	spriteList.push_back(tmpSprite);
	
	tmpSprite = graphics_engine->CreateSprite1(true, 500);
	tmpSprite->SetImage(CR::AssetList::Bonus_Card_2XMult);
	spriteList.push_back(tmpSprite);
	
	tmpSprite = graphics_engine->CreateSprite1(true, 499);
	tmpSprite->SetImage(CR::AssetList::Bonus_Card_Dim);
	spriteList.push_back(tmpSprite);
	
	parentController = pController;
}

BonusCard::~BonusCard()
{
	for (int i = 0; i < spriteList.size(); i++)
		spriteList[i]->Release();
}

void BonusCard::Reset()
{
	currSprite = 0;
	m_isPlaying = false;
	m_touched = false;
	m_bonusNotified = false;
	spriteList[0]->SetFrame(0);
	spriteList[1]->SetFrame(0);
	spriteList[2]->SetFrame(0);
	spriteList[3]->SetFrame(0);
}

void BonusCard::RandomizeType()
{
	int cardType = (rand() % 9);
	m_bonusType = (BonusType) cardType;
	
	//enum BonusType { Points20K, Points10K, Points5K, Mult3X, Mult2X,
	//	SuperCharger, WildHearts, Sec30, Sec15 };
	
	int sImg = 0;
	switch (m_bonusType)
	{
		case Points20K:
			sImg = CR::AssetList::Bonus_Card_20KPoints;
			break;
		case Points10K:
			sImg = CR::AssetList::Bonus_Card_10KPoints;
			break;
		case Points5K:
			sImg = CR::AssetList::Bonus_Card_5KPoints;
			break;
		case Mult3X:
			sImg = CR::AssetList::Bonus_Card_3XMult;
			break;
		case Mult2X:
			sImg = CR::AssetList::Bonus_Card_2XMult;
			break;
		case SuperCharger:
			sImg = CR::AssetList::Bonus_Card_Super_Charge;
			break;
		case WildHearts:
			sImg = CR::AssetList::Bonus_Card_WildHearts;
			break;
		case Sec30:
			sImg = CR::AssetList::Bonus_Card_30Sec;
			break;
		case Sec15:
			sImg = CR::AssetList::Bonus_Card_15Sec;
			break;
		default:
			break;
	};

	spriteList[2]->SetImage(sImg);
	spriteList[3]->SetFrame(sImg);
}

void BonusCard::Play()
{
	if (!m_isPlaying)
	{
		RandomizeType();
		
		currSprite = 0;
		spriteList[currSprite]->SetFrame(0);
		spriteList[currSprite]->SetAutoAnimate(true);
		spriteList[currSprite]->AutoStopAnimate();
	}
	
	m_isPlaying = true;
}

void BonusCard::ShowDimmer()
{
	if (!m_touched)
	{
		currSprite = 3;
		spriteList[currSprite]->SetFrame((int)m_bonusType);
	}
}

void BonusCard::OnTouchDown()
{
}

void BonusCard::OnTouchDownWhileDisabled()
{
}

void BonusCard::OnTouchUpInside()
{
	if (currSprite == 1 && !m_touched && !parentController->CardSelected())
	{
		currSprite++;
		spriteList[currSprite]->SetFrame(0);
		spriteList[currSprite]->SetAutoAnimate(true);
		spriteList[currSprite]->AutoStopAnimate();
		m_touched = true;
		TouchUpInside();
		parentController->CardSelected(true);
	}
}

void BonusCard::OnTouchUpOutside()
{
}

void BonusCard::OnSetPosition(float x, float y)
{
	spriteList[0]->SetPositionAbsolute(x + spriteList[1]->GetFrameWidth()/2, y + spriteList[1]->GetFrameHeight()/2);
	spriteList[1]->SetPositionAbsolute(x + spriteList[1]->GetFrameWidth()/2, y + spriteList[1]->GetFrameHeight()/2);
	spriteList[2]->SetPositionAbsolute(x + spriteList[1]->GetFrameWidth()/2, y + spriteList[1]->GetFrameHeight()/2);
	spriteList[3]->SetPositionAbsolute((x + spriteList[1]->GetFrameWidth()/2) + 1, y + spriteList[1]->GetFrameHeight()/2);
}

void OnSetBounds(float left, float top, float width, float height)
{
}

void BonusCard::OnBeforeUpdate()
{
	if (!m_isPlaying) return;
	
	if (!spriteList[currSprite]->IsAnimating())
	{
		// Change from spin out to pick a card loop
		if (currSprite == 0)
		{
			DoneSpinning();
			currSprite = 1;
			spriteList[currSprite]->SetFrame(0);
			spriteList[currSprite]->SetAutoAnimate(true);
		}
		
		if (currSprite == 2 && m_touched && !m_bonusNotified)
		{
			m_bonusNotified = true;
			BonusReceived(m_bonusType);
		}
	}
}

void BonusCard::OnBeforeRender()
{
	if (!m_isPlaying) return;

	spriteList[currSprite]->Render();
	
	if (currSprite == 3)
		spriteList[currSprite - 1]->Render();
}