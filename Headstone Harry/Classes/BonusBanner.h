/*
 *  BonusBanner.h
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

class BonusBanner
{
public:
	BonusBanner();
	virtual ~BonusBanner();
	
	void Play();
	void Update();
	void Render();
	void Reset();
	
	Event DonePlaying;
	
private:
	int x;
	int y;
	
	CR::Graphics::ISweeper* bonusBanner;
	bool m_isPlaying;
	float timePassed;
};