/*
 *  HighScoresMenuController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/5/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "HighScoresMenuController.h"
#include "ArcadeModeSaveInfo.h"
#include <string>
using namespace std;

extern ArcadeModeSaveInfo *arcadeModeSaveInfo;

HighScoresMenuController::HighScoresMenuController() : Controller2(true) // TODO: This should be true to make the menu stay in memory!
{
	//InitializeView(OnGenerateView(), true);
}

HighScoresMenuController::~HighScoresMenuController()
{
}

Control* HighScoresMenuController::OnGenerateView()
{
	View *view = new View(CR::AssetList::High_Score_Background, 500);
	view->BeforeUpdate += Delegate(this, &HighScoresMenuController::OnBeforeUpdate);
	
	exitButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Options_Exit_Button, 400);
	exitButton->SetPosition(212, 426);
	exitButton->TouchUpInside += Delegate(this, &HighScoresMenuController::OnExitButtonTouched);
	exitButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	//uploadScoresButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Scoring_Upload_Score_Button, 400);
	//uploadScoresButton->SetPosition(50, 70);
	//uploadScoresButton->TouchUpInside += Delegate(this, &HighScoresMenuController::OnUploadScoresButtonTouched);
	//uploadScoresButton->SetSoundTouchDown(CR::AssetList::sounds::tile_bass::ID);
	
	leaderboardsButton = UIEngine::Instance().CreateButton(view, CR::AssetList::High_Score_Leaderboards_Button, 400);
	leaderboardsButton->SetPosition(15, 426);
	leaderboardsButton->TouchUpInside += Delegate(this, &HighScoresMenuController::OnLeaderboardsButtonTouched);
	leaderboardsButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	// High Scores Listing
	vector<int> highScores = arcadeModeSaveInfo->GetHighScores();
	vector<string> initials = arcadeModeSaveInfo->GetHighScoresInitials();
	
	int xOffset = 60;
	int yOffset = 50;
	int yMod = 36;
	int TOTAL_HIGHSCORES = 10;
	for (int i = 0; i < TOTAL_HIGHSCORES; i++)
	{
		CR::UI::NumberLabel *numLabel = UIEngine::Instance().CreateNumberLabel(view, CR::AssetList::High_Score_Font, 400);
		numLabel->SetPosition(xOffset, yOffset  + (yMod * (i + 1)));
		numLabel->SetAlignment(AlignFontRight);
		numLabel->SetValue(highScores[i]);
		numberLabels.push_back(numLabel);
		
		CR::UI::TextLabel *txtLabel = UIEngine::Instance().CreateTextLabel(view, CR::AssetList::High_Score_Initials_Font, 400);
		txtLabel->SetPosition(xOffset + 170, yOffset  + (yMod * (i + 1)));
		txtLabel->SetText(initials[i]);
		initialsLabels.push_back(txtLabel);
	}
	
	
	return view;
}

void HighScoresMenuController::OnInitialized()
{
}

void HighScoresMenuController::OnDestroyed()
{
}

void HighScoresMenuController::OnBeforeUpdate()
{
}

void HighScoresMenuController::OnExitButtonTouched()
{
	SetRequestState(0);
}

void HighScoresMenuController::OnLeaderboardsButtonTouched()
{
	[[UIApplication sharedApplication] openURL:[[NSURL alloc]  initWithString: @"http://iphonelb.com/lb/Headstone_Harry"]];
}

/*
void HighScoresMenuController::OnUploadScoresButtonTouched()
{
	vector<int> highScores = arcadeModeSaveInfo->GetHighScores();
	vector<string> highScoresInitials = arcadeModeSaveInfo->GetHighScoresInitials();
	
	for (int i = 0; i < 8; i++)
	{
		if (highScores[i] > 0)
		{
			SubmitHighScoreToLeaderboard(highScoresInitials[i], highScores[i], "http://www.conjuredrealms.com");
		}
	}
}
*/

/*
void HighScoresMenuController::SubmitHighScoreToLeaderboard(string _name, float _score, string _url)
{
	NSString *name = [[NSString alloc] initWithCString: _name.c_str()];
	NSString *url = [[NSString alloc] initWithCString:_url.c_str()];
	float score = _score;
	
	NSString *appKey = @"0a2adf2b279dcb734f23fd1e79e6f43d";
	NSString *urlString = [NSString stringWithFormat:@"http://iphonelb.com/ws?app_key=%@&name=%@&score=%f&url=%@",appKey,
						   name,score,url];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	NSData	     *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; // the response .. what to do?
}
 */
