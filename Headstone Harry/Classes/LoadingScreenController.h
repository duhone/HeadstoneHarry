/*
 *  LoadingScreenController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/9/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Graphics.h"
#include "Controller2.h"

class LoadingScreenController : public Controller2
{
public:
	LoadingScreenController(int _nSprite, float delay, int nextState);
	virtual ~LoadingScreenController();
	
	// Controller
	virtual Control* OnGenerateView();
	void OnInitialized();
	void OnDestroyed();
	
	// View Events
	virtual void OnBeforeUpdate();
	
private:
	float m_delay;
	int m_nSprite;
	int m_nextState;
};