/*
 *  TouchControl.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "TouchControl.h"
using namespace CR::UI;

TouchControl::TouchControl() : Control()
{
	m_touchDown = false;
	m_allowDragTouch = true;
	
	this->touch = NULL;
}

TouchControl::~TouchControl()
{
}

bool TouchControl::TouchesBegan(UIView *view, NSSet *touches)
{		
	CGPoint touchPos;
	for (UITouch *touch in touches)
	{
		if (this->touch != NULL && touch != this->touch)
			continue;
		
		touchPos = [touch locationInView: view];
		
		if (touchPos.x > bounds.left && 
			touchPos.x < bounds.right + bounds.left &&
			touchPos.y > bounds.top &&
			touchPos.y < bounds.bottom + bounds.top)
		{
			if (m_enabled)
			{
				this->touch = touch;
				m_touchDown = true;
				OnTouchDown();
			}
			else {
				OnTouchDownWhileDisabled();
			}

		}
	}
	
	return m_touchDown;
}

bool TouchControl::TouchesMoved(UIView *view, NSSet *touches)
{
	if (!m_enabled) return false;
	
	CGPoint touchPos;
	for (UITouch *touch in touches)
	{
		if (this->touch != NULL && touch != this->touch)
			continue;
		
		touchPos = [touch locationInView: view];
		
		if (touchPos.x > bounds.left && 
			touchPos.x < bounds.right + bounds.left &&
			touchPos.y > bounds.top &&
			touchPos.y < bounds.bottom + bounds.top)
		{						
			if (!m_touchDown && (this->touch != NULL || m_allowDragTouch))
			{
				if (m_enabled)
				{
					this->touch = touch;
					m_touchDown = true;
					OnTouchDown();
				}
				else {
					OnTouchDownWhileDisabled();
				}

			}
		}
		else
		{
			m_touchDown = false;
		}
	}
	
	return m_touchDown;
}

void TouchControl::TouchesEnded(UIView *view, NSSet *touches)
{
	for (UITouch *touch in touches)
	{
		if (touch == this->touch)
		{
			if (m_touchDown)
				OnTouchUpInside();
			else
				OnTouchUpOutside();
			
			m_touchDown = false;
			this->touch = NULL;
		}
	}
}

void TouchControl::TouchesCancelled(UIView *view, NSSet *touches)
{
	for (UITouch *touch in touches)
	{
		if (touch == this->touch)
		{
			if (m_touchDown)
				OnTouchUpInside();
			else
				OnTouchUpOutside();
			
			m_touchDown = false;
			this->touch = NULL;
		}
	}
}

