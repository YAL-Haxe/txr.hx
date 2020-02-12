package;

/**
 * @author YellowAfterlife
 */
enum TxrNode {
	Number(p:TxrPos, f:Float);
	Ident(p:TxrPos, s:String);
	UnOp(p:TxrPos, op:TxrUnOp, q:TxrNode);
	BinOp(p:TxrPos, op:TxrOp, a:TxrNode, b:TxrNode);
}