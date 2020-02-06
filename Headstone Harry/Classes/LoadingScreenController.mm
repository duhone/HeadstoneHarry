/*
 *  LoadingScreenController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/9/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#include "LoadingScreenController.h"
#include "View.h"
#include "AssetList.h"
#include "MainMenuController.h"

LoadingScreenController::LoadingScreenController(int _nSprite, float delay, int nextState) : Controller2(false)
{
	m_nextState = nextState;
	m_nSprite = _nSprite;
	m_delay = delay;
}

LoadingScreenController::~LoadingScreenController()
{
}

Control* LoadingScreenController::OnGenerateView()
{
	View *view = new View(m_nSprite, 1000);
	
	return view;
}

void LoadingScreenController::OnInitialized()
{
		SetRequestState(m_nextState);
}

void LoadingScreenController::OnDestroyed()
{
}

void LoadingScreenController::OnBeforeUpdate()
{

}