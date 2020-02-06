/*
 *  SettingsSaveInfo.mm
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 6/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "SettingsSaveInfo.h"

using namespace std;

SettingsSaveInfo::SettingsSaveInfo()
{
}

SettingsSaveInfo::~SettingsSaveInfo()
{
}

bool SettingsSaveInfo::GetOptionsHintsOn() const
{
	return GetBoolForKey(@"OptionsHintsOn");
}

void SettingsSaveInfo::SetOptionsHintsOn(bool _value)
{
	SetBoolForKey(_value, @"OptionsHintsOn");
}

bool SettingsSaveInfo::GetOptionsMusicOn() const
{
	return GetBoolForKey(@"OptionsMusicOn");
}

void SettingsSaveInfo::SetOptionsMusicOn(bool _value)
{
	SetBoolForKey(_value, @"OptionsMusicOn");
}

bool SettingsSaveInfo::GetOptionsSoundOn() const
{
	return GetBoolForKey(@"OptionsSoundOn");
}

void SettingsSaveInfo::SetOptionsSoundOn(bool _value)
{
	SetBoolForKey(_value, @"OptionsSoundOn");
}

bool SettingsSaveInfo::GetEasyAssistOn() const
{
	return GetBoolForKey(@"EasyAssistOn");
}

void SettingsSaveInfo::SetEasyAssistOn(bool _value)
{
	SetBoolForKey(_value, @"EasyAssistOn");
}

string SettingsSaveInfo::GetDefaultInitials() const
{
	return GetStringForKey(@"DefaultInitials");
}

void SettingsSaveInfo::SetDefaultInitials(string _value)
{
	SetStringForKey(_value, @"DefaultInitials");
}

NSString* SettingsSaveInfo::GetDefaultsFilePath()
{
	return [[NSBundle mainBundle] pathForResource:@"SettingsSaveInfoDefaults" ofType:@"plist"];
}

NSString* SettingsSaveInfo::GetSaveFilePath()
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"SettingsSaveInfo.plist"];
}