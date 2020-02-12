package ;
import TxrAction.*;

/**
 * ...
 * @author YellowAfterlife
 */
class TxrCompiler {
	static var actions:Array<TxrAction>;
	static inline function add(a:TxrAction):Void {
		actions.push(a);
	}
	static function expr(node:TxrNode):Void {
		switch (node) {
			case Number(p, f): add(Number(p, f));
			case Ident(p, s): add(Ident(p, s));
			case UnOp(p, op, q): {
				expr(q);
				add(UnOp(p, op));
			};
			case BinOp(p, op, a, b): {
				expr(a);
				expr(b);
				add(BinOp(p, op));
			};
		}
	}
	public static function compile(node:TxrNode):Array<TxrAction> {
		actions = [];
		expr(node);
		return actions;
	}
}