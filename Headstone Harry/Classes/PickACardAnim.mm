/*
 *  PickACardAnim.cpp
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/12/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "PickACardAnim.h"
#include "AssetList.h"

extern CR::Graphics::GraphicsEngine *graphics_engine;

PickACardAnim::PickACardAnim()
{
	x = 230;
	y = 420;
	m_isPlaying = false;
	
	spriteAnim = graphics_engine->CreateSprite1(true, 500);
	spriteAnim->SetImage(CR::AssetList::Pick_A_Card_Loop);
	spriteAnim->SetPositionAbsolute(x, y);
}

PickACardAnim::~PickACardAnim()
{
	spriteAnim->Release();
}

void PickACardAnim::Play()
{
	m_isPlaying = true;
	spriteAnim->SetFrame(0);
	spriteAnim->SetAutoAnimate(true);
	//spriteAnim->AutoStopAnimate();
}

void PickACardAnim::Reset()
{
	m_isPlaying = false;
}

void PickACardAnim::Update()
{
}

void PickACardAnim::Render()
{
	if (m_isPlaying)
		spriteAnim->Render();
}