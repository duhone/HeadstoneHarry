/*
 *  MatchTypes.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
//
enum TileType {	BassTile = 0, 
				BoneTile = 1, 
				HandTile = 2, 
				HeartTile = 3, 
				TrumpetTile = 4, 
				SkullTileA = 5, // Regular Harry
				WildTile = 6,
				BonusTile = 7,
				NoTile = 8 };

enum AnimationStatus { AnimationOff, AnimationOn};
enum AnimationDirection { AnimateUp, AnimateDown, AnimateLeft, AnimateRight};

// Orientation of a Match in MatchBounds
enum MatchOrientation
{
	VerticalMatch,
	HorizontalMatch
};

// Information about the properties of a single match
struct MatchBounds {
	bool foundMatch;
	int x;
	int y;
	int lower;
	int upper;
	MatchOrientation orientation;
	
	TileType qType;
	int qTiles;
	
	MatchBounds()
	{
		foundMatch = false;
		lower = 0;
		upper = 0;
		x = 0;
		y = 0;
		
		qType = SkullTileA;
		qTiles = 0;
	};
	
	MatchBounds(bool fMatch, MatchOrientation orient, int xLoc, int yLoc, int l, int u, TileType qType, int qTiles)
	{
		foundMatch = fMatch;
		orientation = orient;
		lower = l;
		upper = u;
		x = xLoc;
		y = yLoc;
		this->qType = qType;
		this->qTiles = qTiles;
	}
};


enum SpecialMove { CrossClearSpecial, NoSpecial };