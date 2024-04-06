# CamlTree

CamlTree is a programming language for running computations on trees. It enables users to define nodes, connections between nodes, and operations to expand and compute on the tree.

## Progress

- [x] Designed the language syntax and semantics
- [x] Implemented the scanner using OCamllex
- [x] Implemented the parser using Menhir
- [x] Defined the Abstract Syntax Tree (AST) types
- [x] Implemented the pretty-printer for the AST
- [ ] Implemented the core runtime functionalities
- [ ] Tested the language with sample programs

## Timeline

- Week 1: Finish implementing the core runtime functionalities
- Week 2: Write more test programs and debug the language
- Week 3: Optimize the implementation and refactor code
- Week 4: Prepare the final project submission

## Directory Structure

- `/src`: Contains the source code for the language implementation
  - `scanner.mll`: Defines the lexical conventions using OCamllex
  - `parser.mly`: Defines the grammar rules using Menhir
  - `ast.ml`: Defines the Abstract Syntax Tree (AST) types
  - `prettyprint.ml`: Provides functions to pretty-print the AST
  - `tree.ml`: Implements the core functionalities of the CamlTree runtime
- `/test`: Contains sample programs and test instructions
