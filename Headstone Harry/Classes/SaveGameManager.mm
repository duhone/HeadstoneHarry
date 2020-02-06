/*
 *  SaveGameManager.mm
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 6/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "SaveGameManager.h"

SaveGameManager::SaveGameManager()
{
	//m_saveOnTerminate = NULL;
}

SaveGameManager::~SaveGameManager()
{
}

ArcadeModeSaveInfo *SaveGameManager::LoadArcadeModeSaveInfo()
{
	ArcadeModeSaveInfo *info = new ArcadeModeSaveInfo();
	info->Load();
	return info;
}

void SaveGameManager::SaveArcadeModeSaveInfo(ArcadeModeSaveInfo *info)
{
	info->Save();
}

SettingsSaveInfo *SaveGameManager::LoadSettingsSaveInfo()
{
	SettingsSaveInfo *info = new SettingsSaveInfo();
	info->Load();
	return info;
}

void SaveGameManager::SaveSettingsSaveInfo(SettingsSaveInfo *info)
{
	info->Save();
}

/*
void SaveGameManager::SaveOnTerminate()
{
	if (m_saveOnTerminate != NULL)
		m_saveOnTerminate->OnSaveOnTerminate();
}

void SaveGameManager::SetCurrentSaveOnTerminate(ISaveOnTerminate *saveOnTerminate)
{
	m_saveOnTerminate = saveOnTerminate;
}
*/

void SaveGameManager::Reset()
{
	LoadArcadeModeSaveInfo()->Reset();
	LoadSettingsSaveInfo()->Reset();
}