/*
 *  RandomSoundPlayer.cpp
 *  Headstone Harry
 *
 *  Created by Eric Duhon on 10/15/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "RandomSoundPlayer.h"

using namespace CR::Game;
using namespace CR::Sound;

void RandomSoundPlayer::AddSound(CR::Utility::Guid _id)
{
	m_sounds.push_back(ISound::Instance().CreateSoundFX(_id));
}

void RandomSoundPlayer::PlaySound()
{
	m_sounds[rand() % m_sounds.size()]->Play();
}