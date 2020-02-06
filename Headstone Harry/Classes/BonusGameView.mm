/*
 *  BonusGameView.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/7/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "BonusGameView.h"
#include "AssetList.h"

using namespace CR::UI;
using namespace CR::Graphics;

extern CR::Graphics::GraphicsEngine *graphics_engine;

BonusGameView::BonusGameView() : View(CR::AssetList::Bonus_BG_Overlay, 501)
{
	skeletonAnim = new SkeletonAnim();
	bonusBanner = new BonusBanner();
	pickACardAnim = new PickACardAnim();
	
	
	// preload all card sprites
	Sprite *sprite1 = graphics_engine->CreateSprite1(true, 500);
	sprite1->SetImage(CR::AssetList::Bonus_Card_20KPoints);
	cardSprites.push_back(sprite1);

	sprite1 = graphics_engine->CreateSprite1(true, 500);
	sprite1->SetImage(CR::AssetList::Bonus_Card_10KPoints);
	cardSprites.push_back(sprite1);

	sprite1 = graphics_engine->CreateSprite1(true, 500);
	sprite1->SetImage(CR::AssetList::Bonus_Card_5KPoints);
	cardSprites.push_back(sprite1);

	sprite1 = graphics_engine->CreateSprite1(true, 500);
	sprite1->SetImage(CR::AssetList::Bonus_Card_3XMult);
	cardSprites.push_back(sprite1);

	sprite1 = graphics_engine->CreateSprite1(true, 500);
	sprite1->SetImage(CR::AssetList::Bonus_Card_2XMult);
	cardSprites.push_back(sprite1);

	sprite1 = graphics_engine->CreateSprite1(true, 500);
	sprite1->SetImage(CR::AssetList::Bonus_Card_Super_Charge);
	cardSprites.push_back(sprite1);

	sprite1 = graphics_engine->CreateSprite1(true, 500);
	sprite1->SetImage(CR::AssetList::Bonus_Card_WildHearts);
	cardSprites.push_back(sprite1);

	sprite1 = graphics_engine->CreateSprite1(true, 500);
	sprite1->SetImage(CR::AssetList::Bonus_Card_30Sec);
	cardSprites.push_back(sprite1);

	sprite1 = graphics_engine->CreateSprite1(true, 500);
	sprite1->SetImage(CR::AssetList::Bonus_Card_15Sec);
	cardSprites.push_back(sprite1);
	
						  
}

BonusGameView::~BonusGameView()
{
	for (int i = 0; i < cardSprites.size(); i++)
	{
		cardSprites[i]->Release();
	}
	
	delete skeletonAnim;
	delete bonusBanner;
	delete pickACardAnim;
}

void BonusGameView::OnBeforeUpdate()
{
	View::OnBeforeUpdate();
	
	skeletonAnim->Update();
	bonusBanner->Update();
	pickACardAnim->Update();
}

void BonusGameView::OnBeforeRender()
{
	View::OnBeforeRender();
	
	skeletonAnim->Render();
	bonusBanner->Render();
	pickACardAnim->Render();
}