type node = {
  name: string;
  node_type: string;
  forward_value: value option;
  backward_value: value option;
  children: node list;
}

and value =
  | IntVal of int
  | FloatVal of float  
  | BoolVal of bool
  | StringVal of string
  | ArrVal of value list

type tree = {
  root: node;
}

let rec eval_expr env = function
  | Ast.Int i -> IntVal i
  | Ast.Float f -> FloatVal f
  | Ast.Bool b -> BoolVal b
  | Ast.String s -> StringVal s
  | Ast.Var v -> List.assoc v env
  (* Implement other expression cases *)

let rec exec_stmt env = function
  | Ast.Assign (v, e) -> 
    let value = eval_expr env e in
    (v, value) :: env
  | Ast.Expr e -> 
    let _ = eval_expr env e in
    env
  | Ast.Return e ->
    let value = eval_expr env e in
    raise (ReturnException value)
  (* Implement other statement cases *)

let create_node name node_type forward backward =
  { name; node_type; forward_value = forward; backward_value = backward; children = [] }

let link_parent_child parent child = 
  { parent with children = child :: parent.children }

let rec find_node name node =
  if node.name = name then Some node
  else 
    match List.filter_map (find_node name) node.children with
    | [] -> None  
    | node :: _ -> Some node

let rec forward_pass node =
  (* Implement forward pass logic *)
  { node with children = List.map forward_pass node.children }

let rec backward_pass node =
  (* Implement backward pass logic *)
  { node with children = List.map backward_pass node.children }
  
let run_tree tree =
  let tree = { tree with root = forward_pass tree.root } in
  { tree with root = backward_pass tree.root }
  
(* Implement other tree operations *)