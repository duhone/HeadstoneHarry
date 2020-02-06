/*
 *  Control.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/28/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "Control.h"
using namespace CR::UI;

Control::Control()
{
	m_enabled = true;
	m_visible = true;
	m_paused = false;
	
	bounds.left = 0;   // x
	bounds.top = 0;    // y
	bounds.right = 0;  // width
	bounds.bottom = 0; // height
}

Control::~Control()
{
	DeleteControlTree();
}

void Control::SetPosition(float x, float y)
{
	bounds.left = x;
	bounds.top = y;
	OnSetPosition(x, y);
}

void Control::SetBounds(float width, float height)
{
	bounds.right = width;
	bounds.bottom = height;
	OnSetBounds(width, height);
}

/*
void Control::SetBounds(float left, top, width, height)
{
	bounds.left = left;
	bounds.top = top;
	bounds.right = width;
	bounds.bottom = height;
	OnSetBounds(left, top, width, height);
}
*/

bool Control::Enabled()
{
	return m_enabled;
}

void Control::Enabled(bool _enabled)
{
	m_enabled = _enabled;
}

bool Control::Visible()
{
	return m_visible;
}

void Control::Visible(bool _visible)
{
	m_visible = _visible;
}

bool Control::Paused()
{
	return m_paused;
}

void Control::Paused(bool _paused)
{
	m_paused = _paused;
	
	OnPaused(_paused);
}

vector<Control*> &Control::GetChildren()
{
	return m_children;
}

void Control::Update()
{
	if (m_paused) return;
	
	BeforeUpdate();
	OnBeforeUpdate();
	UpdateControlTree();
}

void Control::Render()
{
	if (!m_visible) return;
	
	OnBeforeRender();
	RenderControlTree();
	AfterRender();
}

void Control::UpdateControlTree()
{
	if (m_children.size() <= 0) return;
	
	for (vector<Control*>::iterator it = m_children.begin(); it != m_children.end(); it++)
	{
		(*it)->Update();
	}
}

void Control::RenderControlTree()
{
	if (m_children.size() <= 0) return;
	
	for (vector<Control*>::iterator it = m_children.begin(); it != m_children.end(); it++)
	{
		(*it)->Render();
	}
}

void Control::DeleteControlTree()
{
	// This will call the destructor of child controls which call call their destructors and so on
	for (int i = 0; i < m_children.size(); i++)
		delete m_children[i];
}