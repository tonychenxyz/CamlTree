{
  open Parser
}

let whitespace = [' ' '\t' '\r' '\n']
let comment = "/*" ['a'-'z' 'A'-'Z' '0'-'9' '_' ' ' '\t' '\r' '\n']* "*/" 
let alpha = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let id = alpha (alpha | digit | '_')*
let char = ['a'-'z' 'A'-'Z' '0'-'9' '_' '+' '-' '*' '%' '/' '=' '(' ')' '[' ']' '{' '}' '^']
let int = digit+
let float = int '.' int
let bool = "true" | "false"
let string = '\"' char* '\"'

rule token = parse
  | whitespace { token lexbuf }
  | comment    { token lexbuf }
  | "root"     { ROOT }
  | "connect"  { CONNECT }
  | "create"   { CREATE }
  | "eval"     { EVAL }
  | "give"     { GIVE }
  | "run"      { RUN }
  | "check"    { CHECK }
  | "replace"  { REPLACE }
  | "def"      { DEF }
  | "return"   { RETURN }
  | "static"   { STATIC } 
  | "if"       { IF }
  | "else"     { ELSE }
  | "while"    { WHILE }
  | "for"      { FOR }
  | "in"       { IN }
  | id         { ID (Lexing.lexeme lexbuf) }
  | int        { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | float      { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
  | bool       { BOOL (bool_of_string (Lexing.lexeme lexbuf)) }
  | string     { STRING (Lexing.lexeme lexbuf) }
  | '+'        { PLUS }
  | '-'        { MINUS }
  | '*'        { TIMES }
  | '/'        { DIV }
  | '%'        { MOD }
  | '='        { ASSIGN }
  | "=="       { EQ }
  | "!="       { NEQ }
  | '<'        { LT }
  | "<="       { LEQ }
  | '>'        { GT }
  | ">="       { GEQ }
  | "and"      { AND }
  | "or"       { OR }
  | "not"      { NOT }
  | '('        { LPAREN }
  | ')'        { RPAREN }
  | '{'        { LBRACE }
  | '}'        { RBRACE }
  | '['        { LBRACK }
  | ']'        { RBRACK }
  | ';'        { SEMI }
  | ','        { COMMA }
  | "->"       { ARROW }
  | "<-"       { LARROW }
  | eof        { EOF }