namespace D2L.Build.BazelGenerator.Starlark {
	internal abstract class StarlarkExpr {
		public StarlarkComment LeadingComment { get; set; }
		public bool LineAfter { get; set; }

		public void Write( IndentingWriter writer ) {
			if( LeadingComment != null ) {
				LeadingComment.Write( writer );
			}

			WriteImpl( writer );

			if( LineAfter ) {
				writer.WriteLine();
			}
		}

		protected abstract void WriteImpl( IndentingWriter writer );
	}
}
