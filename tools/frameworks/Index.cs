using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using D2L.Build.BazelGenerator.NewBuild;
using D2L.Build.BazelGenerator.OldBuild;

namespace D2L.Build.BazelGenerator {
	internal sealed partial class Index {
		// This could be a (compressed) prefix-trie to save space, but we don't
		// have a lot of packages anyway so it's not worth the effort. The
		// runtime complexity is the same -- O(log(n)).
		// Note: for performance, the package locations here have \'s rather
		// than /.
		public ImmutableHashSet<string> m_packageLocations;

		public ImmutableDictionary<string, Label> m_assemblyNameToLabel;
		public ImmutableDictionary<string, Label> m_imagesToLabel;

		private Index(
			ImmutableHashSet<string> packageLocations,
			ImmutableDictionary<string, Label> assemblyNameToLabel,
			ImmutableDictionary<string, Label> imagesToLabel
		) {
			m_packageLocations = packageLocations;
			m_assemblyNameToLabel = assemblyNameToLabel;
			m_imagesToLabel = imagesToLabel;
		}

		public int PackageCount => m_packageLocations.Count;

		public Label ResolvePath( string path ) {
			return ResolvePath( m_packageLocations, path );
		}

		// The implementation lives in a static method because
		// Index.Builder needs to use this function too.
		private static Label ResolvePath(
			ImmutableHashSet<string> packageLocations,
			string path
		) {
			if ( packageLocations.Contains( path ) ) {
				throw new InvalidOperationException(
					"We don't expect to get asked for the label for a dir" +
					"when the dir is a package... maybe this will need to" +
					"change later."
				);
			}

			var dir = Path.GetDirectoryName( path );

			while ( !string.IsNullOrEmpty( dir ) ) {
				// Each .Contains() is "O(1)", and there are at most
				// "O(log(n))" iterations of this loop, so the total runtime is
				// "O(log(n))" (hand-waving about what n is, here).

				if ( packageLocations.Contains( dir ) ) {
					return new Label(
						package: dir.Replace( '\\', '/' ),
						target: path.Substring( dir.Length + 1 ).Replace( '\\', '/' )
					);
				}

				dir = Path.GetDirectoryName( dir );
			}

			throw new InvalidOperationException(
				$"Failed to map path {path} to a package"
			);
		}
	}
}
