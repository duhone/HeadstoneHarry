/*
 *  SkeletonAnim.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/7/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "SkeletonAnim.h"
#include "AssetList.h"
using namespace CR::Graphics;

extern CR::Graphics::GraphicsEngine *graphics_engine;

SkeletonAnim::SkeletonAnim()
{
	endX = 99;
	
	x = 0;
	y = 345;

	m_isDonePlaying = false;
	
	skelSprite = graphics_engine->CreateSprite1(true, 500);
	skelSprite->SetImage(CR::AssetList::Bonus_Harry_Intro_1);
	skelSprite->SetFrame(10);
	skelSprite->SetAutoAnimate(false);
	skelSprite->SetPositionAbsolute(x, y);
}

SkeletonAnim::~SkeletonAnim()
{
	skelSprite->Release();
}

void SkeletonAnim::Play()
{
	x = 0;
	m_isDonePlaying = false;
	m_isPlaying = true;
}

void SkeletonAnim::Update()
{
	if (!m_isPlaying || m_isDonePlaying) return;
	
	if (x < endX)
	{
		x+=8;
		skelSprite->SetPositionAbsolute(x, y);
	}
	else {
		skelSprite->SetPositionAbsolute(endX, y);
		m_isDonePlaying = true;
		DonePlaying();
	}
}
						 
void SkeletonAnim::Render()						 
{
	skelSprite->Render();
}