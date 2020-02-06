/*
 *  SkeletonAnim.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/7/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Graphics.h"
#include <vector>
#include "Event.h"
using namespace std;

class SkeletonAnim
{
public:
	SkeletonAnim();
	virtual ~SkeletonAnim();
	
	void Play();
	void Update();
	void Render();
	
	//Event DoneFlyout;
	Event DonePlaying;
	
private:
	int x;
	int y;
	
	int endX;
	
	CR::Graphics::Sprite* skelSprite;
	bool m_isPlaying;
	bool m_isDonePlaying;
};