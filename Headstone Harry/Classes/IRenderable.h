/*
 *  IRenderable.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 10/4/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Point.h"

class IRenderable
{
public:
	virtual ~IRenderable() {};
	
	virtual void Update() = 0;
	virtual void Render() = 0;
	
	virtual void SetPosition(float xLoc, float yLoc) = 0;
	virtual void PauseAnimation(bool pause) = 0;
	
protected:
	IRenderable() {};
};