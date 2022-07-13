# Changelog for SPIRV.jl

## Version `v0.3`

![BREAKING][badge-breaking] `CFG` has been renamed to `SPIRVTarget`, as the semantics of the structure evolved and control-flow has been streamlined a bit more internally.
![Enchancement][badge-enhancement] ![BREAKING][badge-breaking] A new `Decorations` structure has been introduced instead of `Pair{SPIRV.Decoration, Vector{Any}}` free-form pairs. This has been done to perform parameter checking so that it is impossible to decorate variables or members with the wrong number of decoration arguments nor to provide decoration arguments with the wrong types. The API around setting decorations has also been improved.
![BREAKING][badge-breaking] `ShaderInterface` now relies on `SPIRVTarget` and `Decorations`.
![BREAKING][badge-breaking] `make_shader` has been removed in favor of a more explicit `Shader` type for turning `SPIRVTarget`s into Vulkan-compliant shader modules.
![Feature][badge-feature] Data can now be extracted from Julia values with no memory padding, and can be properly padded to satisfy SPIR-V alignemnt requirements. This is however undocumented at the moment.

[badge-breaking]: https://img.shields.io/badge/BREAKING-red.svg
[badge-deprecation]: https://img.shields.io/badge/deprecation-orange.svg
[badge-feature]: https://img.shields.io/badge/feature-green.svg
[badge-enhancement]: https://img.shields.io/badge/enhancement-blue.svg
[badge-bugfix]: https://img.shields.io/badge/bugfix-purple.svg
[badge-security]: https://img.shields.io/badge/security-black.svg
[badge-experimental]: https://img.shields.io/badge/experimental-lightgrey.svg
[badge-maintenance]: https://img.shields.io/badge/maintenance-gray.svg

<!--
# Badges (reused from the CHANGELOG.md of Documenter.jl)

![BREAKING][badge-breaking]
![Deprecation][badge-deprecation]
![Feature][badge-feature]
![Enhancement][badge-enhancement]
![Bugfix][badge-bugfix]
![Security][badge-security]
![Experimental][badge-experimental]
![Maintenance][badge-maintenance]
-->
