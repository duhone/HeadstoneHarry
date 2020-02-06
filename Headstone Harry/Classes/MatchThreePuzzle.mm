/*
 *  MatchThreePuzzle.mm
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 5/22/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "MatchThreePuzzle.h"
#include "AssetList.h"
#include "Sound.h"
#include "NewAssetList.h"

using namespace CR::Sound;

extern CR::Graphics::GraphicsEngine *graphics_engine;

const float MatchThreePuzzle::anim_fps = 0.15f;

MatchThreePuzzle::MatchThreePuzzle(int xLoc, int yLoc, int spacing, bool isFreePlay)
{
	m_isFreePlay = isFreePlay;
	m_doEasyAssist = false;
	maxHintTime = 10;
	currHintTime = maxHintTime;
	hintOffset.X(0);
	hintOffset.Y(0);
	hintsEnabled = true;
	easyAssistEnabled = false;
	chainManager = new ChainEffectManager();
	chainCount = 0;
	particleSystemManager = new ParticleSystemManager();
	tile_spacing = spacing;
	offset = CR::Math::PointF(xLoc, yLoc, 0);
	tileSelector = new TileSelector(this);
	tileSelector->SetVisible(false);
	m_isAnimating = false;
	m_isSuperChargeMode = false;
	m_isWildHeartsMode = false;
	m_bonusUpAnimEnabled = false;
	// initialize the puzzle with tiles
	//for (int y = 0; y < y_tiles; y++)
	//{
	//	for (int x = 0; x < x_tiles; x++)
	//	{
	//		PuzzleTile *tmpTile = new PuzzleTile(this, x, y);
	//		resourceTiles[x][y] = tmpTile;
			
			// initialize the special clear tiles with false
	//		specialClearTiles[x][y] = false;
	//	}
	//}
	
	// init puzzle tiles to null so they get generated in resetpuzzle()
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			resourceTiles[x][y] = NULL;
		}
	}
	
	
	touch = NULL;
	hideTileSelectorAfterAnimation = false;
	m_dropRateBonusType = NoTile;
	m_buildingSpecialDown = false;
	specialSelector = new SpecialSelector(this);
	specialSelector->OnDoneAnimating += Delegate(this, &MatchThreePuzzle::OnClearBuildingSpecialTiles);
	specialSelector->OnExplodeTiles += Delegate(this, &MatchThreePuzzle::OnExplodeTilesSpecial);
	ResetPuzzle(); // make sure there are no matches in initial puzzle
	resetBoardSprite = graphics_engine->CreateSprite1(false, 750);
	resetBoardSprite->SetImage(CR::AssetList::No_Moves_Cover);
	resetBoardSprite->SetPositionAbsolute(160, 265);
	resettingPuzzle = false;

	touchAllowed = true;
	m_isSpecialMoveActing = false;
	
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_bass::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_bone::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_hand::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_heart::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_trumpet::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_skull1::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_skull2::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_skull3::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_skull4::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_skull5::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_skull6::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_skull7::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_skull8::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo1::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo2::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo3::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo4::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo5::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo6::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo7::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo8::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo9::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::combo10::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_supercharge::ID)); //23
	
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic1::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic2::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic3::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic4::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic5::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic6::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic7::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic8::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic9::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic10::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic11::ID));
	m_genericTileSounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_generic12::ID));
	
}

MatchThreePuzzle::~MatchThreePuzzle()
{
	delete chainManager;
	delete particleSystemManager;
	delete tileSelector;
	resetBoardSprite->Release();
	
	// delete all tiles in the matrix from memory
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			PuzzleTile *tmpTile = GetPuzzleTile(x, y);
			delete tmpTile;
			resourceTiles[x][y] = NULL;
		}
	}
}

void MatchThreePuzzle::Update()
{
	bool isAnimating = false;
	tileSelector->Update();
	specialSelector->Update();
	particleSystemManager->Update();
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			if (resourceTiles[x][y] != NULL)
			{
				//if (!resourceTiles[x][y]->TilePositionUpToDate())
				//	isAnimating = true;
				
				if (!resourceTiles[x][y]->TilePositionUpToDate())
					isAnimating = true;
				
				resourceTiles[x][y]->Update();
			}
		}
	}
	
	m_isAnimating = isAnimating;
	
	if (!isAnimating)
	{
		resettingPuzzle = false;
		bool foundMatch = CheckAndRemoveTileMatches();
		// if a match was found, the puzzle is going into an animated state
		if (foundMatch)
			m_isAnimating = true;
		
		// only check if the puzzle is valid if a match has not been found
		if (!foundMatch && !m_buildingSpecialDown && !IsPuzzleValid())
		{
			// Puzzle is not in a valid state, tell user, then shuffle
			ResetPuzzle();
			AnimatePuzzleSlideIn();
		}
		else if (foundMatch)
		{
			FindHintBlock();
			currHintTime = maxHintTime;
		}
	}
	
	if (!m_isAnimating && hideTileSelectorAfterAnimation)
	{
		hideTileSelectorAfterAnimation = false;
		tileSelector->SetVisible(false);
	}
	
	if (!m_isAnimating && !m_isSpecialMoveActing)
	{
		//FindHintBlock();
		chainCount = 0;
		touchAllowed = true;
	}
	
	// Hints
	if (!hintsEnabled && easyAssistEnabled)
	{
		currHintTime -= Globals::Instance().GetTimer()->GetLastFrameTime();
		
		if (currHintTime <= 0)
		{
			//AnimateHint();
			DoEasyAssist();
			currHintTime = maxHintTime;
		}
	}
	else if (hintsEnabled)
	{
		currHintTime -= Globals::Instance().GetTimer()->GetLastFrameTime();
		
		if (currHintTime <= 0)
		{
			//DoEasyAssist();
			AnimateHint();
			currHintTime = maxHintTime;
		}
	}
	
	if (m_doEasyAssist)
	{
		m_doEasyAssist = false;
		DoEasyAssist();
	}
	
	//else if (easyAssistEnabled)
	//{
	//	DoEasyAssist();
	//}
	
	chainManager->Update();
}

void MatchThreePuzzle::Render()
{	
	if (resettingPuzzle)
		resetBoardSprite->Render();
	
	//graphics_engine->SetClipper(offset.X(), offset.Y(), 320, 340);
	
	// render the tiles
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			if (resourceTiles[x][y] != NULL)
			{
				if (specialSelector->IsSelector3() && specialSelector->HideTiles())
				{
					if (!specialClearTiles[x][y])
					{
						resourceTiles[x][y]->Render();
					}
				}
				else
					resourceTiles[x][y]->Render();
			}
		}
	}
	
	// render the tile selector
	tileSelector->Render();
	bool specialSelectorRendered = false;
	
	// render special tile selector
	if (m_buildingSpecialDown)
	{
		for (int y = 0; y < y_tiles; y++)
		{
			for (int x = 0; x < x_tiles; x++)
			{
				if (specialClearTiles[x][y] == true)
				{
					specialSelector->SetTilePosition(x, y);
					//specialSelector->Render();
					
					if (specialSelector->IsSelector3())
						resourceTiles[x][y]->RenderSelectorExplode(specialSelector->GetCurrFrame());
					else
						resourceTiles[x][y]->RenderSelectorSpecial(specialSelector->GetCurrFrame());						
					
					specialSelectorRendered = true;
				}
			}
		}
	}
	
	if (!specialSelectorRendered)
		specialSelector->ShowSelector2();
	
	//graphics_engine->ClearClipper();
	
	particleSystemManager->Render();
	chainManager->Render();
}

void MatchThreePuzzle::PauseAnimation(bool pause)
{
	tileSelector->PauseAnimation(pause);
	particleSystemManager->PauseAnimation(pause);
	specialSelector->PauseAnimation(pause);
	
	
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			PuzzleTile *tmpTile = GetPuzzleTile(x, y);
			
			if (tmpTile != NULL)
				tmpTile->PauseAnimation(pause);
		}
	}
}

void MatchThreePuzzle::ResetPuzzle()
{
	// finish all animations: (didn't work)
	//for (int x = 0; x < x_tiles; x++)
	//{
	//	for (int y = 0; y < y_tiles; y++)
	//	{
	//		GetPuzzleTile(x, y)->ResetAnimation();
	//	}
	//}
	
	// reset all flags
	m_buildingSpecialDown = false;
	m_isSpecialMoveActing = false;
	
	
	specialSelector->ShowSelector2();
	
	// initialize the puzzle with tiles
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			if (resourceTiles[x][y] != NULL)
				delete resourceTiles[x][y];
			
			PuzzleTile *tmpTile = new PuzzleTile(this, x, y);
			resourceTiles[x][y] = tmpTile;
			
			// initialize the special clear tiles with false
			specialClearTiles[x][y] = false;
		}
	}
	
	
	bool hasMatches = true;
	
	RandomizeTiles();
	
	while (hasMatches)
	{
		hasMatches = false;
		for (int y = 0; y < y_tiles; y++)
		{
			for (int x = 0; x < x_tiles; x++)
			{
				MatchBounds hMatch = FindHorizontalMatch(x, y);
				MatchBounds vMatch = FindVerticalMatch(x, y);
				
				if (hMatch.foundMatch)
				{
					hasMatches = true;
					for (int i = hMatch.lower; i <= hMatch.upper; i++)
						GetPuzzleTile(i, y)->RandomizeType(m_dropRateBonusType);
				}
				
				if (vMatch.foundMatch)
				{
					hasMatches = true;
					for (int i = vMatch.lower; i <= vMatch.upper; i++)
						GetPuzzleTile(x, i)->RandomizeType(m_dropRateBonusType);
				}
			}
		}
		
		if (!IsPuzzleValid())
		{
			hasMatches = true;
			RandomizeTiles();
		}
		//else
		//{
		//	FindHintBlock();
		//}
	}
	
	FindHintBlock();
}

void MatchThreePuzzle::AnimatePuzzleSlideIn()
{
	//std::tr1::shared_ptr<CR::Sound::ISoundFX> sound;
	//sound = ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_bass::ID);
	//sound->Play();
	
	resettingPuzzle = true;
	
	for (int x = 0; x < x_tiles; x++)
	{
		for (int y = 0; y < y_tiles; y++)
		{
			// determine points for slide in animation
			CR::Math::PointI fromPoint = CR::Math::PointI(x, y - y_tiles, 0); // from_point
			CR::Math::PointI tilePoint = CR::Math::PointI(x, y, 0); // to_point
			
			GetPuzzleTile(x, y)->AnimateSlideIn(fromPoint, tilePoint, anim_fps * y_tiles);
		}
	}
}

// returns true if a shake took place
bool MatchThreePuzzle::AnimateShakeTiles(CR::Math::PointI tile1, CR::Math::PointI tile2)
{
	// if the tiles are not within 1 of eachother, or are diagonal from eachother, return without shaking them
	int xDiff = tile1.X() - tile2.X();
	int yDiff = tile1.Y() - tile2.Y();
	int absXDiff = abs(xDiff);
	int absYDiff = abs(yDiff);
	if ( (absXDiff > 1) || (absYDiff > 1) || (absXDiff == 1 && absYDiff == 1) )
		return false;
	
	if (xDiff == -1)
		GetPuzzleTile(tile1.X(), tile1.Y())->AnimateShakeTo(AnimateRight, anim_fps);
	else if (xDiff == 1)
		GetPuzzleTile(tile1.X(), tile1.Y())->AnimateShakeTo(AnimateLeft, anim_fps);
	else if (yDiff == -1)
		GetPuzzleTile(tile1.X(), tile1.Y())->AnimateShakeTo(AnimateDown, anim_fps);
	else if (yDiff == 1)
		GetPuzzleTile(tile1.X(), tile1.Y())->AnimateShakeTo(AnimateUp, anim_fps);
	
	//int isnd = 19 + (rand() & 1);
	//sounds[isnd]->Play();
	m_genericTileSounds[1]->Play();
	
	return true;
}

bool MatchThreePuzzle::CheckAndRemoveTileMatches()
{
	if (m_isSpecialMoveActing) return false;
	
	vector<MatchBounds> matches;
	queue<PuzzleTile*> tileQueue; // tiles removed from puzzle that can be reused as new tiles
	int resourceCount[PuzzleTile::tile_types];// resources receieved through matches
	for (int i = 0; i < PuzzleTile::tile_types; i++)
		resourceCount[i] = 0;
	
	bool foundMatch = false;
	
	// storage for the number of null tiles in each column
	int nullTiles[x_tiles];
	for (int i = 0; i < x_tiles; i++)
		nullTiles[i] = 0;
	
	// Remove all match tiles and add them to the tileQueue for reuse
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			MatchBounds hMatch = FindHorizontalMatch(x, y);
			MatchBounds vMatch = FindVerticalMatch(x, y);
			
			// Horizontal Matches
			if (hMatch.foundMatch)
			{
				foundMatch = true;
				matches.push_back(hMatch);
			}
			
			// Vertical Matches
			if (vMatch.foundMatch)
			{
				foundMatch = true;
				matches.push_back(vMatch);
			}
		}
	}
	
	// if a match was not found, there is no need to continue
	if (!foundMatch)
		return false;
	
	// Check to see if there was a special power tile, if so, run it's special instead of clearing tiles
	bool foundSpecial = false;
	for (int i = 0; i < matches.size(); i++)
	{
		// Horizontal Check
		if (matches[i].orientation == HorizontalMatch)
		{
			for (int j = matches[i].lower; j <= matches[i].upper; j++)
			{
				PuzzleTile *resourceTile = GetPuzzleTile(j, matches[i].y);
				if (resourceTile->GetTileType() == SkullTileA && resourceTile->IsSuperChargedHarry())
				{
					DoSpecialMove(j, matches[i].y, CrossClearSpecial);
					foundSpecial = true;
				}
			}
		}
		else if (matches[i].orientation == VerticalMatch)
		{
			for (int j = matches[i].lower; j <= matches[i].upper; j++)
			{
				PuzzleTile *resourceTile = GetPuzzleTile(matches[i].x, j);
				if (resourceTile->GetTileType() == SkullTileA && resourceTile->IsSuperChargedHarry())
				{
					DoSpecialMove(matches[i].x, j, CrossClearSpecial);
					foundSpecial = true;
				}
			}
		}
	}
	
	// if a special was found, run it instead of clearing tiles
	if (foundSpecial)
	{
		//tileSelector->SetVisible(false);
		return false;
	}
	
	// remove all matches found
	bool removedMatch = false;
	
	//bool chainPositionSet = false;
	bool isChain = true;
	int xChainPos = 0;
	int yChainPos = 0;
	bool playedSound = false;
	
	for (int j = 0; j < matches.size(); j++)
	{
		MatchBounds match = matches[j];
		if (match.orientation == HorizontalMatch)
		{
			isChain = true;
			//isChain = (match.upper - match.lower) >= 2;
			if (resourceTiles[(match.lower + match.upper)/2][match.y] != NULL)
			{
				xChainPos = resourceTiles[(match.lower + match.upper)/2][match.y]->GetAbsolutePosition().X();
				yChainPos = resourceTiles[(match.lower + match.upper)/2][match.y]->GetAbsolutePosition().Y();
			}
			
			for (int i = match.lower; i <= match.upper; i++)
			{
				PuzzleTile *resourceTile = GetPuzzleTile(i, match.y);
				if (resourceTile != NULL) 
				{
					resourceTile->StopAnimateHint();
					tileQueue.push(resourceTile);
					resourceTiles[i][match.y] = NULL;
					nullTiles[i]++;
					//resourceCount[(int)resourceTile->GetTileType()] += (match.upper - match.lower + 1); // store resources retrieved
					resourceCount[(int)resourceTile->GetTileType()] += 1; // store resources retrieved
					particleSystemManager->AddParticleSystem(new CrystalParticleSystem(resourceTile->GetAbsolutePosition(), resourceTile->GetTileType()));
					removedMatch = true;
				}
				else isChain = false;
			}
			
			if (removedMatch)
			{
				playedSound = true;
				PlayResourceSound(match.qType);
				
				if (isChain)
				{
					OnIncrementChain();
					chainCount++;
					
					if (m_bonusUpAnimEnabled && match.qType == BonusTile) // bonus up animation
					{
						chainManager->AddChainEffect(true, chainCount, xChainPos, yChainPos);
					}
					else // default chain animation
						chainManager->AddChainEffect(false, chainCount, xChainPos, yChainPos);
				}
				
				resourceCount[(int)match.qType] += match.qTiles;
				removedMatch = false;
			}
		}
		else if (match.orientation == VerticalMatch)
		{
			isChain = true;
			//isChain = (match.upper - match.lower) >= 2;
			if (resourceTiles[match.x][(match.lower + match.upper)/2] != NULL)
			{
				xChainPos = resourceTiles[match.x][(match.lower + match.upper)/2]->GetAbsolutePosition().X();
				yChainPos = resourceTiles[match.x][(match.lower + match.upper)/2]->GetAbsolutePosition().Y();
			}
			
			for (int i = match.lower; i <= match.upper; i++)
			{
				PuzzleTile *resourceTile = GetPuzzleTile(match.x, i);

				if (resourceTile != NULL) // check for null, a horizontal row may have removed a tile in this combination
				{
					resourceTile->StopAnimateHint();
					tileQueue.push(resourceTile);
					resourceTiles[match.x][i] = NULL;
					nullTiles[match.x]++;
					//resourceCount[(int)resourceTile->GetTileType()] += (match.upper - match.lower + 1); // store resources retrieved
					resourceCount[(int)resourceTile->GetTileType()] += 1; // store resources retrieved
					particleSystemManager->AddParticleSystem(new CrystalParticleSystem(resourceTile->GetAbsolutePosition(), resourceTile->GetTileType()));
					removedMatch = true;
				}
				else isChain = false;
			}
			
			if (removedMatch)
			{
				if (!playedSound)
					PlayResourceSound(match.qType);
				
				if (isChain)
				{
					OnIncrementChain();
					chainCount++;
					
					if (m_bonusUpAnimEnabled && match.qType == BonusTile) // bonus up animation
					{
						chainManager->AddChainEffect(true, chainCount, xChainPos, yChainPos);
					}
					else // default chain animation
						chainManager->AddChainEffect(false, chainCount, xChainPos, yChainPos);
				}
				resourceCount[(int)match.qType] += match.qTiles;
				removedMatch = false;
			}
		}
	}
	
	// Report Resources Retrieved
	//OnIncrementChain();
	for (int i = 0; i < PuzzleTile::tile_types; i++)
	{
		if (resourceCount[i] > 0)
			ResourcesRetrieved((TileType)i, resourceCount[i]);
	}
	
	
	tileSelector->SetVisible(false);
	
	// Shift down all tiles
	for (int x = 0; x < x_tiles; x++)
	{
		for (int y = y_tiles-1; y > 0; y--)
		{
			if (GetPuzzleTile(x, y) == NULL)
			{
				for (int i = y; i >=0; i--)
				{
					PuzzleTile *tmpTile = GetPuzzleTile(x, i);
					if (tmpTile != NULL)
					{
						resourceTiles[x][i] = NULL;
						resourceTiles[x][y] = tmpTile;
						CR::Math::PointI tilePoint;
						tilePoint.X(x);
						tilePoint.Y(y);
						tmpTile->AnimateSlideTo(tilePoint, anim_fps * (y - i));
						break;
					}
				}
			}
		}
	}
	
	// Use the tiles from the tilequeue as new tiles, slide them in
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			if (resourceTiles[x][y] == NULL)
			{
				resourceTiles[x][y] = tileQueue.front();
				tileQueue.pop();
				
				resourceTiles[x][y]->RandomizeType(m_dropRateBonusType);

				// determine points for slide in animation
				CR::Math::PointI fromPoint = CR::Math::PointI(x, y - nullTiles[x], 0); // from_point
				CR::Math::PointI tilePoint = CR::Math::PointI(x, y, 0); // to_point
				
				resourceTiles[x][y]->AnimateSlideIn(fromPoint, tilePoint, anim_fps * nullTiles[x]);
			}
		}
	}
	
	return true;
}

MatchBounds MatchThreePuzzle::FindHorizontalMatch(int xLoc, int yLoc)
{	
	int lower = 0;
	int upper = 0;
	bool foundMatch = false;
	bool matchEnded = false;
	int qTiles = 0;
	
	PuzzleTile *resourceTile = GetPuzzleTile(xLoc, yLoc);
	if (resourceTile == NULL || resourceTile->GetTileType() == WildTile)
		return MatchBounds();
	
	TileType resourceType = resourceTile->GetTileType();
	
	// Check Left
	for (int x = xLoc; x >= 0 && matchEnded != true; x--)
	{
		PuzzleTile *tmpTile = GetPuzzleTile(x, yLoc);
		if (tmpTile == NULL || (tmpTile->GetTileType() != resourceType && tmpTile->GetTileType() != WildTile))
			matchEnded = true;
		else
		{
			if (tmpTile->GetTileType() == WildTile) qTiles++;
			lower = x;
		}
	}

	// Check Right
	matchEnded = false;
	for (int x = xLoc; x < x_tiles && matchEnded != true; x++)
	{
		PuzzleTile *tmpTile = GetPuzzleTile(x, yLoc);
		if (tmpTile == NULL || (tmpTile->GetTileType() != resourceType && tmpTile->GetTileType() != WildTile))
			matchEnded = true;
		else
		{
			if (tmpTile->GetTileType() == WildTile) qTiles++;
			upper = x;
		}
	}
	
	if ((upper - lower) >= (tiles_required_for_match -1))
		foundMatch = true;
	
	return MatchBounds(foundMatch, HorizontalMatch, xLoc, yLoc, lower, upper, resourceTile->GetTileType(), qTiles);
}

MatchBounds MatchThreePuzzle::FindVerticalMatch(int xLoc, int yLoc)
{	
	
	// TODO: if the tile being checked is a Q tile, there needs to be a check here
	
	int lower = 0;
	int upper = 0;
	bool foundMatch = false;
	bool matchEnded = false;
	int qTiles = 0;
	
	PuzzleTile *resourceTile = GetPuzzleTile(xLoc, yLoc);
	if (resourceTile == NULL || resourceTile->GetTileType() == WildTile)
		return MatchBounds();
	
	TileType resourceType = resourceTile->GetTileType();
	
	// Check Up
	for (int y = yLoc; y >= 0 && matchEnded != true; y--)
	{
		PuzzleTile *tmpTile = GetPuzzleTile(xLoc, y);
		if (tmpTile == NULL || (tmpTile->GetTileType() != resourceType && tmpTile->GetTileType() != WildTile))
			matchEnded = true;
		else
		{
			if (tmpTile->GetTileType() == WildTile) qTiles++;
			lower = y;
		}
	}
	
	// Check Down
	matchEnded = false;
	for (int y = yLoc; y < y_tiles && matchEnded != true; y++)
	{
		PuzzleTile *tmpTile = GetPuzzleTile(xLoc, y);
		if (tmpTile == NULL || (tmpTile->GetTileType() != resourceType && tmpTile->GetTileType() != WildTile))
			matchEnded = true;
		else
		{
			if (tmpTile->GetTileType() == WildTile) qTiles++;
			upper = y;
		}
	}
	
	if ((upper - lower) >= (tiles_required_for_match-1))
		foundMatch = true;
	
	return MatchBounds(foundMatch, VerticalMatch, xLoc, yLoc, lower, upper, resourceTile->GetTileType(), qTiles);
}

void MatchThreePuzzle::SwapTiles(CR::Math::PointI tile1, CR::Math::PointI tile2)
{
	PuzzleTile *rTile1 = GetPuzzleTile(tile1.X(), tile1.Y());
	PuzzleTile *rTile2 = GetPuzzleTile(tile2.X(), tile2.Y());
	resourceTiles[tile1.X()][tile1.Y()] = rTile2;
	resourceTiles[tile2.X()][tile2.Y()] = rTile1;
	rTile1->AnimateSlideTo(tile2, anim_fps);
	rTile2->AnimateSlideTo(tile1, anim_fps);
	
	//int isnd = 16 + (rand() % 3);
	//sounds[isnd]->Play();
}

bool MatchThreePuzzle::CanSwapTiles(CR::Math::PointI tile1, CR::Math::PointI tile2)
{
	// if the tiles are not within 1 of eachother, or are diagonal from eachother, return false
	int xDiff = tile1.X() - tile2.X();
	int yDiff = tile1.Y() - tile2.Y();
	int absXDiff = abs(xDiff);
	int absYDiff = abs(yDiff);
	if ( (absXDiff > 1) || (absYDiff > 1) || (absXDiff == 1 && absYDiff == 1) )
		return false;
	
	// Horizontal Swap Detected
	if (xDiff == -1)
	{
		if (CheckForRightSwapMatch(tile1.X(), tile1.Y()) || CheckForLeftSwapMatch(tile2.X(), tile2.Y()))
			return true;
	}
	else if (xDiff == 1)
	{
		if (CheckForLeftSwapMatch(tile1.X(), tile1.Y()) || CheckForRightSwapMatch(tile2.X(), tile2.Y()))
			return true;
	}
	else if (yDiff == -1) // Vertical Swap Detected
	{
		if (CheckForDownSwapMatch(tile1.X(), tile1.Y()) || CheckForUpSwapMatch(tile2.X(), tile2.Y()))
			return true;
	}
	else if (yDiff == 1)
	{
		if (CheckForUpSwapMatch(tile1.X(), tile1.Y()) || CheckForDownSwapMatch(tile2.X(), tile2.Y()))
			return true;
	}
	
	return false;
}

void MatchThreePuzzle::RandomizeTiles()
{
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			resourceTiles[x][y]->RandomizeType(m_dropRateBonusType);
		}
	}
}

bool MatchThreePuzzle::IsPuzzleValid()
{	
	// loop through tiles
	for (int x = 0; x < x_tiles; x++)
	{
		for (int y = 0; y < y_tiles; y++)
		{
			// left swap checks
			if (CheckForLeftMatch(x - 1, y, GetPuzzleTile(x, y)) ||
				CheckForUpMatch(x - 1, y, GetPuzzleTile(x, y)) ||
				CheckForDownMatch(x - 1, y, GetPuzzleTile(x, y)) ||
				CheckForMiddleVerticalMatch(x - 1, y, GetPuzzleTile(x, y)))
				return true;
			
			// right swap checks
			if (CheckForRightMatch(x + 1, y, GetPuzzleTile(x, y)) ||
				CheckForUpMatch(x + 1, y, GetPuzzleTile(x, y)) ||
				CheckForDownMatch(x + 1, y, GetPuzzleTile(x, y)) ||
				CheckForMiddleVerticalMatch(x + 1, y, GetPuzzleTile(x, y)))
				return true;
			
			// up swap checks
			if (CheckForLeftMatch(x, y - 1, GetPuzzleTile(x, y)) ||
				CheckForRightMatch(x, y - 1, GetPuzzleTile(x, y)) ||
				CheckForUpMatch(x, y - 1, GetPuzzleTile(x, y)) ||
				CheckForMiddleHorizontalMatch(x, y - 1, GetPuzzleTile(x, y)))
				return true;
			
			// down swap checks
			if (CheckForLeftMatch(x, y + 1, GetPuzzleTile(x, y)) ||
				CheckForRightMatch(x, y + 1, GetPuzzleTile(x, y)) ||
				CheckForDownMatch(x, y + 1, GetPuzzleTile(x, y)) ||
				CheckForMiddleHorizontalMatch(x, y + 1, GetPuzzleTile(x, y)))
				return true;
		}
	}
	
	return false;
}

bool MatchThreePuzzle::CheckForLeftMatch(int x, int y, PuzzleTile *rTile)
{
	if (rTile == NULL)
		return false;
	
	PuzzleTile *t1;
	TileType rType = rTile->GetTileType();
	
	for (int i = -1 ; i >= -2; i--)
	{
		t1 = GetPuzzleTile(x + i, y);
		if (t1 != NULL && rType == WildTile) rType = t1->GetTileType();
		
		if (t1 == NULL || (t1->GetTileType() != rType && t1->GetTileType() != WildTile))
			return false;
	}

	return true;
}

bool MatchThreePuzzle::CheckForRightMatch(int x, int y, PuzzleTile *rTile)
{	
	if (rTile == NULL)
		return false;
	
	PuzzleTile *t1;
	TileType rType = rTile->GetTileType();
	
	for (int i = 1 ; i <= 2; i++)
	{
		t1 = GetPuzzleTile(x + i, y);
		if (t1 != NULL && rType == WildTile) rType = t1->GetTileType();
		
		if (t1 == NULL || (t1->GetTileType() != rType && t1->GetTileType() != WildTile))
			return false;
	}
	
	return true;
	
}

bool MatchThreePuzzle::CheckForUpMatch(int x, int y, PuzzleTile *rTile)
{
	if (rTile == NULL)
		return false;
	
	PuzzleTile *t1;
	TileType rType = rTile->GetTileType();
		
	for (int i = -1 ; i >= -2; i--)
	{
		t1 = GetPuzzleTile(x, y + i);
		if (t1 != NULL && rType == WildTile) rType = t1->GetTileType();
		
		if (t1 == NULL || (t1->GetTileType() != rType && t1->GetTileType() != WildTile))
			return false;
	}
	
	return true;
}

bool MatchThreePuzzle::CheckForDownMatch(int x, int y, PuzzleTile *rTile)
{
	if (rTile == NULL)
		return false;
	
	PuzzleTile *t1;
	TileType rType = rTile->GetTileType();
	
	for (int i = 1 ; i <= 2; i++)
	{
		t1 = GetPuzzleTile(x, y + i);
		if (t1 != NULL && rType == WildTile) rType = t1->GetTileType();
		
		if (t1 == NULL || (t1->GetTileType() != rType && t1->GetTileType() != WildTile))
			return false;
	}
	
	return true;
}

bool MatchThreePuzzle::CheckForMiddleVerticalMatch(int x, int y, PuzzleTile *rTile)
{
	if (rTile == NULL)
		return false;
	
	PuzzleTile *t1;
	PuzzleTile *t2;
	TileType rType = rTile->GetTileType();
	
	t1 = GetPuzzleTile(x, y - 1);
	t2 = GetPuzzleTile(x, y + 1);
	
	if (rType == WildTile)
	{
		if (t1 != NULL && t2 != NULL && (t1->GetTileType() == t2->GetTileType() || (t1->GetTileType() == WildTile) || t2->GetTileType() == WildTile))
			return true;
	}
	else
	{
		if (t1 != NULL && t2 != NULL && (t1->GetTileType() == rType || t1->GetTileType() == WildTile) && (t2->GetTileType() == rType || t2->GetTileType() == WildTile))
			return true;
	}
	
	return false;
}

bool MatchThreePuzzle::CheckForMiddleHorizontalMatch(int x, int y, PuzzleTile *rTile)
{
	if (rTile == NULL)
		return false;
	
	PuzzleTile *t1;
	PuzzleTile *t2;
	TileType rType = rTile->GetTileType();
	
	t1 = GetPuzzleTile(x - 1, y);
	t2 = GetPuzzleTile(x + 1, y);
	
	if (rType == WildTile)
	{
		if (t1 != NULL && t2 != NULL && (t1->GetTileType() == t2->GetTileType() || (t1->GetTileType() == WildTile) || t2->GetTileType() == WildTile))
			return true;
	}
	else
	{
		if (t1 != NULL && t2 != NULL && (t1->GetTileType() == rType || t1->GetTileType() == WildTile) && (t2->GetTileType() == rType || t2->GetTileType() == WildTile))
			return true;
	}
	
	return false;
}

bool MatchThreePuzzle::CheckForUpSwapMatch(int x, int y)
{
	if (CheckForLeftMatch(x, y - 1, GetPuzzleTile(x, y)) ||
		CheckForRightMatch(x, y - 1, GetPuzzleTile(x, y)) ||
		CheckForUpMatch(x, y - 1, GetPuzzleTile(x, y)) ||
		CheckForMiddleHorizontalMatch(x, y - 1, GetPuzzleTile(x, y)))
		return true;
	else
		return false;
}

bool MatchThreePuzzle::CheckForDownSwapMatch(int x, int y)
{
	if (CheckForLeftMatch(x, y + 1, GetPuzzleTile(x, y)) ||
		CheckForRightMatch(x, y + 1, GetPuzzleTile(x, y)) ||
		CheckForDownMatch(x, y + 1, GetPuzzleTile(x, y)) ||
		CheckForMiddleHorizontalMatch(x, y + 1, GetPuzzleTile(x, y)))
		return true;
	else
		return false;
}

bool MatchThreePuzzle::CheckForLeftSwapMatch(int x, int y)
{
	if (CheckForLeftMatch(x - 1, y, GetPuzzleTile(x, y)) ||
		CheckForUpMatch(x - 1, y, GetPuzzleTile(x, y)) ||
		CheckForDownMatch(x - 1, y, GetPuzzleTile(x, y)) ||
		CheckForMiddleVerticalMatch(x - 1, y, GetPuzzleTile(x, y)))
		return true;
	else
		return false;
}

bool MatchThreePuzzle::CheckForRightSwapMatch(int x, int y)
{
	if (CheckForRightMatch(x + 1, y, GetPuzzleTile(x, y)) ||
		CheckForUpMatch(x + 1, y, GetPuzzleTile(x, y)) ||
		CheckForDownMatch(x + 1, y, GetPuzzleTile(x, y)) ||
		CheckForMiddleVerticalMatch(x + 1, y, GetPuzzleTile(x, y)))
		return true;
	else
		return false;
}

PuzzleTile *MatchThreePuzzle::GetPuzzleTile(int xLoc, int yLoc) const
{
	if (xLoc >= 0 && xLoc < x_tiles && yLoc >= 0 && yLoc < y_tiles)
		return resourceTiles[xLoc][yLoc];
	else
		return NULL;
}

bool MatchThreePuzzle::IsPuzzleAnimating() const
{
	return m_isAnimating || specialSelector->IsSelector3();
}

void MatchThreePuzzle::SetDropRateBonusType(TileType rType)
{
	m_dropRateBonusType = rType;
}

/*
void MatchThreePuzzle::SetBuildingSpecialDown(BuildingName bName, int level)
{
	int breakBlocks = 0;
	bool breakAllBlocks = false;
	
	tileSelector->SetVisible(false);
	
	// determine how many random blocks to mark for breaking
	if (level <= 2) breakBlocks = 3;
	else if (level <= 4) breakBlocks = 4;
	else breakAllBlocks = true;
	
	// determine the resource type
	TileType rType = NoTile;
	switch (bName)
	{
		case Firehouse:
			rType = BoneTile;
			break;
		case Lodge:
			rType = HandTile;
			break;
		case Greenhouse:
			rType = BassTile;
			break;
		case TownHall:
			rType = SkullTileA;
			break;
		case PoliceStation:
			rType = Crystal;
			break;
		case Theatre:
			rType = TrumpetTile;
			break;
		default:
			break;
	}
	
	vector<CR::Math::PointI> tilePoints;
	
	// find all blocks of the specified resource type
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			if (resourceTiles[x][y]->GetTileType() == rType)
				tilePoints.push_back(CR::Math::PointI(x, y, 0));
		}
	}
	
	// mark all of the blocks if tilePoints <= breakblocks
	if (tilePoints.size() <= breakBlocks || breakAllBlocks)
	{
		for (int i = 0; i < tilePoints.size(); i++)
		{
			specialClearTiles[tilePoints[i].X()][tilePoints[i].Y()] = true;
		}
	}
	else // mark random blocks up to the amount required
	{
		// randomize the list, set special tiles to true for clearing
		int rndCount = 0;
		for (int i = 0; i < tilePoints.size(); i++)
		{
			int rndPoint = random() % (tilePoints.size() - i) + i;
			swap(tilePoints[i], tilePoints[rndPoint]);
			
			specialClearTiles[tilePoints[i].X()][tilePoints[i].Y()] = true;
			rndCount++;
			if (rndCount >= breakBlocks)
				break;
		}
	}
	
	m_buildingSpecialDown = true;
}

void MatchThreePuzzle::SetBuildingSpecialUp(BuildingName bName, int level)
{
	if (!specialSelector->IsSelector3())
	{
		std::tr1::shared_ptr<CR::Sound::ISoundFX> sound;
		sound = ISound::Instance().CreateSoundFX(CR::AssetList::sounds::powerused1c::ID);
		sound->Play();
		
		StopAnimateHint();
	}
	
	specialSelector->ShowSelector3();
}
*/

