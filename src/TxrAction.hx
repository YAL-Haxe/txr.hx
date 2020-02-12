package;

/**
 * @author YellowAfterlife
 */
@:using(TxrAction.TxrActionTools)
enum TxrAction {
	Number(p:TxrPos, value:Float);
	Ident(p:TxrPos, name:String);
	UnOp(p:TxrPos, op:TxrUnOp);
	BinOp(p:TxrPos, op:TxrOp);
}
class TxrActionTools {
	public static function getPos(a:TxrAction):TxrPos {
		return a.getParameters()[0];
	}
}