/*
 *  IBonusCardController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 2/14/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once

class IBonusCardController
{
public:
	virtual ~IBonusCardController() {};
	
	virtual void CardSelected(bool _value) = 0;
	virtual bool CardSelected() = 0;
	
protected:
	IBonusCardController() {};
};