void MatchThreePuzzle::DoSpecialMove(int x, int y, SpecialMove sMove)
{
	if (sMove == NoSpecial) return;
	
	tileSelector->SetVisible(false);
	
	switch (sMove)
	{
		case CrossClearSpecial:
			SetupCrossClearSpecial(x, y);			
			break;
		default:
			break;
	}
	
	m_buildingSpecialDown = true;
	
	if (!specialSelector->IsSelector3())
	{
		//std::tr1::shared_ptr<CR::Sound::ISoundFX> sound;
		//sound = ISound::Instance().CreateSoundFX(CR::AssetList::sounds::tile_bass::ID);
		//sound->Play();
		
		StopAnimateHint();
	}
	
	specialSelector->ShowSelector3();
	m_isSpecialMoveActing = true;
}

void MatchThreePuzzle::SetupCrossClearSpecial(int x, int y)
{
	// Mark all x tiles to be cleared
	for (int xClear = 0; xClear < x_tiles; xClear++)
	{
		specialClearTiles[xClear][y] = true;
	}

	// Mark all y tiles to be cleared
	for (int yClear = 0; yClear < y_tiles; yClear++)
	{
		specialClearTiles[x][yClear] = true;
	}
	
	//int iSnd = (rand() % 10) + 13;
	//sounds[iSnd]->Play();
	//chainCount
	
	if (!m_isSpecialMoveActing)
		sounds[23]->Play();
}

