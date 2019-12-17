using D2L.Build.BazelGenerator.Starlark;

namespace D2L.Build.BazelGenerator.NewBuild {
	/// <summary>
	/// A "new build thing" is something we place into a BUILD(.bazel) file or the
	/// WORKSPACE file. It needs to render itself into Starlark syntax and tell
	/// the package what (if anything) to import. Each thing is one root piece
	/// of syntax.
	/// </summary>
	internal interface INewBuildThing {
		/// <summary>
		/// Get the Starlark root syntax for this thing.
		/// </summary>
		StarlarkExpr Emit( Label package );

		/// <summary>
		/// What do we need to load() for this thing?
		/// </summary>
		(Label, string) Dependency { get; }
	}
}
