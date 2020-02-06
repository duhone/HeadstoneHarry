#include "StdAfx.h"
#include "SoundCompiler.h"

using namespace CR::Compiler;

SoundCompiler::SoundCompiler(void)
{
}

SoundCompiler::~SoundCompiler(void)
{
}

void SoundCompiler::CompileData(CR::Utility::BinaryWriter &writer)
{
	writer << m_buffer;
}