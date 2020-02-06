/*
 *  BonusBanner.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/12/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "BonusBanner.h"
#include "AssetList.h"
#include "Globals.h"

extern CR::Graphics::GraphicsEngine *graphics_engine;

BonusBanner::BonusBanner()
{
	timePassed= 0;
	x = 135;
	y = 60;
	m_isPlaying = false;
	
	
	bonusBanner = graphics_engine->CreateSweeper(500);
	bonusBanner->SetImage(CR::AssetList::Bonus_Round_Header);
	bonusBanner->Position(x, y);
	bonusBanner->SweepTime(0.8f);
	bonusBanner->TransitionWidth(0.2f);
	bonusBanner->Start();
}

BonusBanner::~BonusBanner()
{
	bonusBanner->Release();
}

void BonusBanner::Play()
{
	timePassed = 0;
	m_isPlaying = true;
	bonusBanner->Start();
}

void BonusBanner::Reset()
{
	bonusBanner->Reset();
}

void BonusBanner::Update()
{
	if (!m_isPlaying) return;

	timePassed += Globals::Instance().GetTimer()->GetLastFrameTime();
	
	if (timePassed >= 1)
	{
		m_isPlaying = false;
		DonePlaying();
	}
}

void BonusBanner::Render()
{
	//if (m_isPlaying)
		bonusBanner->Render();
}