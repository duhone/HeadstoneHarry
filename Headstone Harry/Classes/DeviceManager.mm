/*
 *  DeviceManager.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 2/14/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#include "DeviceManager.h"

DeviceManager::DeviceManager()
{
	m_awake = true;
}

DeviceManager::~DeviceManager()
{
}

void DeviceManager::DeviceAwake(bool _awake)
{
	m_awake = _awake;
}

bool DeviceManager::DeviceAwake()
{
	return m_awake;
}