void MatchThreePuzzle::CancelBuildingSpecial()
{
	if (!specialSelector->IsSelector3())
	{
		for (int y = 0; y < y_tiles; y++)
		{
			for (int x = 0; x < x_tiles; x++)
			{
				specialClearTiles[x][y] = false;
			}
		}
		
		m_buildingSpecialDown = false;
	}
}

void MatchThreePuzzle::OnClearBuildingSpecialTiles()
{
	int iSnd = (rand() % 10) + 13;
	sounds[iSnd]->Play();
	
	queue<PuzzleTile*> tileQueue;
	
	int resourceCount[PuzzleTile::tile_types];// = {0, 0, 0, 0, 0, 0}; // resources receieved through matches
	for (int i = 0; i < PuzzleTile::tile_types; i++)
		resourceCount[i] = 0;
	
	// storage for the number of null tiles in each column
	int nullTiles[x_tiles];
	for (int i = 0; i < x_tiles; i++)
		nullTiles[i] = 0;
	
	bool removedMatch = false;
	
	m_buildingSpecialDown = false;
	
	

	bool foundBonusTile = false;
	//int xChainPos = 0;
	//int yChainPos = 0;
	//int xBChainPos = 0;
	//int yBChainPos = 0;
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			if (specialClearTiles[x][y] == true)
			{
				PuzzleTile *resourceTile = GetPuzzleTile(x, y);
				if (resourceTile != NULL) 
				{
					// Check for bonus tiles!
					if (!foundBonusTile && m_bonusUpAnimEnabled && resourceTile->GetTileType() == BonusTile)
					{
						foundBonusTile = true;
						chainManager->AddChainEffect(true, chainCount, resourceTile->GetAbsolutePosition().X(), resourceTile->GetAbsolutePosition().Y());
					}
							
					tileQueue.push(resourceTile);
					resourceTiles[x][y] = NULL;
					nullTiles[x]++;
					resourceCount[(int)resourceTile->GetTileType()] += 1; // store resources retrieved
					//particleSystemManager->AddParticleSystem(new CrystalParticleSystem(resourceTile->GetAbsolutePosition(), resourceTile->GetTileType()));
					
					if (!removedMatch)
					{
						chainCount++;
						removedMatch = true;
					}
				}
			}
			
			specialClearTiles[x][y] = false;
		}
	}
	
	if (!removedMatch) return;
	
	// update chain count, display chain animation
	// TODO: Place in proper position
	//chainCount++;
	//if (foundBonusTile) // bonus up animation
	//{
	//	chainManager->AddChainEffect(true, chainCount, xBChainPos, yBChainPos);
	//}
	//else // default chain animation
	//{
	//chainManager->AddChainEffect(false, chainCount, xChainPos, yChainPos);
	//}
	
	
	// Report Resources Retrieved
	for (int i = 0; i < PuzzleTile::tile_types; i++)
	{
		if (resourceCount[i] > 0)
			ResourcesRetrieved((TileType)i, resourceCount[i]);
	}
	
	tileSelector->SetVisible(false);
	
	// Shift down all tiles
	for (int x = 0; x < x_tiles; x++)
	{
		for (int y = y_tiles-1; y > 0; y--)
		{
			if (GetPuzzleTile(x, y) == NULL)
			{
				for (int i = y; i >=0; i--)
				{
					PuzzleTile *tmpTile = GetPuzzleTile(x, i);
					if (tmpTile != NULL)
					{
						resourceTiles[x][i] = NULL;
						resourceTiles[x][y] = tmpTile;
						CR::Math::PointI tilePoint;
						tilePoint.X(x);
						tilePoint.Y(y);
						tmpTile->AnimateSlideTo(tilePoint, anim_fps * (y - i));
						break;
					}
				}
			}
		}
	}
	
	// Use the tiles from the tilequeue as new tiles, slide them in
	for (int y = 0; y < y_tiles; y++)
	{
		for (int x = 0; x < x_tiles; x++)
		{
			if (resourceTiles[x][y] == NULL)
			{
				resourceTiles[x][y] = tileQueue.front();
				tileQueue.pop();
				
				resourceTiles[x][y]->RandomizeType(m_dropRateBonusType);
				
				// determine points for slide in animation
				CR::Math::PointI fromPoint = CR::Math::PointI(x, y - nullTiles[x], 0); // from_point
				CR::Math::PointI tilePoint = CR::Math::PointI(x, y, 0); // to_point
				
				resourceTiles[x][y]->AnimateSlideIn(fromPoint, tilePoint, anim_fps * nullTiles[x]);
			}
		}
	}
	
	FindHintBlock();
	m_isSpecialMoveActing = false;
}

