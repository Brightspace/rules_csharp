using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using D2L.Build.BazelGenerator.Starlark;

namespace D2L.Build.BazelGenerator.NewBuild {
	/// <summary>
	/// A package is a folder containing a BUILD file. This class get's reused
	/// to implement Workspace (which isn't actually a package).
	/// </summary>
	internal class Package {
		private readonly ImmutableArray<INewBuildThing> m_things;

		public Package(
			Label location,
			IEnumerable<INewBuildThing> things
		) : this( location, things.ToImmutableArray() ) { }

		public Package(
			string packagePath,
			ImmutableArray<INewBuildThing> things
		) : this( new Label( packagePath, "BUILD.bazel" ), things ) { }

		public Package(
			Label location,
			ImmutableArray<INewBuildThing> things,
			params string[] leadingComments
		) {
			Location = location;
			m_things = things;
			LeadingComments = leadingComments.ToImmutableArray();
		}

		public Label Location { get; }
		public ImmutableArray<string> LeadingComments { get; }

		public void Write( string workspaceRoot ) {
			var path = Path.Combine(
				workspaceRoot, Location.Package,
				Location.Target
			);

			WriteCustomOutputPath( path );
		}

		/// <summary>
		/// Use this overload if you want to write the build file to a special location.
		/// </summary>
		public void WriteCustomOutputPath( string path ) {
			using( var writer = new IndentingWriter( path ) ) {
				var contents = Emit();
				contents.Write( writer );
			}
		}

		public StarlarkModule Emit() {
			return new StarlarkModule(
				GetExprs().ToImmutableArray(),
				LeadingComments.Select( c => new StarlarkComment( c ) ).ToImmutableArray()
			);
		}

		protected virtual IEnumerable<StarlarkExpr> GetExprs() {
			// Collect all the stuff to load() so that there is one load per
			// library, the symbols in one load() are sorted and all loads()
			// are sorted by the library label.
			ImmutableSortedDictionary<Label, ImmutableSortedSet<string>> thingsToImport = m_things
				.Where( IsntANativeFunction )
				.Select( thing => (Library: thing.Dependency.Item1, Symbol: thing.Dependency.Item2) )
				.GroupBy( x => x.Library )
				.ToImmutableSortedDictionary(
					keySelector: group => group.Key,
					elementSelector: group => group
						.Select( x => x.Symbol )
						.ToImmutableSortedSet()
				);

			// Emit the load()s
			foreach( var import in thingsToImport ) {
				yield return StarlarkFunctionCall.Load(
					bzlModule: import.Key,
					symbols: import.Value,
					package: Location
				);
			}

			// Emit the things
			foreach( var thing in m_things ) {
				yield return thing.Emit( Location );
			}
		}

		private static bool IsntANativeFunction( INewBuildThing dep ) {
			return dep.Dependency.Item1 != Label.NativeFunctions;
		}
	}
}
