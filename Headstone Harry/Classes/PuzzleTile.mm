/*
 *  PuzzleTile.mm
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 5/22/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "PuzzleTile.h"
#include "Graphics.h"
#include "AssetList.h"
#include "MatchThreePuzzle.h"
#include "Sound.h"
#include "NewAssetList.h"
using namespace CR::Sound;

extern CR::Graphics::GraphicsEngine *graphics_engine;

PuzzleTile::PuzzleTile(MatchThreePuzzle *parentPuzzle, int xLoc, int yLoc) : m_animAngle(0)
{
	m_parentPuzzle = parentPuzzle;
	
	// Generate the tile randomly
	m_tileSprite = graphics_engine->CreateSprite1(true,950);
	m_tileSprite->SetImage(CR::AssetList::Tiles);
	m_tileSprite->SetFrameRate(20);
	RandomizeType(NoTile);

	this->position.X(xLoc * tile_width + tile_width/2 + (xLoc * m_parentPuzzle->Spacing()) + m_parentPuzzle->Offset_X());
	this->position.Y(yLoc * tile_height + tile_height/2 + (yLoc * m_parentPuzzle->Spacing()) + m_parentPuzzle->Offset_Y());
	m_tileSprite->SetPositionAbsolute(position.X(), position.Y());
	
	animationStatus = AnimationOff;
	
	selectorSprite = graphics_engine->CreateSprite1(true,800);
	selectorSprite->SetImage(CR::AssetList::Selector_2);
	shakeToAnim = false;
	m_isSuperChargedHarry = false;
	m_isAnimatingHint = false;
	m_isWildHeart = false;
}

PuzzleTile::~PuzzleTile()
{
	this->m_tileSprite->Release();
	selectorSprite->Release();
}

void PuzzleTile::Update()
{	
	float timePassed = Globals::Instance().GetTimer()->GetLastFrameTime();
	if (animationStatus == AnimationOn)
	{
		animTimeLeft -= timePassed;		
		
		float deltaPerc = animTimeLeft / animTotalTime;
		
		this->position.X(finalAnimPoint.X() - animDelta.X() * deltaPerc);
		this->position.Y(finalAnimPoint.Y() - animDelta.Y() * deltaPerc);
		
		m_tileSprite->SetPositionAbsolute(position.X(), position.Y());
		
		
		if (animTimeLeft <= 0)
		{
			this->position.X(finalAnimPoint.X());
			this->position.Y(finalAnimPoint.Y());
			m_tileSprite->SetPositionAbsolute(finalAnimPoint.X(), finalAnimPoint.Y());
			animationStatus = AnimationOff;
			
			if (shakeToAnim)
			{
				shakeToAnim = false;
				AnimateSlideToPoint(shakeToStartPoint, animTotalTime);
			}
		}
	}

	if(m_isAnimatingHint)
	{
		/*if(resourceType == SkullTileA && m_isSuperChargedHarry)
		{
			if (!m_tileSprite->IsAnimating())
			{
				StopAnimateHint();
				m_parentPuzzle->QueueEasyAssist();
			}
		}
		else
		{*/
			m_animAngle += timePassed*4.0f;
			if(m_animAngle > 6.48f)
			{
				StopAnimateHint();
				m_parentPuzzle->QueueEasyAssist();
			}
		//}
	}
	/*if (!m_tileSprite->IsAnimating() && m_isAnimatingHint)
	{
		StopAnimateHint();
	}*/
}

void PuzzleTile::AnimateSlideTo(CR::Math::PointI to_point, float timeSpan)
{
	if (animationStatus == AnimationOn)
		return;
	
	StopAnimateHint();
	
	animTotalTime = timeSpan;
	animTimeLeft = animTotalTime;
	
	CR::Math::PointF newPosition;
	newPosition.X(to_point.X() * tile_width + tile_width/2 + (to_point.X() * m_parentPuzzle->Spacing()) + m_parentPuzzle->Offset_X());
	newPosition.Y(to_point.Y() * tile_height + tile_height/2 + (to_point.Y() * m_parentPuzzle->Spacing()) + m_parentPuzzle->Offset_Y());
	finalAnimPoint = newPosition;
	animDelta.X(newPosition.X() - position.X());
	animDelta.Y(newPosition.Y() - position.Y());
	
	animationStatus = AnimationOn;
}

void PuzzleTile::AnimateSlideIn(CR::Math::PointI from_point, CR::Math::PointI to_point, float timeSpan)
{
	this->position.X(from_point.X() * tile_width + tile_width/2 + (from_point.X() * m_parentPuzzle->Spacing()) + m_parentPuzzle->Offset_X());
	this->position.Y(from_point.Y() * tile_height + tile_height/2 + (from_point.Y() * m_parentPuzzle->Spacing()) + m_parentPuzzle->Offset_Y());
	m_tileSprite->SetPositionAbsolute(position.X(), position.Y());
	AnimateSlideTo(to_point, timeSpan);
}

