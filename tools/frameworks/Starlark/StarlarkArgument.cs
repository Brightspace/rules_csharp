namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class StarlarkArgument {
		public StarlarkArgument(
			string paramName,
			StarlarkExpr argExpr,
			StarlarkComment comment = null
		) {
			ParamName = paramName;
			ArgExpr = argExpr;
			Comment = comment;
		}

		public StarlarkArgument(
			StarlarkExpr argExpr,
			StarlarkComment comment = null
		) : this( string.Empty, argExpr, comment ) {
		}

		public string ParamName { get; }
		public StarlarkExpr ArgExpr { get; }
		public StarlarkComment Comment { get; set; }
	}
}
