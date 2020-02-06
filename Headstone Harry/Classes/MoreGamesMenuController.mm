/*
 *  MoreGamesMenuController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/29/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "MoreGamesMenuController.h"

extern CR::Graphics::GraphicsEngine *graphics_engine;

MoreGamesMenuController::MoreGamesMenuController() : Controller2(true) // TODO: This should be true to make the menu stay in memory!
{
	//InitializeView(OnGenerateView(), true);
}

MoreGamesMenuController::~MoreGamesMenuController()
{
}

Control* MoreGamesMenuController::OnGenerateView()
{
	View* view = new View(CR::AssetList::InfoHelp_More_Games_Background, 1000);
	
	//spriteLabel = UIEngine::Instance().CreateSpriteLabel(view, CR::AssetList::InfoHelp_More_Games_Background, 800);
	//spriteLabel->SetPosition(160, 40);
	
	exitButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Options_Exit_Button, 800);
	exitButton->SetPosition(112, 426);
	exitButton->TouchUpInside += Delegate(this, &MoreGamesMenuController::OnExitButtonTouched);
	exitButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	BTalesButton = UIEngine::Instance().CreateButton(view, CR::AssetList::InfoHelp_BumbleTales_Button, 800);
	BTalesButton->SetPosition(10, 72);
	BTalesButton->TouchUpInside += Delegate(this, &MoreGamesMenuController::OnBTalesTouched);
	BTalesButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	BoBButton = UIEngine::Instance().CreateButton(view, CR::AssetList::InfoHelp_BoB_Button, 800);
	BoBButton->SetPosition(10, 162);
	BoBButton->TouchUpInside += Delegate(this, &MoreGamesMenuController::OnBoBTouched);
	BoBButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	AFTBButton = UIEngine::Instance().CreateButton(view, CR::AssetList::InfoHelp_AFTB_Button, 800);
	AFTBButton->SetPosition(10, 252);
	AFTBButton->TouchUpInside += Delegate(this, &MoreGamesMenuController::OnAFTBTouched);
	AFTBButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	BoB2Button = UIEngine::Instance().CreateButton(view, CR::AssetList::InfoHelp_BoB2_Button, 800);
	BoB2Button->SetPosition(10, 342);
	BoB2Button->TouchUpInside += Delegate(this, &MoreGamesMenuController::OnBoB2Touched);
	BoB2Button->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	return view;
}

void MoreGamesMenuController::OnInitialized()
{
}

void MoreGamesMenuController::OnDestroyed()
{
}

void MoreGamesMenuController::OnExitButtonTouched()
{
	SetRequestState(0);
}

void MoreGamesMenuController::OnAFTBTouched()
{
	[[UIApplication sharedApplication] openURL:[[NSURL alloc]  initWithString: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=299230440&mt=8"]];
}

void MoreGamesMenuController::OnBoBTouched()
{
	[[UIApplication sharedApplication] openURL:[[NSURL alloc]  initWithString: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=308315671&mt=8"]];
}

void MoreGamesMenuController::OnBTalesTouched()
{
	[[UIApplication sharedApplication] openURL:[[NSURL alloc]  initWithString: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=329689994?mt=8"]];
}

void MoreGamesMenuController::OnBoB2Touched()
{
	[[UIApplication sharedApplication] openURL:[[NSURL alloc]  initWithString: @"http://www.twitter.com/conjuredrealms"]];
}