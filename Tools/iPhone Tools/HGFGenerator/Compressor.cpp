#include "StdAfx.h"
#include "Compressor.h"
#include "lzmalib.h"

Compressor::Compressor(unsigned char* _source,unsigned int unCompressedSize,Syntax::Utility::BinaryWriter &_file) : m_source(_source)
{
	size_t propSize = LZMA_PROPS_SIZE;
	unsigned char *props = new unsigned char[propSize];
	unsigned int compressedSize = compressedSize*1.5;
	unsigned char* compressed = new unsigned char[compressedSize];
	
	LzmaCompress(compressed,&compressedSize,m_source,unCompressedSize,
		props,&propSize,9,128*1024,-1,-1,-1,-1,-1);

	_file.Write((char*)props,propSize);
	_file.Write((char*)compressed,compressedSize);
	delete[] props;
	delete[] compressed;
}

Compressor::~Compressor(void)
{
}
