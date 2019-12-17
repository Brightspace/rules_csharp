using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using D2L.Build.BazelGenerator.NewBuild;

namespace D2L.Build.BazelGenerator.Starlark {
	internal static class ExtensionsForStarlark {
		#region Convert non-Starlark things into Starlark

		public static StarlarkStringLiteral ToStarlark(
			this Label label,
			Label relativeTo
		) {
			return label
				.ToStringRelativeTo( relativeTo )
				.ToStarlark();
		}

		public static IEnumerable<StarlarkExpr> ToStarlark(
			this IEnumerable<string> strs
		) {
			return strs.Select( str => str.ToStarlark() );
		}

		public static StarlarkArrayLiteral ToStarlark(
			this IEnumerable<Label> labels,
			Label relativeTo
		) {
			return new StarlarkArrayLiteral(
				labels.Select( l => l.ToStarlark( relativeTo ) )
			);
		}

		public static StarlarkDictLiteral ToStarlark(
			this IDictionary<string, Label> strs, Label packagePath
		) {
			return new StarlarkDictLiteral(
				strs.OrderBy( p => p.Key ).Select( p => (
						(StarlarkExpr)p.Value.ToStarlark( relativeTo: packagePath ),
						(StarlarkExpr)p.Key.ToStarlark()
					) ).ToImmutableArray()
			);
		}

		#endregion

		#region Creating StarlarkArguments from StarlarkExprs

		public static StarlarkArgument ToArgument(
			this StarlarkExpr expr,
			StarlarkComment comment = null
		) {
			return new StarlarkArgument( expr, comment );
		}

		// used for starlark calls that use variadic arguments
		public static IEnumerable<StarlarkArgument> ToArguments(
			this IEnumerable<StarlarkExpr> exprs
		) {
			return exprs.Select( expr => new StarlarkArgument( expr ) );
		}

		#endregion

		#region Method-chaining wrappers

		// these exist as alternatives to constructors for when you want to
		// chain method calls together.

		public static StarlarkStringLiteral ToStarlark( this string str) 
			=> new StarlarkStringLiteral( str );

		public static StarlarkArrayLiteral IntoArray(
			this IEnumerable<StarlarkExpr> exprs
		) => new StarlarkArrayLiteral( exprs );

		// singleton array
		public static StarlarkArrayLiteral IntoArray(
			this StarlarkExpr expr
		) => new StarlarkArrayLiteral( expr );

		public static StarlarkArgument ToArgument(
			this StarlarkExpr expr,
			string paramName,
			StarlarkComment comment = null
		) => new StarlarkArgument( paramName, expr, comment );

		#endregion
	}
}
