#pragma once
#include "c:\source\bumbletales\trunk\tools\crcompilerlibrary\inodecompiler.h"

namespace CR
{
	namespace Compiler
	{
		class SoundCompiler :
			public CR::Compiler::INodeCompiler
		{
		public:
			SoundCompiler(void);
			virtual ~SoundCompiler(void);
			virtual std::wstring IndexName() {return name;}
			virtual void CompileData(CR::Utility::BinaryWriter &writer);
			void Buffer(CR::Utility::Guid &_buffer) {m_buffer = _buffer;}
		private:			
			CR::Utility::Guid m_buffer;
		};
	}
}