void MatchThreePuzzle::OnExplodeTilesSpecial()
{
	// render special tile selector
	if (m_buildingSpecialDown)
	{
		for (int y = 0; y < y_tiles; y++)
		{
			for (int x = 0; x < x_tiles; x++)
			{
				if (specialClearTiles[x][y] == true)
				{
					particleSystemManager->AddParticleSystem(new CrystalParticleSystem(resourceTiles[x][y]->GetAbsolutePosition(), resourceTiles[x][y]->GetTileType()));
				}
			}
		}
	}
}

void MatchThreePuzzle::FindHintBlock()
{
	if (!hintsEnabled && !easyAssistEnabled) return;
	
	vector<CR::Math::PointI> validMoves;
	
	// loop through tiles
	for (int x = 0; x < x_tiles; x++)
	{
		for (int y = 0; y < y_tiles; y++)
		{
			// left swap checks
			if (CheckForLeftMatch(x - 1, y, GetPuzzleTile(x, y)) ||
				CheckForUpMatch(x - 1, y, GetPuzzleTile(x, y)) ||
				CheckForDownMatch(x - 1, y, GetPuzzleTile(x, y)) ||
				CheckForMiddleVerticalMatch(x - 1, y, GetPuzzleTile(x, y)))
			{
				validMoves.push_back(CR::Math::PointI(x, y, 0));
			}
			
			// right swap checks
			if (CheckForRightMatch(x + 1, y, GetPuzzleTile(x, y)) ||
				CheckForUpMatch(x + 1, y, GetPuzzleTile(x, y)) ||
				CheckForDownMatch(x + 1, y, GetPuzzleTile(x, y)) ||
				CheckForMiddleVerticalMatch(x + 1, y, GetPuzzleTile(x, y)))
			{
				validMoves.push_back(CR::Math::PointI(x, y, 0));
			}
			
			// up swap checks
			if (CheckForLeftMatch(x, y - 1, GetPuzzleTile(x, y)) ||
				CheckForRightMatch(x, y - 1, GetPuzzleTile(x, y)) ||
				CheckForUpMatch(x, y - 1, GetPuzzleTile(x, y)) ||
				CheckForMiddleHorizontalMatch(x, y - 1, GetPuzzleTile(x, y)))
			{
				validMoves.push_back(CR::Math::PointI(x, y, 0));
			}
			
			// down swap checks
			if (CheckForLeftMatch(x, y + 1, GetPuzzleTile(x, y)) ||
				CheckForRightMatch(x, y + 1, GetPuzzleTile(x, y)) ||
				CheckForDownMatch(x, y + 1, GetPuzzleTile(x, y)) ||
				CheckForMiddleHorizontalMatch(x, y + 1, GetPuzzleTile(x, y)))
			{
				validMoves.push_back(CR::Math::PointI(x, y, 0));
			}
		}
	}
	
	if (validMoves.size() > 0)
	{
		int rndTile = rand() % validMoves.size();
		hintOffset.X(validMoves[rndTile].X());
		hintOffset.Y(validMoves[rndTile].Y());
	}
}

