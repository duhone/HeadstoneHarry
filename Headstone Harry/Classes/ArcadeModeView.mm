/*
 *  ArcadeModeView.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/3/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "ArcadeModeView.h"
#include "AssetList.h"
#include "DeviceManager.h"

using namespace CR::UI;
using namespace CR::Graphics;

extern CR::Graphics::GraphicsEngine *graphics_engine;

ArcadeModeView::ArcadeModeView() : Control()
{
	resourcePuzzle = new MatchThreePuzzle(3, 86, 1, false);

	hudTop = graphics_engine->CreateSprite1(false, 925);
	hudTop->SetImage(CR::AssetList::HUD_Top);
	hudTop->SetPositionAbsolute(160, 43);
	
	hudBottom = graphics_engine->CreateSprite1(false, 925);
	hudBottom->SetImage(CR::AssetList::HUD_Bottom);
	hudBottom->SetPositionAbsolute(160, 463);
}

ArcadeModeView::~ArcadeModeView()
{
	hudTop->Release();
	hudBottom->Release();
}

void ArcadeModeView::HardResetPuzzle()
{
	delete resourcePuzzle;
	resourcePuzzle = new MatchThreePuzzle(3, 86, 1, false);
}

bool ArcadeModeView::TouchesBegan(UIView *view, NSSet *touches)
{
	resourcePuzzle->TouchesBegan(view, touches);
	return true;
}

bool ArcadeModeView::TouchesMoved(UIView *view, NSSet *touches)
{
	resourcePuzzle->TouchesMoved(view, touches);
	return true;
}

void ArcadeModeView::TouchesEnded(UIView *view, NSSet *touches)
{
	resourcePuzzle->TouchesEnded(view, touches);
}

void ArcadeModeView::TouchesCancelled(UIView *view, NSSet *touches)
{
	resourcePuzzle->TouchesCancelled(view, touches);
}

void ArcadeModeView::OnBeforeUpdate()
{
	resourcePuzzle->Update();
}

void ArcadeModeView::OnBeforeRender()
{
	resourcePuzzle->Render();
	hudTop->Render();
	hudBottom->Render();
}

void ArcadeModeView::OnPaused(bool _paused)
{
	resourcePuzzle->particleSystemManager->PauseAnimation(_paused);
}
