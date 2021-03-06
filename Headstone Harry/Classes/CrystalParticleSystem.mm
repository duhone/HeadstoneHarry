/*
 *  CrystalParticleSystem.mm
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 5/28/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "CrystalParticleSystem.h"

CrystalParticleSystem::CrystalParticleSystem(CR::Math::PointF position, TileType rType)
{
	m_position = position;
	m_life = 100;
	m_isDead = false;
	
	
	// left particles
	for (int i = 0; i < 4; i++)
	{
		float xMod = FloatRand(15.0f);
		float yMod = FloatRand(PuzzleTile::tile_height);
		CR::Math::PointF pnt = CR::Math::PointF(position.X() - (PuzzleTile::tile_width/2) + xMod, position.Y() - (PuzzleTile::tile_height/2) + yMod, 0);
		particles.push_back(new CrystalParticle(pnt, CPStyleLeft, rType));
	}
	
	//right particles
	for (int i = 0; i < 4; i++)
	{
		float xMod = FloatRand(15.0f);
		float yMod = FloatRand(PuzzleTile::tile_height);
		CR::Math::PointF pnt = CR::Math::PointF(position.X() + (PuzzleTile::tile_width/2) - xMod, position.Y() - (PuzzleTile::tile_height/2) + yMod, 0);
		particles.push_back(new CrystalParticle(pnt, CPStyleRight, rType));
	}	
}

CrystalParticleSystem::~CrystalParticleSystem()
{
	for (int i = 0; i < particles.size(); i++)
		delete particles[i];
}

void CrystalParticleSystem::Update()
{
	/*
	if (m_life > 0)
	{
		m_life--;
		
		if (m_life <= 0)
			m_isDead = true;
	}
	*/
	
	if (particles.size() <= 0)
		m_isDead = true;
	for (vector<Particle*>::iterator it = particles.begin(); it != particles.end();)
	{
		(*it)->Update();
		
		if ((*it)->IsDead())
		{
			Particle *tmp = (*it);
			it = particles.erase(it);
			delete (tmp);
		}
		else
			it++;
	}
}

void CrystalParticleSystem::Render()
{
	for (vector<Particle*>::iterator it = particles.begin(); it != particles.end(); it++)
	{
		(*it)->Render();
	}
}

void CrystalParticleSystem::PauseAnimation(bool pause)
{
	for (vector<Particle*>::iterator it = particles.begin(); it != particles.end(); it++)
	{
		(*it)->PauseAnimation(pause);
	}
}