#pragma once
#include "c:\source\bumbletales\trunk\tools\crcompilerlibrary\inodecompiler.h"

namespace CR
{
	namespace Compiler
	{
		class SongCompiler :
			public CR::Compiler::INodeCompiler
		{
		public:
			SongCompiler(void);
			virtual ~SongCompiler(void);
			virtual std::wstring IndexName() {return name;}
			virtual void CompileData(CR::Utility::BinaryWriter &writer);
			void FileName(std::wstring fileName) {this->fileName = fileName;}
			void Length(float _length) {m_length = _length;}
		private:
			void SetUpFileNames();
			void CheckFile();
			void BuildFinal();
			bool needsToUpdate;
			std::wstring fileName;
			std::wstring finalFileName;
			float m_length;
		};
	}
}