void PuzzleTile::AnimateShakeTo(AnimationDirection direction, float timeSpan)
{
	if (animationStatus == AnimationOn)
		return;
	
	StopAnimateHint();
	
	CR::Math::PointF currPos = this->position;
	CR::Math::PointF newPosition;
	
	shakeToStartPoint.X(position.X());
	shakeToStartPoint.Y(position.Y());
	
	switch (direction)
	{
		case AnimateUp:
			newPosition.X(currPos.X());
			newPosition.Y(currPos.Y() - tile_width/2 - m_parentPuzzle->Spacing());
			break;
		case AnimateDown:
			newPosition.X(currPos.X());
			newPosition.Y(currPos.Y() + tile_width/2 + m_parentPuzzle->Spacing());
			break;
		case AnimateLeft:
			newPosition.X(currPos.X() - tile_height/2 - m_parentPuzzle->Spacing());
			newPosition.Y(currPos.Y());
			break;
		case AnimateRight:
			newPosition.X(currPos.X() + tile_height/2 + m_parentPuzzle->Spacing());
			newPosition.Y(currPos.Y());
			break;
		default:
			break;
	}
	
	shakeToAnim = true;
	AnimateSlideToPoint(newPosition, timeSpan/2.0f);
}

void PuzzleTile::AnimateSlideToPoint(CR::Math::PointF to_point, float timeSpan)
{
	if (animationStatus == AnimationOn)
		return;
	
	StopAnimateHint();
	
	animTotalTime = timeSpan;
	animTimeLeft = animTotalTime;
	
	finalAnimPoint = to_point;
	animDelta.X(to_point.X() - position.X());
	animDelta.Y(to_point.Y() - position.Y());
	
	animationStatus = AnimationOn;
}

void PuzzleTile::AnimateHint()
{
	/*if (resourceType == SkullTileA && m_isSuperChargedHarry)
	{
		m_tileSprite->SetImage(CR::AssetList::Tiles_SkullC);
		m_tileSprite->SetAutoAnimate(true);
		m_tileSprite->AutoStopAnimate();
	}
	else //if (resourceType == BonusTile)
	{*/
		m_animAngle = -0.2f;
		//m_tileSprite->SetImage(CR::AssetList::Tiles_BonusB);
		//m_tileSprite->SetAutoAnimate(true);
		//m_tileSprite->AutoStopAnimate();		
	//}
	
	//m_tileSprite->SetAutoAnimate(true);
	//m_tileSprite->AutoStopAnimate();
	m_isAnimatingHint = true;
}

void PuzzleTile::StopAnimateHint()
{
	/*if (resourceType == SkullTileA && m_isSuperChargedHarry)
	{
		m_tileSprite->SetImage(CR::AssetList::Tiles_SkullB);
		m_tileSprite->SetFrame(0);
	}
	else //if (resourceType == BonusTile)
	{
		//m_tileSprite->SetImage(CR::AssetList::Tiles_BonusA);
		//m_tileSprite->SetFrame(0);
	}*/
	//else 
	//{
		//m_tileSprite->SetAutoAnimate(false);		
	//}
	
	m_animAngle = 0;
	m_tileSprite->RotateZ(m_animAngle);
	//m_tileSprite->SetFrame(0);
	m_isAnimatingHint = false;
}

void PuzzleTile::ResetAnimation()
{
	if (animationStatus == AnimationOn)
	{
		this->position.X(finalAnimPoint.X());
		this->position.Y(finalAnimPoint.Y());
		m_tileSprite->SetPositionAbsolute(finalAnimPoint.X(), finalAnimPoint.Y());
		
		animationStatus = AnimationOff;
	}
}

void PuzzleTile::Render()
{
	if(m_isAnimatingHint /*&& !(resourceType == SkullTileA && m_isSuperChargedHarry/* || resourceType == BonusTile)*/)
	{
		m_tileSprite->RotateZ(m_animAngle);
	}
	m_tileSprite->Render();
}

void PuzzleTile::PauseAnimation(bool pause)
{
	m_tileSprite->PauseAnimation(pause);
}

CR::Math::PointF PuzzleTile::GetAbsolutePosition() const
{
	return position;
}

void PuzzleTile::RenderSelectorSpecial(int _frame)
{
	//if (selectorSprite->GetImage() != CR::AssetList::Selector_2)
		selectorSprite->SetImage(CR::AssetList::Selector_2);
	
	selectorSprite->SetFrame(_frame);
	selectorSprite->SetPositionAbsolute(position.X(), position.Y());
	selectorSprite->SetAutoAnimate(false);
	selectorSprite->Render();
}

