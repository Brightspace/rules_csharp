namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class StarlarkComment {
		public StarlarkComment( string contents ) {
			Contents = contents;
		}

		public static implicit operator StarlarkComment( string contents ) =>
			new StarlarkComment( contents );

		public string Contents { get; }

		public void Write( IndentingWriter writer ) {
			foreach( var line in Contents.Split( '\n' ) ) {
				writer.Write( "# " );
				writer.WriteLine( line );
			}
		}
	}
}