void MatchThreePuzzle::QueueEasyAssist()
{
	if (easyAssistEnabled)
		m_doEasyAssist = true;
}

void MatchThreePuzzle::DoEasyAssist()
{
	//m_doEasyAssist = false;
	
	if (easyAssistEnabled)
	{
		CR::Math::PointI LTile;
		CR::Math::PointI RTile;
		CR::Math::PointI UTile;
		CR::Math::PointI DTile;
		
		if (hintOffset.X() > 0)
		{
			LTile.X(hintOffset.X()-1);
			LTile.Y(hintOffset.Y());
			
			if (CanSwapTiles(hintOffset, LTile))
			{
				SwapTiles(hintOffset, LTile);
				return;
			}
		}
		
		if (hintOffset.X() < x_tiles - 1)
		{
			RTile.X(hintOffset.X()+1);
			RTile.Y(hintOffset.Y());
			
			if (CanSwapTiles(hintOffset, RTile))
			{
				SwapTiles(hintOffset, RTile);
				return;
			}
		}
		
		if (hintOffset.Y() > 0)
		{
			UTile.X(hintOffset.X());
			UTile.Y(hintOffset.Y()-1);
			
			if (CanSwapTiles(hintOffset, UTile))
			{
				SwapTiles(hintOffset, UTile);
				return;
			}
		}
		
		if (hintOffset.Y() < y_tiles - 1)
		{
			DTile.X(hintOffset.X());
			DTile.Y(hintOffset.Y()+1);
			
			if (CanSwapTiles(hintOffset, DTile))
			{
				SwapTiles(hintOffset, DTile);
				return;
			}
		}
	}
}

