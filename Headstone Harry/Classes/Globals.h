/*
 *  Globals.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 7/2/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#include "Singleton.h"
#include "Timer.h"
#include "UIEngine.h"

using namespace CR::Utility;

class Globals : public CR::Utility::Singleton<Globals>
{
public:
	friend class CR::Utility::Singleton<Globals>;
	virtual ~Globals();
	
	void Update();
	
	CR::Utility::Timer *GetTimer() const { return m_timer; }
	
private:
	Globals();
	CR::Utility::Timer *m_timer;
};