void PuzzleTile::RenderSelectorExplode(int _frame)
{
	//if (selectorSprite->GetImage() != CR::AssetList::Selector_3)
		selectorSprite->SetImage(CR::AssetList::Selector_3);
	
	selectorSprite->SetFrame(_frame);
	selectorSprite->SetPositionAbsolute(position.X(), position.Y());
	selectorSprite->SetAutoAnimate(false);
	selectorSprite->Render();
}

void PuzzleTile::RandomizeType(TileType dropRateBonusType)
{		
	// TODO: Change this hoopty code to not happen here for speed purposes
	//int dropRates[8] = { 16, 32, 48, 64, 80, 96, 98, 100 };
	int dropRates[8] = { 16, 32, 48, 64, 80, 96, 98, 100 };
	
	if (dropRateBonusType != NoTile)
	{
		int pCount = 0;
		for (int i = 0; i < 6; i++)
		{
			if (i == (int)dropRateBonusType)
				pCount += 21;
			else
				pCount += 15;
			
			dropRates[i] = pCount;
		}
	}
	
	int dropPercent = 0;
	
	if (m_parentPuzzle->IsFreePlayMode())
	{
		dropPercent = (rand() % 98); // 0 to 97
	}
	else {
		dropPercent = (rand() % 101); // 0 to 100
		//dropPercent = (rand() % 100); // 0 to 99 TODO: Hack makes the drop % for bonus 1%
	}

	
	for (int i = 0; i < 8; i++)
	{
		if (dropPercent <= dropRates[i])
		{
			SetTileType((TileType)i);
			
			if (m_parentPuzzle->IsWildHeartsMode())
			{
				if (resourceType == HeartTile)
					WildHeart(true);
				else {
					m_isWildHeart = false;
				}

			}
			
			break;
		}
	}
}

void PuzzleTile::SetTileType(TileType _type)
{
	resourceType = (TileType) _type;
	m_isSuperChargedHarry = false;
	int dropPercent = 0;
	
	// Switch back to the normals tiles image for non-skull tiles
	if (_type != SkullTileA)
		m_tileSprite->SetImage(CR::AssetList::Tiles);
	
	switch (_type)
	{
		case BassTile:
			m_tileSprite->SetFrame(3);
			//m_tileSprite->SetImage(CR::AssetList::Tiles_Bass);			
			break;
		case BoneTile:
			m_tileSprite->SetFrame(0);
			//m_tileSprite->SetImage(CR::AssetList::Tiles_Bone);			
			break;
		case HandTile:
			m_tileSprite->SetFrame(1);
			//m_tileSprite->SetImage(CR::AssetList::Tiles_Hand);			
			break;
		case HeartTile:
			m_tileSprite->SetFrame(2);
			//m_tileSprite->SetImage(CR::AssetList::Tiles_Heart);			
			break;
		case TrumpetTile:
			m_tileSprite->SetFrame(4);
			//m_tileSprite->SetImage(CR::AssetList::Tiles_Trumpet);			
			break;
		case SkullTileA:
			//Randomly determine if this skull tile is supercharged
			dropPercent = (rand() % 101); // 0 to 100
			if (dropPercent < 10 || m_parentPuzzle->IsSuperChargeMode()) // %10 drop rate for supercharged harry
			{
				m_isSuperChargedHarry = true;
				m_tileSprite->SetImage(CR::AssetList::Tiles_SkullB);
			}
			else 
			{
				m_tileSprite->SetImage(CR::AssetList::Tiles);
				m_tileSprite->SetFrame(5);
			}

			break;
		case WildTile:
			m_tileSprite->SetFrame(6);
			//m_tileSprite->SetImage(CR::AssetList::Tiles_Wild);			
			break;
		case BonusTile:
			m_tileSprite->SetFrame(7);
			//m_tileSprite->SetImage(CR::AssetList::Tiles_BonusA);			
			break;
		case NoTile:
		default:
			//m_tileSprite->SetImage(CR::AssetList::Tiles_Bass);
			break;
	}
}

void PuzzleTile::MakeSuperChargedHarry()
{
	m_isSuperChargedHarry = true;
	m_tileSprite->SetImage(CR::AssetList::Tiles_SkullB);
}

void PuzzleTile::WildHeart(bool _value)
{	
	m_isWildHeart = _value;
	
	if (m_isWildHeart)
	{
		resourceType = WildTile;
		m_tileSprite->SetImage(CR::AssetList::Wild_Heart_Tile);
		m_tileSprite->SetFrame(0);
	}
	else
	{
		resourceType = HeartTile;
		m_tileSprite->SetImage(CR::AssetList::Tiles);
		m_tileSprite->SetFrame(2);
	}
}