void MatchThreePuzzle::AnimateHint()
{
	resourceTiles[hintOffset.X()][hintOffset.Y()]->AnimateHint();
}

void MatchThreePuzzle::StopAnimateHint()
{
	resourceTiles[hintOffset.X()][hintOffset.Y()]->StopAnimateHint();
}

void MatchThreePuzzle::PlayResourceSound(TileType rType)
{
	int i = rType;
	
	if (i < 5)
		sounds[i]->Play();
	else if (i == 5)
	{
		int j = (rand() % 8) + 5;
		sounds[j]->Play();
	}
	
	m_genericTileSounds[rand() % m_genericTileSounds.size()]->Play();
	//int i =	rType * 2 + (rand() & 1);
	//sounds[i]->Play();
	
}

void MatchThreePuzzle::StartSuperChargeMode()
{
	m_isSuperChargeMode = true;
	
	for (int x = 0; x < x_tiles; x++)
	{
		for (int y = 0; y < y_tiles; y++)
		{
			PuzzleTile *tile = GetPuzzleTile(x, y);
			if (tile->GetTileType() == SkullTileA)
			{
				if(!tile->IsSuperChargedHarry())
				{
					tile->MakeSuperChargedHarry();
				}
			}
		}
	}
}

void MatchThreePuzzle::EndSuperChargeMode()
{
	m_isSuperChargeMode = false;
}

