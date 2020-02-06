#include "StdAfx.h"
#include "SongCompiler.h"
#include "CRCompilerAudio.h"
#include "Binaryreader.h"
#include "BinaryWriter.h"

using namespace CR::Compiler;
using namespace CR::Utility;
using namespace std;
using namespace boost;
using namespace boost::filesystem;

SongCompiler::SongCompiler(void)
{
}

SongCompiler::~SongCompiler(void)
{
}

void SongCompiler::CompileData(CR::Utility::BinaryWriter &writer)
{
	SetUpFileNames();
	CheckFile();
	if(needsToUpdate)
	{
		//Sleep(100);
		BuildFinal();
	}
	
	unsigned long inputFileSize = static_cast<unsigned long>(file_size(finalFileName));
	scoped_array<char> inputBuffer(new char[inputFileSize]);
	ifstream inputFile(finalFileName.c_str(),ios::in | ios::binary);
	inputFile.read(inputBuffer.get(),inputFileSize);
	writer << inputFileSize;
	writer.Write(inputBuffer.get(),inputFileSize);
}


void SongCompiler::SetUpFileNames()
{
	wpath original(this->fileName);
	original.remove_leaf();
	wpath fileName(basename(this->fileName));
	wstringstream compiledFileName;
	compiledFileName << original << fileName << "_compressed.aaz";

	this->fileName = Globals::Instance().Compiler()->DataPath() + this->fileName;

	this->finalFileName = Globals::Instance().Compiler()->DataPath() + compiledFileName.str();
}

void SongCompiler::CheckFile()
{
	if(Globals::Instance().Compiler()->SettingExists(L"rebuild"))
	{
		needsToUpdate = true;
		return;
	}
	needsToUpdate = false;
	wpath finalPath(finalFileName);
	if(!exists(finalPath))
	{
		needsToUpdate = true;
		return;
	}
	wpath origPath(fileName);
	time_t originalFileTime = last_write_time(origPath);
	time_t finalFileTime = last_write_time(finalPath);
	if(originalFileTime > finalFileTime)
		needsToUpdate = true;
}


void SongCompiler::BuildFinal()
{	
	unsigned long inputFileSize = static_cast<unsigned long>(file_size(fileName));
	
	BinaryReader reader(fileName);

	scoped_array<char> inputBuffer(new char[inputFileSize]);
	reader.Read(inputBuffer.get(),inputFileSize);

	BinaryWriter outWriter(finalFileName);

	outWriter << inputFileSize;
	outWriter << m_length;
	outWriter.CompressingMode(true);
	outWriter.Write(inputBuffer.get(),inputFileSize);
}