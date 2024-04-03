%token <int> INT
%token <float> FLOAT
%token <bool> BOOL
%token <string> ID
%token <string> STRING
%token ROOT CONNECT CREATE EVAL GIVE RUN CHECK REPLACE 
%token DEF RETURN STATIC IF ELSE WHILE FOR IN
%token PLUS MINUS TIMES DIV MOD ASSIGN EQ NEQ LT LEQ GT GEQ AND OR NOT
%token LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK SEMI COMMA ARROW LARROW
%token EOF

%start <Ast.program> prog

%%

prog:
  | tml = tml_stmts trs = trs_stmts EOF { Ast.Program (tml, trs) }
  
tml_stmts:
  | stmt = tml_stmt stmts = tml_stmts { stmt :: stmts }
  | { [] }
  
tml_stmt:
  | ROOT ty = ID { Ast.Root ty }
  | NODE ty = ID { Ast.Node ty } 
  | CONNECT p = ID ARROW c = ID { Ast.Connect (p, c) }
  | nt = ID n = ID ASSIGN fv = expr ov = opt_expr { Ast.CreateNode (nt, n, fv, ov) }
  | nt = ID n = ID LARROW pn = ID ASSIGN fv = expr ov = opt_expr { Ast.LinkNode (nt, n, pn, fv, ov) }

trs_stmts:  
  | stmt = trs_stmt stmts = trs_stmts { stmt :: stmts }
  | { [] }

trs_stmt:
  | OPEN f = STRING AS t = ID { Ast.Open (f, t) }
  | CREATE p = ID ARROW c = ID LPAREN RPAREN LBRACE stmts = stmt_list RBRACE { Ast.Create (p, c, stmts) }  
  | EVAL c = ID ARROW p = ID LPAREN RPAREN LBRACE stmts = stmt_list RBRACE { Ast.Eval (c, p, stmts) }
  | DEF fn = ID LPAREN params = param_list RPAREN LBRACE stmts = stmt_list RBRACE { Ast.Def (fn, params, stmts) }
  | t = ID DOT RUN LPAREN RPAREN { Ast.Run t }
  | t = ID DOT REPLACE LPAREN RPAREN { Ast.Replace t }
  | CHECK t = ID EQ COMPLETE { Ast.Check t }
  | IF cond = expr stmt1 = stmt ELSE stmt2 = stmt { Ast.If (cond, stmt1, stmt2) } 
  | WHILE cond = expr LBRACE stmts = stmt_list RBRACE { Ast.While (cond, stmts) }
  | FOR v = ID IN LBRACK s = expr RANGE e = expr RBRACK LBRACE stmts = stmt_list RBRACE { Ast.For (v, s, e, stmts) }

stmt_list:
  | stmt = stmt stmts = stmt_list { stmt :: stmts }
  | { [] }
  
stmt:
  | v = ID ASSIGN e = expr { Ast.Assign (v, e) }
  | e = expr { Ast.Expr e }
  | RETURN e = expr { Ast.Return e }

expr:
  | i = INT { Ast.Int i }
  | f = FLOAT { Ast.Float f }
  | b = BOOL { Ast.Bool b }
  | s = STRING { Ast.String s }
  | v = ID { Ast.Var v }
  | DOLLAR e1 = expr e2 = expr { Ast.Combine (e1, e2) }
  | AT e = expr { Ast.Replicate e }
  | STATIC e = expr { Ast.Static e }
  | e1 = expr PLUS e2 = expr { Ast.Binop (Ast.Add, e1, e2) }
  | e1 = expr MINUS e2 = expr { Ast.Binop (Ast.Sub, e1, e2) }
  | e1 = expr TIMES e2 = expr { Ast.Binop (Ast.Mult, e1, e2) }
  | e1 = expr DIV e2 = expr { Ast.Binop (Ast.Div, e1, e2) }
  | e1 = expr MOD e2 = expr { Ast.Binop (Ast.Mod, e1, e2) }
  | e1 = expr LT e2 = expr { Ast.Binop (Ast.Lt, e1, e2) } 
  | e1 = expr LEQ e2 = expr { Ast.Binop (Ast.Leq, e1, e2) }
  | e1 = expr EQ e2 = expr { Ast.Binop (Ast.Eq, e1, e2) }
  | e1 = expr NEQ e2 = expr { Ast.Binop (Ast.Neq, e1, e2) }
  | e1 = expr GT e2 = expr { Ast.Binop (Ast.Gt, e1, e2) }
  | e1 = expr GEQ e2 = expr { Ast.Binop (Ast.Geq, e1, e2) }
  | e1 = expr AND e2 = expr { Ast.Binop (Ast.And, e1, e2) } 
  | e1 = expr OR e2 = expr { Ast.Binop (Ast.Or, e1, e2) }
  | NOT e = expr { Ast.Uniop (Ast.Not, e) }
  | f = ID LPAREN args = arg_list RPAREN { Ast.Call (f, args) }
  | LPAREN e = expr RPAREN { e }

opt_expr:
  | ASSIGN e = expr { Some e }
  | { None }
  
param_list:
  | p = ID ps = param_tail { p :: ps }
  | { [] }

param_tail: 
  | COMMA p = ID ps = param_tail { p :: ps }
  | { [] }
  
arg_list:
  | e = expr es = arg_tail { e :: es }  
  | { [] }

arg_tail:
  | COMMA e = expr es = arg_tail { e :: es }
  | { [] }