type uniop = Not

type binop =
  | Add | Sub | Mult | Div | Mod
  | Lt | Leq | Eq | Neq | Gt | Geq  
  | And | Or

type expr =
  | Int of int
  | Float of float
  | Bool of bool
  | String of string
  | Var of string
  | Combine of expr * expr
  | Replicate of expr
  | Static of expr
  | Binop of binop * expr * expr
  | Uniop of uniop * expr   
  | Call of string * expr list

type stmt =
  | Assign of string * expr
  | Expr of expr
  | Return of expr
  | If of expr * stmt * stmt
  | While of expr * stmt list
  | For of string * expr * expr * stmt list

type tml_stmt =  
  | Root of string
  | Node of string
  | Connect of string * string
  | CreateNode of string * string * expr * expr option
  | LinkNode of string * string * string * expr * expr option

type trs_stmt =
  | Open of string * string
  | Create of string * string * stmt list
  | Eval of string * string * stmt list
  | Def of string * string list * stmt list
  | Run of string
  | Replace of string
  | Check of string

type program = Program of tml_stmt list * trs_stmt list