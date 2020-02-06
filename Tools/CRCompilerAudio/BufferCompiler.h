#pragma once
#include "inodecompiler.h"

namespace CR
{
	namespace Compiler
	{
		class BufferCompiler :
			public CR::Compiler::INodeCompiler
		{
		public:
			BufferCompiler(void);
			virtual ~BufferCompiler(void);
			virtual std::wstring IndexName() {return name;}
			virtual void CompileData(CR::Utility::BinaryWriter &writer);
			void FileName(std::wstring fileName) {this->fileName = fileName;}
		private:
			void SetUpFileNames();
			void CheckFile();
			void BuildFinal();
			bool needsToUpdate;
			std::wstring fileName;
			std::wstring finalFileName;
		};
	}
}
