namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class StarlarkStringLiteral : StarlarkExpr {
		public StarlarkStringLiteral( string value ) {
			Value = value;
		}

		public string Value { get; }

		protected override void WriteImpl( IndentingWriter writer ) {
			writer.Write( '"' );
			writer.Write( Value );
			writer.Write( '"' );
		}
	}
}