void MatchThreePuzzle::StartWildHeartsMode()
{
	m_isWildHeartsMode = true;
	
	for (int x = 0; x < x_tiles; x++)
	{
		for (int y = 0; y < y_tiles; y++)
		{
			PuzzleTile *tile = GetPuzzleTile(x, y);
			if (tile->GetTileType() == HeartTile)
			{
				if(!tile->WildHeart())
				{
					tile->WildHeart(true);
				}
			}
		}
	}
}

void MatchThreePuzzle::EndWildHeartsMode()
{
	m_isWildHeartsMode = false;
	
	for (int x = 0; x < x_tiles; x++)
	{
		for (int y = 0; y < y_tiles; y++)
		{
			PuzzleTile *tile = GetPuzzleTile(x, y);
			if (tile->WildHeart())
			{
				tile->WildHeart(false);
			}
		}
	}
}					   

void MatchThreePuzzle::EnableBonusUpAnim(bool _enabled)
{
	m_bonusUpAnimEnabled = _enabled;
}

void MatchThreePuzzle::TouchesBeganImpl(UIView *view, NSSet *touches)
{
	// no input is allowed during animation
	if (!touchAllowed || m_isAnimating || specialSelector->IsSelector3() || m_buildingSpecialDown)
		return;
	
	CGPoint glLocation;
	for (UITouch *touch in touches)
	{
		if (this->touch != NULL && touch != this->touch)
			continue;
		
		glLocation = GetGLLocation(view, touch);

		// detect of the touch was in the bounds of the puzzle
		if ( !(glLocation.x > Offset_X() && glLocation.x < Offset_X() + (PuzzleTile::tile_width * x_tiles + (tile_spacing * x_tiles)) &&
			  glLocation.y > Offset_Y() && glLocation.y < Offset_Y() + (PuzzleTile::tile_height * y_tiles + (tile_spacing * y_tiles))))
		{
			this->touch = NULL;
			return;
		}
		else
		{
			this->touch = touch;
		}
		
		CR::Math::PointI mtxPosition;
		mtxPosition.X((glLocation.x - Offset_X()) / (PuzzleTile::tile_width + tile_spacing));
		mtxPosition.Y((glLocation.y - Offset_Y()) / (PuzzleTile::tile_height + tile_spacing));

		bool wasVisible = tileSelector->Visible();
		CR::Math::PointI oldPosition = tileSelector->GetPosition();
		tileSelector->SetPosition(mtxPosition);
		tileSelector->SetVisible(true);
		
		// TODO: Remove this
		//DoSpecialMove(mtxPosition.X(), mtxPosition.Y(), CrossClearSpecial);
		
		if (wasVisible && !(tileSelector->GetPosition().X() == oldPosition.X() && tileSelector->GetPosition().Y() == oldPosition.Y()))
		{
			if (hintsEnabled)
			{
				currHintTime = maxHintTime;
				StopAnimateHint();
			}
			
			if (CanSwapTiles(oldPosition, tileSelector->GetPosition()))
				SwapTiles(oldPosition, tileSelector->GetPosition());
			else
			{
				if (AnimateShakeTiles(oldPosition, tileSelector->GetPosition()))
				{
					//tileSelector->SetVisible(false);
					hideTileSelectorAfterAnimation = true;
					this->touch = NULL;
				}
			}
			
			// A move was made or attempted
			MoveMade();
			touchAllowed = false;
		}
	}
}

void MatchThreePuzzle::TouchesMovedImpl(UIView *view, NSSet *touches)
{
	for (UITouch *touch in touches)
	{
		if (touch == this->touch)
		{
			this->TouchesBeganImpl(view, touches);
			break;
		}
	}
}

void MatchThreePuzzle::TouchesEndedImpl(UIView *view, NSSet *touches)
{
	for (UITouch *touch in touches)
	{
		if (touch == this->touch)
		{
			this->touch = NULL;
			break;
		}
	}
}

void MatchThreePuzzle::TouchesCancelledImpl(UIView *view, NSSet *touches)
{
	for (UITouch *touch in touches)
	{
		if (touch == this->touch)
		{
			this->touch = NULL;
			break;
		}
	}
}








