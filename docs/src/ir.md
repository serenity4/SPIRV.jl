# IR

No transformations are carried out on Julia typed IR.

This typed IR will be translated into unstructured SPIR-V IR by mapping instructions from one IR to the other. This unstructured IR will be restructured by applying the following transformations:
- Node cloning to make turn irreducible control-flow into reducible control-flow.
- Restructuring with the help of a control tree from structural analysis. Insertion of selection and loop merge information will be incorporated into the IR.

This will turn SPIR-V IR into a standard format that will be assumed during the rest of the compilation pipeline, including optimizations and final introspection to exhibit implicit shader interfaces (e.g. an unsigned integer converted to a pointer and loaded from). Having a standardized and structured control-flow will enable simplifications and speed-ups in control-flow and data-flow analyses.
