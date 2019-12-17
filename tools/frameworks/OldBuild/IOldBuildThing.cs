using System.Collections.Generic;
using D2L.Build.BazelGenerator.NewBuild;

namespace D2L.Build.BazelGenerator.OldBuild {
	internal interface IOldBuildThing {
		/// <summary>
		/// The location of this thing relative to the workspace root in the
		/// old build. This will be used to choose the packages for the output
		/// of Convert(). The magic value "WORKSPACE" signals that this goes
		/// into the WORKSPACE file rather than a BUILD (package).
		/// </summary>
		string LocationHint { get; }

		/// <summary>
		/// The rules that are output by this thing will exist in the same
		/// package, contiguously, in the same order that they come out of
		/// Convert(). To combine multiple old build things into the same
		/// package we use SortKey to sort the groups. This is necessary to
		/// create deterministic BUILD files, which is probably a good thing
		/// to do.
		/// </summary>
		string SortKey { get; }

		/// <summary>
		/// Create Bazel things (e.g. rules, macro calls) for this thing
		/// </summary>
		IEnumerable<INewBuildThing> Convert( Index index );
	}
}
