using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Text;

namespace D2L.Build.BazelGenerator.NewBuild {
	internal sealed class Label : IEquatable<Label>, IComparable<Label> {
		// This is a fake label that we pretend native rules and functions come
		// from. We never actually emit load() for these.
		public static readonly Label NativeFunctions = new Label( "bazel", "__native__", "defs.bzl" );

		// This is a magic label
		// https://docs.bazel.build/versions/master/be/common-definitions.html#common.visibility
		public static readonly ImmutableArray<Label> PublicVisibility = ImmutableArray.Create(
			new Label( "visibility", "public" )
		);

		public Label( string package, string target )
			: this( null, package, target ) { }

		// e.g. Label( "foo", "bar/baz", "quux" ) -> @foo//bar/baz:quux
		public Label(
			string workspace,
			string package,
			string target
		) {
			// an empty workspace is specially interpreted depending on the
			// situation to the most "obvious" thing.
			Workspace = workspace ?? "";

			// heuristic, TODO: stricter checks if that ever seems worth it
			if( Workspace.Contains( "/" ) ) {
				throw new ArgumentException( "Workspace can't contain /" );
			}

			// Targets only exist within packages
			if( package == null ) {
				throw new ArgumentNullException( nameof( package ) );
			}

			// Both of these cases are invalid and likely to be done
			// accidentally by me. The full rules are more complicated.
			if( package.StartsWith( "/" ) ) {
				throw new ArgumentException(
					"package can't start with /",
					nameof( package )
				);
			}

			if( package.EndsWith( "/" ) ) {
				throw new ArgumentException(
					"package can't end with /",
					nameof( package )
				);
			}

			if( package.Contains( "\\" ) ) {
				throw new ArgumentException(
					"package shouldn't include \\ (you probably passed a Windows path)",
					nameof( package )
				);
			}

			Package = package;

			if( target == null ) {
				// From https://docs.bazel.build/versions/master/build-ref.html#labels
				// "Short-form labels such as //my/app are not to be confused
				// with package names. Labels start with //, but package names
				// never do, thus my/app is the package containing //my/app"
				// We're treating "short-form labels" as a render-time thing;
				// our callers must always pass target and let us deal with it.
				throw new ArgumentNullException(
					"targets can't be null in labels",
					nameof( target )
				);
			}

			// See above
			if( target == "" ) {
				throw new ArgumentException(
					"target name can't be empty",
					nameof( target )
				);
			}

			// Protect against accidental Windows paths
			if ( target.Contains( "\\" ) ) {
				throw new ArgumentException(
					"target can't contain windows paths",
					nameof( target )
				);
			}

			// Targets can contain /'s (files within a package.) The character
			// set allowed by Bazel is quite limited but they will hopefully
			// eventually fix that; not doing any extra validation for now.

			Target = target;
		}

		public string Workspace { get; }
		public string Package { get; }
		public string Target { get; }

		public override string ToString() {
			return ToString( includeWorkspace: true );
		}

		public string ToString( bool includeWorkspace ) {
			var str = new StringBuilder();

			if( includeWorkspace && Workspace != "" ) {
				str.Append( '@' );
				str.Append( Workspace );
			}

			str.Append( "//" );
			str.Append( Package );

			if( Target == null ) {
				return str.ToString();
			}

			AddTarget( str, Package );

			return str.ToString();
		}

		public string ToStringRelativeTo( Label other ) {
			// If the labels are from different workspaces, write as absolute
			if( other.Workspace != Workspace ) {
				return ToString();
			}

			// If this isn't a sub-package of other, write as absolute
			// This quick check also ensures that Package has as many /'s as
			// other.Package
			if( !Package.StartsWith( other.Package ) ) {
				return ToString( includeWorkspace: false );
			}

			var otherParts = other.Package.Split( '/' );
			var parts = Package.Split( '/' );

			// guaranteed: parts.Length >= otherParts.Length

			for( var i = 0; i < otherParts.Length; i++ ) {
				if( otherParts[i] != parts[i] ) {
					return ToString( includeWorkspace: false );
				}
			}

			var relativeParts = new string[parts.Length - otherParts.Length];
			Array.Copy( parts, otherParts.Length, relativeParts, 0, relativeParts.Length );
			string relativePackage = string.Join( "/", relativeParts );

			var sb = new StringBuilder();

			sb.Append( relativePackage );

			AddTarget( sb, relativePackage );

			return sb.ToString();
		}

		public static string ToRelativeFilePath( string relativeTo, string componentPath ) {
			return componentPath.Substring(relativeTo.Length + 1).Replace("\\", "/");
		}

		private void AddTarget( StringBuilder str, string packagePart ) {
			var lastComponent = packagePart.Substring(
				packagePart.LastIndexOf( '/' ) + 1
			);

			// the label //foo/bar is equivalent to //foo/bar:bar
			if( Target == lastComponent ) {
				return;
			}

			str.Append( ':' );
			str.Append( Target );
		}

		public override bool Equals( object obj ) {
			return Equals( obj as Label );
		}

		public bool Equals( Label other ) {
			return other != null
				&& Workspace == other.Workspace
				&& Package == other.Package
				&& Target == other.Target;
		}

		// generated by VS
		public override int GetHashCode() {
			var hashCode = -308198415;
			hashCode = ( hashCode * -1521134295 ) + EqualityComparer<string>.Default.GetHashCode( Workspace );
			hashCode = ( hashCode * -1521134295 ) + EqualityComparer<string>.Default.GetHashCode( Package );
			hashCode = ( hashCode * -1521134295 ) + EqualityComparer<string>.Default.GetHashCode( Target );
			return hashCode;
		}

		public int CompareTo( Label other ) =>
			(Workspace, Package, Target).CompareTo(
				(other.Workspace, other.Package, other.Target)
			);
	}
}
