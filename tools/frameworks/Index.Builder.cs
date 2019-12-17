using System;
using System.Collections.Concurrent;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using D2L.Build.BazelGenerator.NewBuild;

namespace D2L.Build.BazelGenerator {
	internal sealed partial class Index {
		public sealed class Builder {
			// (PackageTargetName, Import, AssemblyName) tuples
			private readonly ConcurrentBag<(string, string, string)> m_packageImportAssembly
				= new ConcurrentBag<(string, string, string)>();

			// (AssemblyName, DirectoryOfCsproj) pairs
			private readonly ConcurrentBag<(string, string)> m_assemblyNameDir
				= new ConcurrentBag<(string, string)>();

			private readonly ConcurrentBag<(string, string)> m_keyedImages
				= new ConcurrentBag<(string, string)>();

			private readonly ConcurrentBag<string> m_packageLocations
				= new ConcurrentBag<string>();

			private readonly string m_workspaceRoot;

			private bool m_built = false;

			public Builder( string workspaceRoot ) {
				m_workspaceRoot = workspaceRoot;
			}

			public void AddPackage( string directory ) {
				CheckIfFinished();

				if( !Path.IsPathRooted( directory ) ) {
					throw new InvalidOperationException( "directory should be absolute" );
				}

				// We're storing package location as relative Windows paths
				// (i.e. with \\)
				var packageLocation = ToRelative( m_workspaceRoot, directory );
				m_packageLocations.Add( packageLocation );
			}

			public void AddNugetPackage(
				string packageTarget,
				string import,
				string assemblyName
			) {
				CheckIfFinished();

				m_packageImportAssembly.Add(
					(packageTarget, import, assemblyName)
				);
			}

			public void AddImage( string imageKey, string file ) {
				CheckIfFinished();

				var location = ToRelative( m_workspaceRoot, file );
				m_keyedImages.Add( (imageKey, location) );
			}

			public static string ToRelative( string workspace, string path ) {
				var location = path.Substring( workspace.Length );

				// Trim off the leading '\\' if it exists
				if( location.Length != 0 ) {
					location = location.Substring( 1 );
				}

				return location;
			}

			public void AddAssembly( string assemblyName, string directory ) {
				CheckIfFinished();

				m_assemblyNameDir.Add( (assemblyName, directory) );
			}

			public Index Build() {
				m_built = true;

				var packageLocations = m_packageLocations.ToImmutableHashSet();

				var nugetAssembliesToLabel = m_packageImportAssembly
					.Select( x => (PackageTarget: x.Item1, Import: x.Item2, Assembly: x.Item3) )
					.Select( x => (
						Name: x.Assembly,
						Label: new Label(
							workspace: x.PackageTarget,
							package: "",
							target: Path.Combine( x.Import, x.Assembly )
						)
						) );

				var images = m_keyedImages
					.Select( x => (Name: x.Item1, Label: ResolvePath( packageLocations, x.Item2 )) )
					.ToImmutableDictionary(
						keySelector: kvp => kvp.Name,
						elementSelector: kvp => kvp.Label
					);

				var assemblyNameToLabel = m_assemblyNameDir
					.Select( x => (Name: x.Item1, Label: ResolvePath( packageLocations, x.Item2 )) )
					.Union( nugetAssembliesToLabel )
					.ToImmutableDictionary(
						keySelector: kvp => kvp.Name,
						elementSelector: kvp => kvp.Label
					);

				return new Index(
					packageLocations,
					assemblyNameToLabel,
					images
				);
			}

			private void CheckIfFinished() {
				if ( m_built ) {
					throw new InvalidOperationException(
						"Attempt to add to an Index.Builder after Build() - you missed the bus!"
					);
				}
			}

		}
	}
}
