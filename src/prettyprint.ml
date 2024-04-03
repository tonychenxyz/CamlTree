open Ast

let rec pp_expr = function
  | Int i -> string_of_int i
  | Float f -> string_of_float f
  | Bool b -> string_of_bool b
  | String s -> "\"" ^ s ^ "\""
  | Var v -> v
  | Combine (e1, e2) -> "$" ^ pp_expr e1 ^ " " ^ pp_expr e2
  | Replicate e -> "@" ^ pp_expr e
  | Static e -> "static " ^ pp_expr e
  | Binop (op, e1, e2) -> pp_binop op ^ " " ^ pp_expr e1 ^ " " ^ pp_expr e2
  | Uniop (op, e) -> pp_uniop op ^ pp_expr e
  | Call (f, args) -> f ^ "(" ^ String.concat ", " (List.map pp_expr args) ^ ")"

and pp_binop = function  
  | Add -> "+"
  | Sub -> "-"
  | Mult -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Lt -> "<"
  | Leq -> "<="
  | Eq -> "=="
  | Neq -> "!="
  | Gt -> ">"
  | Geq -> ">="
  | And -> "and"
  | Or -> "or"

and pp_uniop = function
  | Not -> "not "

let rec pp_stmt = function
  | Assign (v, e) -> v ^ " = " ^ pp_expr e ^ ";\n"
  | Expr e -> pp_expr e ^ ";\n"
  | Return e -> "return " ^ pp_expr e ^ ";\n"
  | If (cond, s1, s2) -> "if " ^ pp_expr cond ^ " {\n" ^ pp_stmt_list s1 ^ "} else {\n" ^ pp_stmt_list s2 ^ "}\n"
  | While (cond, stmts) -> "while " ^ pp_expr cond ^ " {\n" ^ pp_stmt_list stmts ^ "}\n"  
  | For (v, start, end_, stmts) -> "for " ^ v ^ " in [" ^ pp_expr start ^ ".." ^ pp_expr end_ ^ "] {\n" ^ pp_stmt_list stmts ^ "}\n"

and pp_stmt_list stmts = String.concat "" (List.map pp_stmt stmts)

let pp_tml_stmt = function
  | Root ty -> "root " ^ ty ^ ";\n"
  | Node ty -> "node " ^ ty ^ ";\n"
  | Connect (p, c) -> "connect " ^ p ^ " -> " ^ c ^ ";\n"
  | CreateNode (nt, n, fv, None) -> nt ^ " " ^ n ^ " = " ^ pp_expr fv ^ ";\n"
  | CreateNode (nt, n, fv, Some bv) -> nt ^ " " ^ n ^ " = " ^ pp_expr fv ^ "' " ^ pp_expr bv ^ "';\n" 
  | LinkNode (nt, n, pn, fv, None) -> nt ^ " " ^ n ^ " <- " ^ pn ^ " = " ^ pp_expr fv ^ ";\n"
  | LinkNode (nt, n, pn, fv, Some bv) -> nt ^ " " ^ n ^ " <- " ^ pn ^ " = " ^ pp_expr fv ^ "' " ^ pp_expr bv ^ "';\n"

let pp_trs_stmt = function
  | Open (f, t) -> "open " ^ f ^ " as " ^ t ^ ";\n"
  | Create (p, c, stmts) -> "create " ^ p ^ " -> " ^ c ^ " () {\n" ^ pp_stmt_list stmts ^ "}\n"
  | Eval (c, p, stmts) -> "eval " ^ c ^ "' -> " ^ p ^ "' () {\n" ^ pp_stmt_list stmts ^ "}\n" 
  | Def (fn, params, stmts) -> "def " ^ fn ^ "(" ^ String.concat ", " params ^ ") {\n" ^ pp_stmt_list stmts ^ "}\n"
  | Run t -> t ^ ".run();\n"
  | Replace t -> t ^ ".replace();\n"
  | Check t -> "check " ^ t ^ " == COMPLETE;\n"  

let pp_program (Program (tml_stmts, trs_stmts)) =
  String.concat "" (List.map pp_tml_stmt tml_stmts) ^ "\n" ^
  String.concat "" (List.map pp_trs_stmt trs_stmts)