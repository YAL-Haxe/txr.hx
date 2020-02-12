package;
import TxrNode.*;

/**
 * ...
 * @author YellowAfterlife
 */
class TxrBuilder {
	static var node:TxrNode;
	static var tokens:Array<TxrToken>;
	static var pos:Int;
	static var len:Int;
	//
	static inline function next():TxrToken {
		return tokens[pos++];
	}
	static inline function peek():TxrToken {
		return tokens[pos];
	}
	static inline function skip():Void {
		pos++;
	}
	static inline function error(text:String, p:TxrPos):String {
		return text + " at position " + p;
	}
	//
	static function ops(first:TxrToken) {
		var nodes = [node];
		var ops = [first];
		while (pos < len) {
			expr(NoOps);
			nodes.push(node);
			var tk = peek();
			switch (tk) {
				case Op(_, op): {
					skip();
					ops.push(tk);
				};
				default: break;
			}
		}
		//
		var n = ops.length;
		for (pri in 0 ... TxrOp.Maxp.getPriority()) {
			var i = -1; while (++i < n) switch (ops[i]) {
				case Op(p, op): {
					if (op.getPriority() != pri) continue;
					nodes[i] = BinOp(p, op, nodes[i], nodes[i + 1]);
					nodes.splice(i + 1, 1); // remove the second node (which we merged in)
					ops.splice(i, 1); // similarly remove the operator
					i -= 1; n -= 1; // adjust for removed items
				};
				default:
			}
		}	
		//
		node = nodes[0];
	}
	static function expr(flags:TxrBuilderFlags = None):Void {
		var tk = next();
		switch (tk) {
			case Number(p, f): node = Number(p, f);
			case Ident(p, s): node = Ident(p, s);
			case ParOpen(p): {
				expr();
				if (!next().match(ParClose(_))) throw error("Unclosed () starting", p);
			};
			case Op(p, op): {
				switch (op) {
					case Add: expr(NoOps);
					case Sub: expr(NoOps); node = UnOp(p, Negate, node);
					default: throw error("Unexpected operator", p);
				}
			};
			case UnOp(p, op): expr(NoOps); node = UnOp(p, op, node);
			default: throw error("Unexpected " + tk.getName(), tk.getPos());
		}
		if (!flags.has(NoOps)) {
			var tk = peek();
			switch (tk) {
				case Op(_, _): {
					skip();
					ops(tk);
				};
				default:
			}
		}
	}
	//
	public static function build(tks:Array<TxrToken>) {
		tokens = tks;
		pos = 0;
		len = tks.length;
		node = null;
		expr(); // top-level
		if (pos < len - 1) { // didn't reach EOF
			throw error("Trailing data", tokens[pos].getPos());
		}
		return node;
	}
}
enum abstract TxrBuilderFlags(Int) from Int to Int {
	var None = 0;
	var NoOps = 1;
	public function has(flag:TxrBuilderFlags) {
		return (this & flag) == flag;
	}
}