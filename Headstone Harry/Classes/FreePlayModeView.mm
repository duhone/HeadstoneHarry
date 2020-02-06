/*
 *  FreePlayModeView.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/9/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#include "FreePlayModeView.h"
#include "AssetList.h"

using namespace CR::UI;
using namespace CR::Graphics;

extern CR::Graphics::GraphicsEngine *graphics_engine;

FreePlayModeView::FreePlayModeView() : Control()
{
	resourcePuzzle = new MatchThreePuzzle(3, 86, 1, true);
	
	hudTop = graphics_engine->CreateSprite1(false, 925);
	hudTop->SetImage(CR::AssetList::HUD_Top_2);
	hudTop->SetPositionAbsolute(160, 43);
	
	hudBottom = graphics_engine->CreateSprite1(false, 925);
	hudBottom->SetImage(CR::AssetList::HUD_Bottom);
	hudBottom->SetPositionAbsolute(160, 463);
}

FreePlayModeView::~FreePlayModeView()
{
	hudTop->Release();
	hudBottom->Release();
}

bool FreePlayModeView::TouchesBegan(UIView *view, NSSet *touches)
{
	resourcePuzzle->TouchesBegan(view, touches);
	return true;
}

bool FreePlayModeView::TouchesMoved(UIView *view, NSSet *touches)
{
	resourcePuzzle->TouchesMoved(view, touches);
	return true;
}

void FreePlayModeView::TouchesEnded(UIView *view, NSSet *touches)
{
	resourcePuzzle->TouchesEnded(view, touches);
}

void FreePlayModeView::TouchesCancelled(UIView *view, NSSet *touches)
{
	resourcePuzzle->TouchesCancelled(view, touches);
}

void FreePlayModeView::OnBeforeUpdate()
{
	resourcePuzzle->Update();
}

void FreePlayModeView::OnBeforeRender()
{
	resourcePuzzle->Render();
	hudTop->Render();
	hudBottom->Render();
}

void FreePlayModeView::OnPaused(bool _paused)
{
	resourcePuzzle->particleSystemManager->PauseAnimation(_paused);
}