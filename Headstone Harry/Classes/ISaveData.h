/*
 *  ISaveData.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 11/20/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

class ISaveData
{
public:
	virtual ~ISaveData();
	
	void Save();
	void Load();
	
	
protected:
	ISaveData();
	
};