/*
 *  PickACardAnim.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/12/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Graphics.h"
#include <vector>
#include "Event.h"
using namespace std;

class PickACardAnim
{
public:
	PickACardAnim();
	virtual ~PickACardAnim();
	
	void Play();
	void Update();
	void Render();
	void Reset();
	
private:
	int x;
	int y;
	
	CR::Graphics::Sprite* spriteAnim;
	bool m_isPlaying;
};