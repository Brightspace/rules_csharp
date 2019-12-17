using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using D2L.Build.BazelGenerator.Starlark;

namespace D2L.Build.BazelGenerator.NewBuild {
	/// <summary>
	/// A rule is a Bazel concept for a special kind of Starlark function,
	/// available during the loading phase (i.e. in BUILD and WORKSPACE files)
	/// with some default arguments. This is an abstract class; please put
	/// implementations in the Rules subfolder.
	/// </summary>
	/// <remarks>
	/// * Rules
	///   https://docs.bazel.build/versions/master/skylark/rules.html
	/// * Attributes common to all build rules
	///   https://docs.bazel.build/versions/master/be/common-definitions.html#common-attributes
	/// </remarks>
	internal abstract class Rule : INewBuildThing {
		public Rule(
			string name,
			ImmutableArray<Label>? deps = null,
			ImmutableArray<Label>? visibility = null
		) {
			Name = name;
			Deps = deps.HasValue ? deps.Value : ImmutableArray<Label>.Empty;
			Visibility = visibility.HasValue ? visibility.Value : ImmutableArray<Label>.Empty;
		}

		/// <summary>
		/// The name of the target (i.e. the name attribute provided to the rule)
		/// </summary>
		public string Name { get; }

		/// <summary>
		/// deps is an optional attribute of every rule.
		/// https://docs.bazel.build/versions/master/be/common-definitions.html#common.deps
		/// </summary>
		public ImmutableArray<Label> Deps { get; }

		/// <summary>
		/// visibility is an option attribute of every rule.
		/// https://docs.bazel.build/versions/master/be/common-definitions.html#common.visibility
		/// </summary>
		public ImmutableArray<Label> Visibility { get; }

		/// <summary>
		/// The name of the rule, i.e. the python function name.
		/// </summary>
		public abstract string RuleName { get; }

		/// <summary>
		/// The package containing the definition for the rule.
		/// </summary>
		public abstract Label RuleDefinition { get; }

		public (Label, string) Dependency => (RuleDefinition, RuleName);

		public StarlarkExpr Emit( Label package ) {
			return new StarlarkFunctionCall(
				name: RuleName,
				GetArgs( package )
			) { LineAfter = true };
		}

		private IEnumerable<StarlarkArgument> GetArgs( Label package ) {
			yield return Name.ToStarlark().ToArgument( "name" );

			foreach( var arg in EmitAttrs( package ) ) {
				yield return arg;
			}

			if ( Deps.Length != 0 ) {
				yield return Deps
					.Sort()
					.ToStarlark( relativeTo: package )
					.ToArgument( "deps" );
			}

			if ( Visibility.Length != 0 ) {
				yield return Visibility
					.ToStarlark( relativeTo: package )
					.ToArgument( "visibility" );
			}
		}

		protected abstract IEnumerable<StarlarkArgument> EmitAttrs(
			Label package
		);
	}
}
