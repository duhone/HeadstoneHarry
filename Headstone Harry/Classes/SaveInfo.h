/*
 *  SaveInfo.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 6/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#include <string>
#import <UIKit/UIKit.h>

class SaveInfo
{
public:
	friend class SaveGameManager;
	
	SaveInfo();
	virtual ~SaveInfo();

protected:
	NSMutableDictionary *saveData;
	
	int GetIntForKey(NSString *key) const;
	void SetIntForKey(int _value, NSString *key);
	
	bool GetBoolForKey(NSString *key) const;
	void SetBoolForKey(bool _value, NSString *key);
	
	std::string GetStringForKey(NSString *key) const;
	void SetStringForKey(std::string _value, NSString *key);
	
	NSMutableDictionary *GetDictionaryForKey(NSString *key) const;
	void SetDictionaryForKey(NSMutableDictionary *dict, NSString *key);
	
	NSMutableArray *GetArrayForKey(NSString *key) const;
	void SetArrayForKey(NSMutableArray *array, NSString *key);
	
	virtual NSString* GetDefaultsFilePath() = 0;
	virtual NSString* GetSaveFilePath() = 0;
	
	void Save();
	void Load();
	void Reset();
};