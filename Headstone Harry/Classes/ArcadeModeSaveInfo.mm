/*
 *  ArcadeModeSaveInfo.mm
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 6/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "ArcadeModeSaveInfo.h"

ArcadeModeSaveInfo::ArcadeModeSaveInfo()
{
}

ArcadeModeSaveInfo::~ArcadeModeSaveInfo()
{
}

vector<int> ArcadeModeSaveInfo::GetHighScores() const
{
	NSMutableArray *tmp = GetArrayForKey(@"HighScores");
	vector<int> highScores;
	
	for (int i = 0; i < [tmp count]; i++)
	{
		NSNumber *num = [tmp objectAtIndex:i];
		highScores.push_back([num intValue]);
	}
	
	return highScores;
}

void ArcadeModeSaveInfo::SetHighScores(vector<int> scores)
{
	NSMutableArray *tmp = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < scores.size(); i++)
		[tmp addObject: [[NSNumber alloc] initWithInt:scores[i]]];
	
	SetArrayForKey(tmp, @"HighScores");
}

vector<string> ArcadeModeSaveInfo::GetHighScoresInitials() const
{
	NSMutableArray *tmp = GetArrayForKey(@"HighScoresInitials");
	vector<string> initials;
	
	for (int i = 0; i < [tmp count]; i++)
	{
		NSString *str = [tmp objectAtIndex:i];
		initials.push_back([str UTF8String]);
	}
	
	return initials;
}

void ArcadeModeSaveInfo::SetHighScoresInitials(vector<string> initials)
{
	NSMutableArray *tmp = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < initials.size(); i++)
		[tmp addObject: [[NSString alloc] initWithCString:initials[i].c_str()]];
	
	SetArrayForKey(tmp, @"HighScoresInitials");
}


/*
vector<int> ArcadeModeSaveInfo::GetHighScoresLevels() const
{
	NSMutableArray *tmp = GetArrayForKey(@"HighScoresLevels");
	vector<int> levels;
	
	for (int i = 0; i < [tmp count]; i++)
	{
		NSNumber *num = [tmp objectAtIndex:i];
		levels.push_back([num intValue]);
	}
	
	return levels;
}

void ArcadeModeSaveInfo::SetHighScoresLevels(vector<int> levels)
{
	NSMutableArray *tmp = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < levels.size(); i++)
		[tmp addObject: [[NSNumber alloc] initWithInt:levels[i]]];
	
	SetArrayForKey(tmp, @"HighScoresLevels");
}
*/
NSString* ArcadeModeSaveInfo::GetDefaultsFilePath()
{
	return [[NSBundle mainBundle] pathForResource:@"ArcadeModeSaveInfoDefaults" ofType:@"plist"];
}

NSString* ArcadeModeSaveInfo::GetSaveFilePath()
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"ArcadeModeSaveInfo.plist"];
}