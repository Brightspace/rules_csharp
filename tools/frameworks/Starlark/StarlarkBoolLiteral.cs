namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class StarlarkBoolLiteral : StarlarkExpr {
		public static readonly StarlarkBoolLiteral True = new StarlarkBoolLiteral( true );
		public static readonly StarlarkBoolLiteral False = new StarlarkBoolLiteral( false );

		private StarlarkBoolLiteral( bool value ) {
			Value = value;
		}

		public bool Value { get; }

		protected override void WriteImpl( IndentingWriter writer ) {
			if ( Value ) {
				writer.Write( "True" );
			} else {
				writer.Write( "False" );
			}
		}
	}
}
