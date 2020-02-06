/*
 *  HelpMenuController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/29/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "HelpMenuController.h"
#include "AssetList.h"
using namespace CR::UI;

HelpMenuController::HelpMenuController(bool skipCredits) : Controller2(true) // TODO: This should be true to make the menu stay in memory!
{
	//InitializeView(OnGenerateView(), true);
	m_skipCredits = skipCredits;
	
	m_credits = !m_skipCredits;
}

HelpMenuController::~HelpMenuController()
{
}

Control* HelpMenuController::OnGenerateView()
{
	View *view = new View(CR::AssetList::InfoHelp_Credits, 500);
	view->BeforeUpdate += Delegate(this, &HelpMenuController::OnBeforeUpdate);
	
	exitButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Options_Exit_Button, 400);
	exitButton->SetPosition(100, 426);
	exitButton->TouchUpInside += Delegate(this, &HelpMenuController::OnExitButtonTouched);
	exitButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	mainMenuButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Options_Exit_Button, 400);
	mainMenuButton->SetPosition(10, 426);
	mainMenuButton->TouchUpInside += Delegate(this, &HelpMenuController::OnExitButtonTouched);
	mainMenuButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	howToPlayButton = UIEngine::Instance().CreateButton(view, CR::AssetList::InfoHelp_How_to_Play_Button, 400);
	howToPlayButton->SetPosition(136, 432);
	howToPlayButton->TouchUpInside += Delegate(this, &HelpMenuController::OnHowToPlayTouched);
	howToPlayButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	leftButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Scrapbook_LArrow_Button, 400);
	leftButton->SetPosition(2, 432);
	leftButton->TouchUpInside += Delegate(this, &HelpMenuController::OnLeftTouched);
	leftButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	rightButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Scrapbook_RArrow_Button, 400);
	rightButton->SetPosition(221, 432);
	rightButton->TouchUpInside += Delegate(this, &HelpMenuController::OnRightTouched);
	rightButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	imageCycler = UIEngine::Instance().CreateImageCycler(view, 450);
	imageCycler->SetPosition(160, 240);
	imageCycler->AddImage(CR::AssetList::InfoHelp_Credits);
	imageCycler->AddImage(CR::AssetList::InfoHelp_Help1);
	imageCycler->AddImage(CR::AssetList::InfoHelp_Help2);
	imageCycler->AddImage(CR::AssetList::InfoHelp_Help3);
	//imageCycler->AddImage(CR::AssetList::InfoHelp_Help4);
	
	return view;
}

void HelpMenuController::OnInitialized()
{
	m_credits = !m_skipCredits;
	
	if (m_credits)
	{
		imageCycler->CurrentPage(0);
	}
	else {
		imageCycler->CurrentPage(1);
	}

}

void HelpMenuController::OnDestroyed()
{
}

void HelpMenuController::OnBeforeUpdate()
{		
	// Display buttons based on menu mode
	leftButton->Visible(!m_credits && imageCycler->CurrentPage() != 1);
	leftButton->Enabled(!m_credits && imageCycler->CurrentPage() != 1);
	rightButton->Visible(!m_credits && imageCycler->CurrentPage() != imageCycler->TotalPages()-1);
	rightButton->Enabled(!m_credits && imageCycler->CurrentPage() != imageCycler->TotalPages()-1);
	mainMenuButton->Visible(m_credits);
	mainMenuButton->Enabled(m_credits);
	exitButton->Visible(!m_credits);
	exitButton->Enabled(!m_credits);
	howToPlayButton->Visible(m_credits);
	howToPlayButton->Enabled(m_credits);
}

void HelpMenuController::OnExitButtonTouched()
{
	SetRequestState(0);
}

void HelpMenuController::OnLeftTouched()
{
	imageCycler->Prev();
	
	// if the credits screen is no longer showing, skip its page
	if (imageCycler->CurrentPage() == 0)
		imageCycler->Prev();
}

void HelpMenuController::OnRightTouched()
{
	imageCycler->Next();
	
	// if the credits screen is no longer showing, skip its page
	if (imageCycler->CurrentPage() == 0)
		imageCycler->Next();
}

void HelpMenuController::OnHowToPlayTouched()
{
	m_credits = false;
	imageCycler->Next();
}