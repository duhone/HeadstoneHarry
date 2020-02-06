/*
 *  Button.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "Button.h"
using namespace CR::UI;

extern CR::Graphics::GraphicsEngine *graphics_engine;

Button::Button(int _nSprite, int _zInitial) : TouchControl()
{
	buttonSprite = graphics_engine->CreateSprite1(false, _zInitial);
	buttonSprite->SetImage(_nSprite);
	SetBounds(buttonSprite->GetFrameWidth(), buttonSprite->GetFrameHeight());
	m_allowDragTouch = false;
}

Button::~Button()
{
	buttonSprite->Release();
}

void Button::OnBeforeUpdate()
{
	if (m_touchDown)
	{
		buttonSprite->SetFrameSet(1);
	}
	else
	{
		buttonSprite->SetFrameSet(0);
	}
}

void Button::OnBeforeRender()
{
	buttonSprite->Render();
}

void Button::SetSoundTouchDown(const CR::Utility::Guid &soundId)
{
	//this->soundId = soundId;
	if (soundId.IsNull()) return;
	
	m_soundTouchDown = CR::Sound::ISound::Instance().CreateSoundFX(soundId);
}

void Button::SetSoundDisabled(const CR::Utility::Guid &soundId)
{
	if (soundId.IsNull()) return;
	
	m_soundDisabled = CR::Sound::ISound::Instance().CreateSoundFX(soundId);
}

void Button::OnTouchDown()
{
	if (m_soundTouchDown)
		m_soundTouchDown->Play();
	
	TouchDown();
}

void Button::OnTouchDownWhileDisabled()
{
	if (m_soundDisabled)
		m_soundDisabled->Play();
}

void Button::OnTouchUpInside()
{
	TouchUpInside();
}

void Button::OnTouchUpOutside()
{
	TouchUpOutside();
}

void Button::OnSetPosition(float x, float y)
{
	buttonSprite->SetPositionAbsolute(x + buttonSprite->GetFrameWidth()/2, y + buttonSprite->GetFrameHeight()/2);
}

void Button::OnSetBounds(float x, float y)
{
}