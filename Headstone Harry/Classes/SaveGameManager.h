/*
 *  SaveGameManager.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 6/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#include "ArcadeModeSaveInfo.h"
#include "SettingsSaveInfo.h"
#include "ISaveOnTerminate.h"

class SaveGameManager
{
public:
	SaveGameManager();
	virtual ~SaveGameManager();
	
	ArcadeModeSaveInfo *LoadArcadeModeSaveInfo();
	void SaveArcadeModeSaveInfo(ArcadeModeSaveInfo *info);
	
	SettingsSaveInfo *LoadSettingsSaveInfo();
	void SaveSettingsSaveInfo(SettingsSaveInfo *info);
	
	//void SaveOnTerminate();
	//void SetCurrentSaveOnTerminate(ISaveOnTerminate *saveOnTerminate);
	
	void Reset();
	
private:
	//ISaveOnTerminate *m_saveOnTerminate;
};