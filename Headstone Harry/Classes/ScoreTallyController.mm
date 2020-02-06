/*
 *  ScoreTallyController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 11/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "ScoreTallyController.h"
#include "ArcadeModeController.h"
#include "ArcadeModeSaveInfo.h"
#include "SettingsSaveInfo.h"
#include "KeyboardManager.h"
#include <vector>
#include <string>
#include "Event.h"

using namespace CR::UI;
using namespace std;
using namespace CR::Sound;

extern ArcadeModeSaveInfo *arcadeModeSaveInfo;
extern SettingsSaveInfo *settingsSaveInfo;

ScoreTallyController::ScoreTallyController(IGameController *controller) : Controller2(true)
{
	m_controller = controller;
	
	m_score = 0;
	m_totalTime = 0;
	m_initials = "AAA";
	//m_initials = settingsSaveInfo->GetDefaultInitials();
	cursorPos = 2;
	m_isNewHighScore = false;
	m_scoreUploaded = false;
	
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally1::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally2::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally3::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally4::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally5::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally6::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally7::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally8::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally9::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally10::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally11::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally12::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally13::ID));
	//sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::scoretally14::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::newhighscore1::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::newhighscore2::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::newhighscore3::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::yesplayagain1::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::yesplayagain2::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::yesplayagain3::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::noplayagain1::ID));
	sounds.push_back(ISound::Instance().CreateSoundFX(CR::AssetList::sounds::noplayagain2::ID));
	
	//endGameSound = ISound::Instance().CreateSoundFX(CR::AssetList::music::BGMTimeOver::ID);
}

ScoreTallyController::~ScoreTallyController()
{
}

Control* ScoreTallyController::OnGenerateView()
{
	View *view = new View(CR::AssetList::Scores_Score_Tally_Background, 501);
	view->TouchDown += Delegate(this, &ScoreTallyController::OnViewTouched);
	
	playAgainTag = UIEngine::Instance().CreateSpriteLabel(view, CR::AssetList::Scores_Play_Again_Header, 400);
	playAgainTag->SetPosition(160, 375);
	
	yesButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Scoring_Yes_Button, 400);
	yesButton->SetPosition(40, 410);
	yesButton->TouchUpInside += Delegate(this, &ScoreTallyController::OnYesButtonTouched);
	yesButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	noButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Scoring_No_Button, 400);
	noButton->SetPosition(165, 410);
	noButton->TouchUpInside += Delegate(this, &ScoreTallyController::OnNoButtonTouched);
	noButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	initialsLabel = UIEngine::Instance().CreateTextLabel(view, CR::AssetList::High_Score_Initials_Font, 400);
	initialsLabel->SetPosition(30, 245);
	initialsLabel->SetText(m_initials);
	
	enterInitialsButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Scoring_Enter_Initials_Button, 400);
	enterInitialsButton->SetPosition(145, 225);
	enterInitialsButton->TouchUpInside += Delegate(this, &ScoreTallyController::OnEnterInitialsTouched);
	enterInitialsButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	uploadScoreButton = UIEngine::Instance().CreateButton(view, CR::AssetList::Scoring_Upload_Score_Button, 400);
	uploadScoreButton->SetPosition(50, 280);
	uploadScoreButton->TouchUpInside += Delegate(this, &ScoreTallyController::OnUploadScoreButtonTouched);
	uploadScoreButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	scoreTally = UIEngine::Instance().CreateNumberLabel(view, CR::AssetList::Scores_Score_Tally_Font, 400);
	scoreTally->SetPosition(182, 110);
	scoreTally->SetAlignment(CR::UI::AlignFontCenter);
	
	timeTag = UIEngine::Instance().CreateSpriteLabel(view, CR::AssetList::Scores_Time_Tag_2, 400);
	timeTag->SetPosition(60, 150);
	
	timeLabel = UIEngine::Instance().CreateTimeLabel(view, CR::AssetList::Scores_Time_Tally_Font, 400);
	timeLabel->SetPosition(160, 150);
	
	newHighScoreTag = UIEngine::Instance().CreateSpriteLabel(view, CR::AssetList::Scores_New_High_Score_Tag, 400);
	newHighScoreTag->SetPosition(160, 190);
	
	KeyboardManager::Instance().KeyTyped.Clear();
	KeyboardManager::Instance().KeyTyped += Delegate1<ScoreTallyController, char>(this,&ScoreTallyController::OnKeyTyped);
	KeyboardManager::Instance().KeyboardShown.Clear();
	KeyboardManager::Instance().KeyboardShown += Delegate(this, &ScoreTallyController::OnKeyboardShown);
	KeyboardManager::Instance().KeyboardHidden.Clear();
	KeyboardManager::Instance().KeyboardHidden += Delegate(this, &ScoreTallyController::OnKeyboardHidden);
	
	return view;
}

void ScoreTallyController::OnInitialized()
{
	m_initials = settingsSaveInfo->GetDefaultInitials();
	initialsLabel->SetText(m_initials);
	
	m_score = m_controller->GetScore();
	m_totalTime = m_controller->GetTotalTime();
	
	scoreTally->SetValue(m_score);
	timeLabel->SetSeconds(m_totalTime);
	m_scoreUploaded = false;
	
	//SaveHighScore();
	
	// determine if this is a new high score
	int TOTAL_HIGHSCORES = 10;
	vector<int> highScores = arcadeModeSaveInfo->GetHighScores();
	for (int i = 0; i < TOTAL_HIGHSCORES; i++)
	{
		if (m_score > highScores[i])
		{
			m_isNewHighScore = true;
			break;
		}
	}
	
	// Show/Hide new high score tag
	if (m_isNewHighScore)
	{
		newHighScoreTag->Visible(true);

		int iSnd = (rand() % 3) + 3;
		sounds[iSnd]->Play();
	}
	else
	{
		newHighScoreTag->Visible(false);
		
		int iSnd = rand() % 3;
		sounds[iSnd]->Play();
	}
	
	//ISound::Instance().PlaySong(CR::AssetList::music::BGMTimeOver::ID);
	//endGameSound->Play();
}

void ScoreTallyController::OnDestroyed()
{
}

void ScoreTallyController::OnBeforeUpdate()
{
}

void ScoreTallyController::OnYesButtonTouched()
{
	SaveHighScore();
	
	int iSnd = (rand() % 3) + 6;
	sounds[iSnd]->Play();
	
	m_controller->OnResetGame();
}

void ScoreTallyController::OnNoButtonTouched()
{
	SaveHighScore();
	
	int iSnd = (rand() % 2) + 9;
	sounds[iSnd]->Play();
	
	m_controller->OnExitGame();
}

void ScoreTallyController::OnEnterInitialsTouched()
{
	//[textField becomeFirstResponder];
	m_initials[0] = '_';
	m_initials[1] = '_';
	m_initials[2] = '_';
	initialsLabel->SetText(m_initials);
	
	cursorPos = 0;
	KeyboardManager::Instance().ShowKeyboard();
	KeyboardManager::Instance().SetEditText("");
}

void ScoreTallyController::SaveHighScore()
{
	int TOTAL_HIGHSCORES = 10;
	vector<int> highScores = arcadeModeSaveInfo->GetHighScores();
	vector<string> highScoresInitials = arcadeModeSaveInfo->GetHighScoresInitials();
	
	// Calculate if this is a high score
	for (int i = 0; i < TOTAL_HIGHSCORES; i++)
	{
		if (m_score > highScores[i])
		{
			// Spot found, shift all other scores down
			for (int j = TOTAL_HIGHSCORES - 1; j > i; j--)
			{
				highScores[j] = highScores[j - 1];
				highScoresInitials[j] = highScoresInitials[j - 1];
			}
			
			// Save the new high score
			highScores[i] = m_score;
			highScoresInitials[i] = m_initials;
			m_isNewHighScore = true;
			break;
		}
	}
	
	arcadeModeSaveInfo->SetHighScores(highScores);
	arcadeModeSaveInfo->SetHighScoresInitials(highScoresInitials);
}


void ScoreTallyController::OnUploadScoreButtonTouched()
{
	if (!m_scoreUploaded)
	{
		SubmitHighScoreToLeaderboard(m_initials, m_score, "http://www.conjuredrealms.com");
	}
	else
	{
		UIAlertView * alert = [[UIAlertView alloc]
							   initWithTitle:@"Score Already Submitted"
							   message:@"This score has already been submitted!"
							   delegate:KeyboardManager::Instance().GetMainView() 
							   cancelButtonTitle:@"Ok"
							   otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}

}

void ScoreTallyController::SubmitHighScoreToLeaderboard(string _name, float _score, string _url)
{
	NSString *name = [[[NSString alloc] initWithCString: _name.c_str()] uppercaseString];
	
	NSString *url = [[NSString alloc] initWithCString:_url.c_str()];
	float score = _score;
	NSString *appKey = @"0a2adf2b279dcb734f23fd1e79e6f43d";
	NSString *urlString = [NSString stringWithFormat:@"http://iphonelb.com/ws?app_key=%@&name=%@&score=%f&url=%@",appKey, name,score,url];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	NSData	     *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; // the response .. what to do?
	
	if ([response length] <= 0) // connection failed
	{
		UIAlertView * alert = [[UIAlertView alloc]
							   initWithTitle:@"Submission Failed"
							   message:@"There was an error submitting your score."
							   delegate:KeyboardManager::Instance().GetMainView() 
							   cancelButtonTitle:@"Ok"
							   otherButtonTitles:nil];
		[alert show];
		[alert release];
		m_scoreUploaded = false;
	}
	else // connection success
	{
		UIAlertView * alert = [[UIAlertView alloc]
							   initWithTitle:@"Score Submitted"
							   message:@"Your score was submitted successfully!"
							   delegate:KeyboardManager::Instance().GetMainView() 
							   cancelButtonTitle:@"Ok"
							   otherButtonTitles:nil];
		[alert show];
		[alert release];
		m_scoreUploaded = true;
	}

	
}

void ScoreTallyController::OnViewTouched()
{
	KeyboardManager::Instance().HideKeyboard();
}

void ScoreTallyController::OnKeyboardShown()
{
	enterInitialsButton->Enabled(false);
}

void ScoreTallyController::OnKeyboardHidden()
{
	enterInitialsButton->Enabled(true);
	settingsSaveInfo->SetDefaultInitials(m_initials);
}

void ScoreTallyController::OnKeyTyped(char key)
{
	// backspace
	if (key == NULL)
	{
		m_initials[cursorPos] = '_';
		
		if (cursorPos > 0)
			cursorPos--;
	}
	else if (key == ' ')
	{
		m_initials[cursorPos] = '_';
		
		if (cursorPos < 2)
			cursorPos++;
	}
	else 
	{
		m_initials[cursorPos] = key;

		if (cursorPos < 2)
			cursorPos++;
	}

	initialsLabel->SetText(m_initials);
}
 