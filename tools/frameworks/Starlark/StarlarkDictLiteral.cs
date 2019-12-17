using System.Collections.Immutable;

namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class StarlarkDictLiteral : StarlarkExpr {

		public StarlarkDictLiteral( ImmutableArray<(StarlarkExpr, StarlarkExpr)> value ) {
			Value = value;
		}

		public ImmutableArray<(StarlarkExpr, StarlarkExpr)> Value { get; }

		protected override void WriteImpl( IndentingWriter writer ) {
			
			writer.WriteLine( "{" );
			writer.Indent();
			foreach( var pair in Value ) {
				pair.Item1.Write( writer );
				writer.Write( ": " );
				pair.Item2.Write( writer );
				writer.WriteLine( "," );
			}
			writer.Unindent();
			writer.Write( "}" );
		}
	}
}
