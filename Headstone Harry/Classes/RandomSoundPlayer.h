/*
 *  RandomSoundPlayer.h
 *  Headstone Harry
 *
 *  Created by Eric Duhon on 10/15/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#pragma once
#include <vector>
#include <tr1/memory>
#include "Sound.h"

namespace CR
{
	namespace Game
	{
		class RandomSoundPlayer
		{
		public:
			void AddSound(CR::Utility::Guid _id);
			void PlaySound();
		private:
			std::vector<std::tr1::shared_ptr<CR::Sound::ISoundFX> > m_sounds;
		};
	}
}
