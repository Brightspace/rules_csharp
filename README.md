# rules_csharp

[![Build status](https://badge.buildkite.com/3604affadbe7c01a052fb896ee1d83e0111ee3776e390e96b9.svg)](https://buildkite.com/bazel/github-dot-com-brightspace-rules-csharp)

[Bazel](https://bazel.build) rules for C#.

These are experimental and initially were built for use by D2L.
You probably want to use [bazelbuild/rules_dotnet](https://github.com/bazelbuild/rules_dotnet).

These are in a rougher state but they contain some differences that are
important for us. Our (potentially long-term) goal is to upstream the
differences, somehow, with the community.

We want rules that are easy to use, support multi-targeting, high performance
(e.g. by [using reference assemblies](docs/ReferenceAssemblies.md) to improve
cache hits, persistent workers, etc.), cross-platform, and as simple as
possible given those constraints.

Check out [the documentation](docs/README.md) for more info.

