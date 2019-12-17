using System;
using System.IO;

namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class IndentingWriter : IDisposable {
		private readonly StreamWriter m_writer;
		private bool m_startOfLine = true;
		private int m_indentLevel = 0;

		public IndentingWriter( string filePath ) {
			m_writer = new StreamWriter( filePath );
		}

		public IndentingWriter( StreamWriter writer ) {
			m_writer = writer;
		}

		public void Write<T>( T t ) {
			WriteIndentIfNecessary();
			m_writer.Write( t );
		}

		public void WriteLine<T>( T t ) {
			WriteIndentIfNecessary();
			m_writer.WriteLine( t );
			m_startOfLine = true;
		}

		public void WriteLine() {
			WriteIndentIfNecessary();
			m_writer.WriteLine();
			m_startOfLine = true;
		}

		public void Indent() {
			m_indentLevel += 1;
		}

		public void Unindent() {
			if( m_indentLevel == 0 ) {
				throw new Exception( "Indent underflow" );
			}

			m_indentLevel -= 1;
		}

		private void WriteIndentIfNecessary() {
			if( !m_startOfLine ) {
				return;
			}

			WriteIndent();
			m_startOfLine = false;
		}

		private void WriteIndent() {
			m_writer.Write( new string( ' ', 4 * m_indentLevel ) );
		}

		public void Dispose() {
			m_writer.Dispose();
		}
	}
}
