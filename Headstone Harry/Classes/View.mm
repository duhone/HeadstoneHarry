/*
 *  View.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/27/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "View.h"
using namespace CR::UI;

extern CR::Graphics::GraphicsEngine *graphics_engine;


View::View(int _nSprite, int _zInitial) : TouchControl()
{
	backgroundSprite = graphics_engine->CreateSprite1(false, _zInitial);
	backgroundSprite->SetImage(_nSprite);
	backgroundSprite->SetPositionAbsolute(160, 240);
	SetBounds(backgroundSprite->GetFrameWidth(), backgroundSprite->GetFrameHeight());
}

View::~View()
{
	backgroundSprite->Release();
}

void View::OnBeforeUpdate()
{

}

void View::OnBeforeRender()
{
	backgroundSprite->Render();
}

void View::OnSetPosition(float x, float y)
{
	backgroundSprite->SetPositionAbsolute(x + backgroundSprite->GetFrameWidth()/2, y + backgroundSprite->GetFrameHeight()/2);
}

void View::OnSetBounds(float x, float y)
{
}