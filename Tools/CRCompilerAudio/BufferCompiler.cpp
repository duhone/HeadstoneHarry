#include "StdAfx.h"
#include "BufferCompiler.h"
#include "CRCompilerAudio.h"
#include "Binaryreader.h"
#include "BinaryWriter.h"

using namespace CR::Compiler;
using namespace CR::Utility;
using namespace std;
using namespace boost;
using namespace boost::filesystem;

BufferCompiler::BufferCompiler(void)
{
}

BufferCompiler::~BufferCompiler(void)
{
}

void BufferCompiler::CompileData(CR::Utility::BinaryWriter &writer)
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


void BufferCompiler::SetUpFileNames()
{
	wpath original(this->fileName);
	original.remove_leaf();
	wpath fileName(basename(this->fileName));
	wstringstream compiledFileName;
	compiledFileName << original << fileName << "_compressed.waz";

	this->fileName = Globals::Instance().Compiler()->DataPath() + this->fileName;

	this->finalFileName = Globals::Instance().Compiler()->DataPath() + compiledFileName.str();
}

void BufferCompiler::CheckFile()
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


void BufferCompiler::BuildFinal()
{	
	BinaryReader reader(fileName);

	unsigned char header[40];
	unsigned int numBytes;

	reader >> header >> numBytes;

	scoped_array<char> inputBuffer(new char[numBytes]);
	reader.Read(inputBuffer.get(),numBytes);
	
	BinaryWriter outWriter(finalFileName);

	outWriter << numBytes;
	outWriter.CompressingMode(true);
	outWriter.Write(inputBuffer.get(),numBytes);
}