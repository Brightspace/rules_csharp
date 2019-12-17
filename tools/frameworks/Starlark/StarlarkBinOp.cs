using System.Collections.Generic;
using System.Linq;

namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class StarlarkBinOp : StarlarkExpr {
		public StarlarkBinOp(
			string op,
			StarlarkExpr left,
			StarlarkExpr right
		) {
			Operation = op;
			Left = left;
			Right = right;
		}

		public string Operation { get; }
		public StarlarkExpr Left { get; }
		public StarlarkExpr Right { get; }

		protected override void WriteImpl( IndentingWriter writer ) {
			writer.Write( Left );
			writer.Write( ' ' );
			writer.Write( Operation );
			writer.Write( ' ' );
			writer.Write( Right );
		}
	}

	// TODO: move into the other file once its merged
	internal static class Extensions {
		public static StarlarkExpr Join(
			IEnumerable<StarlarkExpr> exprs,
			string op
		) => exprs.Aggregate( ( l, r ) => new StarlarkBinOp( op, l, r ) );
	}
}
