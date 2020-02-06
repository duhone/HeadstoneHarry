/*
 *  MatchThreePuzzle.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 5/22/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#include "PuzzleTile.h"
#include "TileSelector.h"
#include "Point.h"
#include "InputEngine.h"
#include "Graphics.h"
#include <queue>
#include <vector>
#include "ParticleSystemManager.h"
#include "CrystalParticleSystem.h"
#include "Event.h"
#include "IRenderable.h"
#include "Point.h"
#include "SpecialSelector.h"
#include "Globals.h"
#include "ChainEffectManager.h"
#include "Sound.h"
#include "MatchTypes.h"

using namespace std;

class MatchThreePuzzle : public Input_Object, public IRenderable
{
public:
	MatchThreePuzzle(int xLoc, int yLoc, int spacing, bool isFreePlay);
	virtual ~MatchThreePuzzle();
	
	// IRenderable
	void Update();
	void Render();
	void SetPosition(float xLoc, float yLoc) {};
	void PauseAnimation(bool pause);

	// Input_Object (Change to Control)
	virtual void TouchesBeganImpl(UIView *view, NSSet *touches);
	virtual void TouchesMovedImpl(UIView *view, NSSet *touches);
	virtual void TouchesEndedImpl(UIView *view, NSSet *touches);
	virtual void TouchesCancelledImpl(UIView *view, NSSet *touches);
	
	// Puzzle Tile Settings
	virtual float Offset_X() const { return offset.X(); }
	virtual float Offset_Y() const { return offset.Y(); }
	virtual float Spacing() const { return tile_spacing; }
	
	// Tiles Manipulation
	PuzzleTile *GetPuzzleTile(int xLoc, int yLoc) const;
	bool CheckAndRemoveTileMatches();
	MatchBounds FindHorizontalMatch(int xLoc, int yLoc);
	MatchBounds FindVerticalMatch(int xLoc, int yLoc);
	void SwapTiles(CR::Math::PointI tile1, CR::Math::PointI tile2);
	bool CanSwapTiles(CR::Math::PointI tile1, CR::Math::PointI tile2);
	void RandomizeTiles();
	void ResetPuzzle();
	void AnimatePuzzleSlideIn();
	bool AnimateShakeTiles(CR::Math::PointI tile1, CR::Math::PointI tile2);
	
	bool IsPuzzleValid();
	bool CheckForLeftMatch(int x, int y, PuzzleTile *rTile);
	bool CheckForRightMatch(int x, int y, PuzzleTile *rTile);
	bool CheckForUpMatch(int x, int y, PuzzleTile *rTile);
	bool CheckForDownMatch(int x, int y, PuzzleTile *rTile);
	bool CheckForMiddleVerticalMatch(int x, int y, PuzzleTile *rTile);
	bool CheckForMiddleHorizontalMatch(int x, int y, PuzzleTile *rTile);
	bool CheckForUpSwapMatch(int x, int y);
	bool CheckForDownSwapMatch(int x, int y);
	bool CheckForLeftSwapMatch(int x, int y);
	bool CheckForRightSwapMatch(int x, int y);
	
	bool IsPuzzleAnimating() const;
	
	void SetDropRateBonusType(TileType rType);
	//void SetBuildingSpecialDown(BuildingName bName, int level);
	//void SetBuildingSpecialUp(BuildingName bName, int level);
	void DoSpecialMove(int x, int y, SpecialMove sMove);
	
	//void DoSpecialMove
	void CancelBuildingSpecial();
	void OnClearBuildingSpecialTiles();
	void OnExplodeTilesSpecial();
	void DropTouchValue() { this->touch = NULL; }
	
	void SetHintsEnabled(bool _value) { hintsEnabled = _value; }
	void SetEasyAssistEnabled(bool _value) { easyAssistEnabled = _value; }
	void FindHintBlock();
	void AnimateHint();
	void QueueEasyAssist();
	void DoEasyAssist();
	void StopAnimateHint();
	void PlayResourceSound(TileType rType);
	
	int ChainCount() const { return chainCount; }
	void StartSuperChargeMode();
	void EndSuperChargeMode();
	bool IsSuperChargeMode() { return m_isSuperChargeMode; }
	
	void StartWildHeartsMode();
	void EndWildHeartsMode();
	bool IsWildHeartsMode() { return m_isWildHeartsMode; }
	
	bool IsFreePlayMode() { return m_isFreePlay; }
	
	void EnableBonusUpAnim(bool _enabled);
	
	// Events ****************************************** //
	Event2<TileType, int> ResourcesRetrieved;
	Event OnIncrementChain;
	Event MoveMade;
	// ************************************************* //
	
	// public constants
	static const int x_tiles = 7;
	static const int y_tiles = 8;
	static const int tiles_required_for_match = 3;

	ParticleSystemManager *particleSystemManager;
private:
	static const float anim_fps;
	bool m_isAnimating;
	float tile_spacing;
	CR::Math::PointF offset;
	PuzzleTile *resourceTiles[x_tiles][y_tiles];
	bool specialClearTiles[x_tiles][y_tiles];
	TileSelector *tileSelector;

	UITouch *touch;
	bool hideTileSelectorAfterAnimation;
	TileType m_dropRateBonusType;
	bool m_buildingSpecialDown;
	SpecialSelector *specialSelector;
	
	bool resettingPuzzle;
	CR::Graphics::Sprite *resetBoardSprite;
	
	float maxHintTime;
	float currHintTime;
	CR::Math::PointI hintOffset;
	bool hintsEnabled;
	bool easyAssistEnabled;
	
	ChainEffectManager *chainManager;
	int chainCount;
	
	bool m_bonusUpAnimEnabled;
	
	bool touchAllowed;
	vector<std::tr1::shared_ptr<CR::Sound::ISoundFX> > sounds;
	vector<std::tr1::shared_ptr<CR::Sound::ISoundFX> > m_genericTileSounds;
	
	// Special Moves
	void SetupCrossClearSpecial(int x, int y);
	bool m_isSpecialMoveActing;
	bool m_isSuperChargeMode;
	bool m_isWildHeartsMode;
	bool m_doEasyAssist;
	bool m_isFreePlay;
};