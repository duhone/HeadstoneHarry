/*
 *  Game.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 5/21/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#import <Foundation/Foundation.h>
#include "InputEngine.h"
#include "MainMenuController.h"
#include <vector>
#include <stack>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include "SaveGameManager.h"
#include "Databasefwd.h"
#include "Graphics.h"

using namespace std;

#define MAIN_MENU_STATE 0
#define ARCADE_MODE_STATE 1

class Game
	{
	public:
		Game();
		virtual ~Game();
		
		void Initialize();
		void Execute();
		void ApplicationTerminated();
		
	private:
		CR::Utility::FSM gameStateMachine;
		CR::Database::IDatabase *m_database;
		CR::Graphics::Sprite *m_splash;
		int hack;
	};