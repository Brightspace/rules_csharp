using System.Collections.Generic;
using System.Collections.Immutable;
using D2L.Build.BazelGenerator.Starlark;

namespace D2L.Build.BazelGenerator.NewBuild.Rules {
	internal sealed class ImportLibrary : Rule {
		public ImportLibrary (
			string name,
			Label refdll,
			ImmutableArray<Label> ? deps = null,
			ImmutableArray<Label> ? visibility = null
		) : base (name, deps, visibility) {
			RefDLL = refdll;
		}

		public override string RuleName => "import_library";
		public override Label RuleDefinition => Modules.CSharp;

		public Label RefDLL { get; }

		protected override IEnumerable<StarlarkArgument> EmitAttrs (Label package) {
			yield return new StarlarkStringLiteral("net472")
				.ToArgument ("target_framework");

			yield return RefDLL
				.ToStarlark (relativeTo: package)
				.ToArgument ("refdll");
		}
	}
}