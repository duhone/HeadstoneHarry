/*
 *  DeviceManager.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 2/14/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#include "Singleton.h"
#include "Event.h"
#include <string>

class DeviceManager : public CR::Utility::Singleton<DeviceManager>
{
public:
	friend class CR::Utility::Singleton<DeviceManager>;
	
	DeviceManager();
	virtual ~DeviceManager();

	void DeviceAwake(bool _awake);
	bool DeviceAwake();
	
	// Events
	//Event DeviceAsleep;
	//Event DeviceAwake;
	
private:
	bool m_awake;
};