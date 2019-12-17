using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using D2L.Build.BazelGenerator.NewBuild;

namespace D2L.Build.BazelGenerator.Starlark {
	internal sealed class StarlarkFunctionCall : StarlarkExpr {
		[Flags]
		public enum RenderFlags {
			NoNamesOneLine = 0,

			Names,
			SplitLines,
			SkipNameIfOneArgument,

			Normal = SplitLines | Names | SkipNameIfOneArgument
		}

		public StarlarkFunctionCall(
			string name,
			params StarlarkArgument[] args
		) : this( name, RenderFlags.Normal, args.ToImmutableArray() ) { }

		public StarlarkFunctionCall(
			string name,
			IEnumerable<StarlarkArgument> args
		) : this( name, RenderFlags.Normal, args.ToImmutableArray() ) { }

		public StarlarkFunctionCall(
			string name,
			RenderFlags renderFlags,
			IEnumerable<StarlarkArgument> args
		) : this(name, renderFlags, args.ToImmutableArray() ) { }

		public StarlarkFunctionCall(
			string name,
			RenderFlags renderFlags,
			params StarlarkArgument[] args
		) : this( name, renderFlags, args.ToImmutableArray() ) { }

		public StarlarkFunctionCall(
			string name,
			ImmutableArray<StarlarkArgument> args
		) : this( name, RenderFlags.Normal, args ) { }

		public StarlarkFunctionCall(
			string name,
			RenderFlags renderFlags,
			ImmutableArray<StarlarkArgument> args
		) {
			Name = name;
			Flags = renderFlags;
			Arguments = args;
		}

		public static StarlarkFunctionCall Load(
			Label package,
			Label bzlModule,
			params string[] symbols
		) => Load( package, bzlModule, (IEnumerable<string>)symbols );

		public static StarlarkFunctionCall Load(
			Label package,
			Label bzlModule,
			IEnumerable<string> symbols
		) => new StarlarkFunctionCall(
			"load",
			RenderFlags.NoNamesOneLine,

			new[] { bzlModule.ToStarlark( relativeTo: package ).ToArgument( "module" ) }
			.Union( symbols.ToStarlark().ToArguments() )
			.ToImmutableArray()
		);

		public string Name { get; }
		public ImmutableArray<StarlarkArgument> Arguments { get; }
		public RenderFlags Flags { get; }

		protected override void WriteImpl( IndentingWriter writer ) {
			writer.Write( Name );

			// Print a one line empty call like so: foo()
			if( Arguments.Length == 0 ) {
				writer.Write( "()" );
				return;
			}

			writer.Write( '(' );

			// We never use a new line if there is only one argument
			if( Arguments.Length == 1 ) {
				// If there is a comment spill to a new indented line
				//
				// foo(
				//   # some comment
				//   "value of argument"
				// )
				if( Arguments[0].Comment != null ) {
					Arguments[0].Comment.Write( writer );
					writer.Indent();
				}

				// Often we omit the param name if there is only one argument
				// because it is clear. This may not be the case when a call
				// has many optional parameters, though.
				if( !Flags.HasFlag( RenderFlags.SkipNameIfOneArgument ) && Flags.HasFlag( RenderFlags.Names ) ) {
					writer.Write( Arguments[0].ParamName );
					writer.Write( " = " );
				}

				Arguments[0].ArgExpr.Write( writer );

				// Clean up if we had a comment before
				if( Arguments[0].Comment != null ) {
					writer.Unindent();
					writer.WriteLine();
				}

				writer.Write( ')' );
				return;
			}

			if( Flags.HasFlag( RenderFlags.SplitLines ) ) {
				writer.WriteLine();
				writer.Indent();
			}

			// Print out the arguments
			bool firstArg = true;
			foreach( var arg in Arguments ) {
				// Print out the leading comment if it exists
				if( arg.Comment != null ) {
					if( !Flags.HasFlag( RenderFlags.SplitLines ) ) {
						throw new Exception( "Comments on arguments is only supported when arguments are on a single line" );
					}
					arg.Comment.Write( writer );
				}

				// Print out leading ,'s after the first argument when we are
				// writing all the arguments on one line
				if( !firstArg && !Flags.HasFlag( RenderFlags.SplitLines ) ) {
					writer.Write( ", " );
				}

				firstArg = false;

				if( Flags.HasFlag( RenderFlags.Names ) ) {
					writer.Write( arg.ParamName );
					writer.Write( " = " );
				}

				arg.ArgExpr.Write( writer );

				if( Flags.HasFlag( RenderFlags.SplitLines ) ) {
					writer.WriteLine( ',' );
				}
			}

			if( Flags.HasFlag( RenderFlags.SplitLines ) ) {
				writer.Unindent();
			}

			writer.Write( ')' );
		}
	}
}
