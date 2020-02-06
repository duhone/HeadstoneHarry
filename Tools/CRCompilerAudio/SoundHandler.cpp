#include "StdAfx.h"
#include "SoundHandler.h"
#include "SoundCompiler.h"

using namespace CR::Compiler;
using namespace CR::Utility;

SoundHandler::SoundHandler(void)
{
}

SoundHandler::~SoundHandler(void)
{
}

void SoundHandler::HandleAttribute(const std::wstring &name,const std::wstring& value)
{
	if(name == L"name")
		compiler->Name(value);
	if(name == L"id")
		compiler->Index(value);
	else if(name == L"buffer")
		compiler->Buffer(Guid(value));
}

INodeCompiler* SoundHandler::StartElement()
{
	compiler = new SoundCompiler();
	return compiler;
}