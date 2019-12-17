using System.Collections.Generic;
using System.Collections.Immutable;

namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class StarlarkArrayLiteral : StarlarkExpr {
		public StarlarkArrayLiteral(
			params StarlarkExpr[] elements
		) : this( elements.ToImmutableArray() ) { }

		public StarlarkArrayLiteral(
			IEnumerable<StarlarkExpr> elements
		) : this( elements.ToImmutableArray() ) { }

		public StarlarkArrayLiteral(
			ImmutableArray<StarlarkExpr> elements
		) {
			Elements = elements;
		}

		public ImmutableArray<StarlarkExpr> Elements { get; }

		protected override void WriteImpl( IndentingWriter writer ) {
			writer.Write( '[' );

			// empty array: []
			if( Elements.Length == 0 ) {
				writer.Write( ']' );
				return;
			}

			// Single element array: [x]
			if( Elements.Length == 1 ) {
				Elements[0].Write( writer );
				writer.Write( ']' );
				return;
			}

			// General case: split over multiple indented lines
			writer.WriteLine();
			writer.Indent();

			foreach( var elem in Elements ) {
				elem.Write( writer );
				writer.WriteLine( ',' );
			}

			writer.Unindent();
			writer.Write( ']' );
		}
	}
}
