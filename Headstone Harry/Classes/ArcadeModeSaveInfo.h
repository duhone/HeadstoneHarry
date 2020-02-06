/*
 *  ArcadeModeSaveInfo.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 6/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#include <vector>
#include <string>
#include "SaveInfo.h"
#import <UIKit/UIKit.h>
using namespace std;

class ArcadeModeSaveInfo : public SaveInfo
{
public:
	ArcadeModeSaveInfo();
	virtual ~ArcadeModeSaveInfo();
	
	vector<int> GetHighScores() const;
	void SetHighScores(vector<int> scores);
	
	vector<string> GetHighScoresInitials() const;
	void SetHighScoresInitials(vector<string> initials);
	
private:
	NSString* GetDefaultsFilePath();
	NSString* GetSaveFilePath();
};