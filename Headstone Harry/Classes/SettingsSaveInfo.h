/*
 *  SettingsSaveInfo.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 6/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#include "SaveInfo.h"
#include <string>
#import <UIKit/UIKit.h>

class SettingsSaveInfo : public SaveInfo
{
public:
	SettingsSaveInfo();
	virtual ~SettingsSaveInfo();
	
	bool GetOptionsHintsOn() const;
	void SetOptionsHintsOn(bool _value);
	
	bool GetOptionsMusicOn() const;
	void SetOptionsMusicOn(bool _value);
	
	bool GetOptionsSoundOn() const;
	void SetOptionsSoundOn(bool _value);
	
	bool GetEasyAssistOn() const;
	void SetEasyAssistOn(bool _value);
	
	std::string GetDefaultInitials() const;
	void SetDefaultInitials(std::string _value);
	
private:
	NSString* GetDefaultsFilePath();
	NSString* GetSaveFilePath();
};