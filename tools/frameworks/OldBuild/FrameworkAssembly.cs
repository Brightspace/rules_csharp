using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using System.Reflection;
using D2L.Build.BazelGenerator.NewBuild;
using D2L.Build.BazelGenerator.NewBuild.Rules;

namespace D2L.Build.BazelGenerator.OldBuild {
	internal sealed class FrameworkAssembly : IOldBuildThing {
		/// <summary>
		/// A DLL from the .NET framework we need to import
		/// </summary>
		/// <param name="packageRelativeDLLPath"></param>
		/// <param name="references"></param>
		public FrameworkAssembly(
			string packageRelativeDLLPath,
			ImmutableArray<string> references
		) {
			Name = Path.GetFileNameWithoutExtension( packageRelativeDLLPath );
			PackageRelativeDLLPath = packageRelativeDLLPath;
			References = references;
		}

		public string Name { get; }
		public string PackageRelativeDLLPath { get; }
		public ImmutableArray<string> References { get; }

		public string SortKey => Name;
		public string LocationHint => throw new NotImplementedException();

		// Load a FrameworkAssembly from a DLL on disk
		public static FrameworkAssembly LoadFromFile(
			string frameworkPackagePath,
			string dllPath
		) {
			Assembly asm;

			var packageRelativeDLLPath = dllPath.Substring(
				frameworkPackagePath.Length + 1
			);

			if( !packageRelativeDLLPath.Contains( "Facades" ) ) {
				// So we don't _really_ need to tell Bazel about deps... but
				// for the Facade dlls we do. This is really weird and hacky
				// but it works out. The reason we're not output deps for
				// everybody here is because there are circular references
				// (wtf?) like System.Xml -> System.Data.SqlXml -> System.Xml
				// and Bazel is just not at all about that. We could bundle up
				// the cycles into a pool of DLLs that we import as one target,
				// maybe...
				return new FrameworkAssembly(
					packageRelativeDLLPath,

					Path.GetFileNameWithoutExtension( packageRelativeDLLPath ) == "mscorlib"
					? ImmutableArray<string>.Empty
					: ImmutableArray.Create( "mscorlib" )
				);
			}

			try {
				asm = Assembly.ReflectionOnlyLoadFrom( dllPath );
			} catch( BadImageFormatException ) {
				// some DLLs are native DLLs. Just don't worry about those.
				return new FrameworkAssembly(
					packageRelativeDLLPath,
					ImmutableArray<string>.Empty
				);
			}

			var deps = asm.GetReferencedAssemblies()
				.Select( r => r.Name )
				.ToImmutableArray();

			return new FrameworkAssembly(
				packageRelativeDLLPath,
				deps
			);
		}

		public IEnumerable<INewBuildThing> Convert( Index index ) {
			var deps = References
				.Select( r => new Label( "net", "", r ) )
				.ToImmutableArray();

			var refdll = new Label(
				"net", "",
				target: PackageRelativeDLLPath.Replace( '\\', '/' )
			);

			yield return new ImportLibrary(
				name: Name,
				refdll: refdll,
				deps: deps,
				visibility: Label.PublicVisibility
			);
		}
	}
}
