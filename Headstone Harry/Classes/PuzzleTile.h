/*
 *  PuzzleTile.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 5/22/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#include "Graphics.h"
#include "Point.h"
#include <vector>
#include <queue>
#include "IRenderable.h"
#include "SpecialSelector.h"
#include "Globals.h"
#include "Sound.h"
#include "MatchTypes.h"

using namespace std;

class MatchThreePuzzle;

class PuzzleTile: public IRenderable
{
public:
	PuzzleTile(MatchThreePuzzle *parentPuzzle, int xLoc, int yLoc); // initialize with matrix locations
	virtual ~PuzzleTile();
	
	void Update();
	void Render();
	void SetPosition(float xLoc, float yLoc) {};
	void PauseAnimation(bool pause);
	
	void AnimateSlideIn(CR::Math::PointI from_point, CR::Math::PointI to_point, float timeSpan);
	void AnimateSlideTo(CR::Math::PointI to_point, float timeSpan);
	void AnimateShakeTo(AnimationDirection direction, float timeSpan);
	void AnimateSlideToPoint(CR::Math::PointF to_point, float timeSpan);
	void AnimateHint();
	void StopAnimateHint();
	
	void ResetAnimation();
	
	virtual int TilePositionUpToDate() const { return animationStatus == AnimationOff; }
	TileType GetTileType() const { return resourceType; }
	void RandomizeType(TileType dropRateBonusType);

	virtual CR::Math::PointF GetAbsolutePosition() const;
	
	void RenderSelectorSpecial(int _frame);
	void RenderSelectorExplode(int _frame);
	
	// Headstone Harry Stuff:
	void SetTileType(TileType _type);
	bool IsSuperChargedHarry() { return m_isSuperChargedHarry; }
	void MakeSuperChargedHarry();
	
	//bool IsWildHeart() { return m_isWildHeart; }
	//void MakeWildHeart();
	void WildHeart(bool _value);
	bool WildHeart() { return m_isWildHeart; }
	
	static const int tile_width = 44;
	static const int tile_height = 44;
	static const int tile_types = 8;
	
private:
	MatchThreePuzzle *m_parentPuzzle;
	TileType resourceType;
	CR::Math::PointF position;
	
	// Tile Movement Animation
	AnimationStatus animationStatus;
	
	CR::Graphics::Sprite *m_tileSprite;
	CR::Graphics::Sprite *selectorSprite;
	
	CR::Math::PointF finalAnimPoint;
	CR::Math::PointF animDelta;
	float animTotalTime;
	float animTimeLeft;
	
	bool shakeToAnim;
	CR::Math::PointF shakeToStartPoint;
	
	bool m_isSuperChargedHarry;
	bool m_isWildHeart;
	bool m_isAnimatingHint;
	float m_animAngle;
};