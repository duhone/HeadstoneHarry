/*
 *  Game.mm
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 5/21/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "Game.h"
#include "Graphics.h"
#include "Globals.h"
#include "Database.h"
#include "StringUtil.h"
#include <string>
#include "Sound.h"
#include "NewAssetList.h"
#include "AssetList.h"
//#include "ArcadeModeGameState.h"
#include "ArcadeModeController.h"
#include "LoadingScreenController.h"
#include "FreePlayModeController.h"
#include "DeviceManager.h"

using namespace std;
using namespace CR::Utility;
using namespace CR::Database;
using namespace CR::Sound;
using namespace CR::Input;

CR::Graphics::GraphicsEngine *graphics_engine = 0;
InputEngine *input_engine = 0;

SaveGameManager *saveGameManager = 0;
SettingsSaveInfo *settingsSaveInfo = 0;
ArcadeModeSaveInfo *arcadeModeSaveInfo = 0;

Game::Game()
{

}

Game::~Game()
{
	m_database->Release();
}

void Game::Initialize()
{
	srand(time(NULL));
	graphics_engine = GetGraphicsEngine();
	graphics_engine->SetBackgroundColor(0, 0, 0);
	
	graphics_engine->ShowFPS(false);
	graphics_engine->ShowSceneGraphCount(false);
	
	//saveGameManager = new SaveGameManager();
	
	// load the main graphics file
	NSString *path = [[NSBundle mainBundle] pathForResource: @"main" ofType: @"hgf"];
	const char *mainhgf = [path UTF8String];
	graphics_engine->LoadHGF(const_cast<char*>(mainhgf));
		
	m_splash = graphics_engine->CreateSprite1(false,1000);
	m_splash->SetImage(CR::AssetList::Splash_Screen_1);
	m_splash->SetPositionAbsolute(160, 240);
		
	hack = 0;
	// load the database
	/*NSString *dbpath = [[NSBundle mainBundle] pathForResource: @"data" ofType: @"edf"];
	const char *dbFile = [dbpath UTF8String];
	string dbFilemb(dbFile);
	Convert converter;
	wstring dbFilewc = converter(dbFilemb);
	m_database = DatabaseFactory::Instance().CreateDatabase(dbFilewc);
	
	ISound::Instance().SetDatabase(m_database);
	settingsSaveInfo = saveGameManager->LoadSettingsSaveInfo();
	ISound::Instance().MuteMusic(!settingsSaveInfo->GetOptionsMusicOn());
	ISound::Instance().MuteSounds(!settingsSaveInfo->GetOptionsSoundOn());
	
	arcadeModeSaveInfo = saveGameManager->LoadArcadeModeSaveInfo();
	
	gameStateMachine << new LoadingScreenController(CR::AssetList::Splash_Screen_1, 0, 1) << new MainMenuController() 
					 << new LoadingScreenController(CR::AssetList::Loading_1, 0, 3) << new ArcadeModeController() 
					 << new LoadingScreenController(CR::AssetList::Loading_1, 0,1)
					 << new LoadingScreenController(CR::AssetList::Loading_1, 0, 6) << new FreePlayModeController();
	gameStateMachine.State = MAIN_MENU_STATE;*/	
	
}

void Game::Execute()
{	
	if (!DeviceManager::Instance().DeviceAwake())
	{
		Globals::Instance().Update();
		return;
	}
	
	if(hack == 0)
	{		
		graphics_engine->BeginFrame();
		m_splash->Render();
		graphics_engine->EndFrame();	
		hack++;	
	}
	else if(hack == 1)
	{
		
		m_splash->Release();
		m_splash = NULL;
		
		saveGameManager = new SaveGameManager();
		
		// load the database
		NSString *dbpath = [[NSBundle mainBundle] pathForResource: @"data" ofType: @"edf"];
		const char *dbFile = [dbpath UTF8String];
		string dbFilemb(dbFile);
		Convert converter;
		wstring dbFilewc = converter(dbFilemb);
		m_database = DatabaseFactory::Instance().CreateDatabase(dbFilewc);
		
		ISound::Instance().SetDatabase(m_database);
		settingsSaveInfo = saveGameManager->LoadSettingsSaveInfo();
		ISound::Instance().MuteMusic(!settingsSaveInfo->GetOptionsMusicOn());
		ISound::Instance().MuteSounds(!settingsSaveInfo->GetOptionsSoundOn());
		
		arcadeModeSaveInfo = saveGameManager->LoadArcadeModeSaveInfo();
		
		gameStateMachine << new LoadingScreenController(CR::AssetList::Splash_Screen_1, 0, 1) << new MainMenuController() 
		<< new LoadingScreenController(CR::AssetList::Loading_1, 0, 3) << new ArcadeModeController() 
		<< new LoadingScreenController(CR::AssetList::Loading_1, 0,1)
		<< new LoadingScreenController(CR::AssetList::Loading_1, 0, 6) << new FreePlayModeController();
		gameStateMachine.State = MAIN_MENU_STATE;	
		
		hack++;
	}
	else
	{
		gameStateMachine();
		Globals::Instance().Update();
		ISound::Instance().Tick();
	}
}

void Game::ApplicationTerminated()
{
	saveGameManager->SaveSettingsSaveInfo(settingsSaveInfo);
	saveGameManager->SaveArcadeModeSaveInfo(arcadeModeSaveInfo);
}
