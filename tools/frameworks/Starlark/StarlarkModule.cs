using System.Collections.Immutable;

namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class StarlarkModule {
		public StarlarkModule(
			ImmutableArray<StarlarkExpr> stmts,
			ImmutableArray<StarlarkComment>? leadingComments = null
		) {
			Statements = stmts;

			LeadingComments = leadingComments.HasValue
				? leadingComments.Value
				: ImmutableArray<StarlarkComment>.Empty;
		}

		public ImmutableArray<StarlarkComment> LeadingComments { get; }
		public ImmutableArray<StarlarkExpr> Statements { get; }

		public void Write( IndentingWriter writer ) {
			if ( LeadingComments.Length != 0 ) {
				foreach( var comment in LeadingComments ) {
					comment.Write( writer );
				}

				writer.WriteLine();
			}

			for( int i = 0; i < Statements.Length; i++ ) {
				Statements[i].Write( writer );

				if( i != Statements.Length - 1 ) {
					writer.WriteLine( "" );
				}
			}
		}
	}
}
