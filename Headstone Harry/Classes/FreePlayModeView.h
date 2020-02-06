/*
 *  FreePlayModeView.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/9/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "TouchControl.h"
#include "MatchThreePuzzle.h"
#include "Graphics.h"

class FreePlayModeView : public CR::UI::Control
{
public:
	FreePlayModeView();
	virtual ~FreePlayModeView();
	
	// Touch Methods
	bool TouchesBegan(UIView *view, NSSet *touches);
	bool TouchesMoved(UIView *view, NSSet *touches);
	void TouchesEnded(UIView *view, NSSet *touches);
	void TouchesCancelled(UIView *view, NSSet *touches);
	
	// TouchControl
	virtual void OnTouchDown() {};
	virtual void OnTouchDownWhileDisabled() {};
	virtual void OnTouchUpInside() {};
	virtual void OnTouchUpOutside() {};
	virtual void OnSetPosition(float x, float y) {};
	virtual void OnSetBounds(float x, float y) {};
	
	// Control Methods
	virtual void OnBeforeUpdate();
	virtual void OnBeforeRender();
	virtual void OnPaused(bool _paused);
	
	//private:
	MatchThreePuzzle *resourcePuzzle;
	CR::Graphics::Sprite *hudTop;
	CR::Graphics::Sprite *hudBottom;
};