package ;
import haxe.ds.GenericStack;

/**
 * ...
 * @author YellowAfterlife
 */
class TxrProgram {
	public var actions:Array<TxrAction>;
	public function new() {
		
	}
	public function compile(src:String) {
		var tokens = TxrParser.parse(src);
		var node = TxrBuilder.build(tokens);
		actions = TxrCompiler.compile(node);
	}
	public function exec(vars:Dynamic):Float {
		var stack = new GenericStack<Float>();
		for (act in actions) {
			inline function error(text:String) {
				return text + " at position " + act.getPos();
			}
			switch (act) {
				case Number(p, value): stack.add(value);
				case Ident(p, name): {
					var val = Reflect.field(vars, name);
					if (Std.is(val, Float)) {
						stack.add(val);
					} else if (Reflect.hasField(vars, name)) {
						throw error('Variable $name is not a number');
					} else throw error('Variable $name does not exist');
				};
				case BinOp(p, op): {
					var b = stack.pop();
					var a = stack.pop();
					switch (op) {
						case TxrOp.Add: a += b;
						case TxrOp.Sub: a -= b;
						case TxrOp.Mul: a *= b;
						case TxrOp.FDiv: a /= b;
						case TxrOp.FMod: a %= b;
						case TxrOp.IDiv: a = Std.int(a / b);
						default: throw error("Can't apply " + op.toString());
					}
					stack.add(a);
				};
				case UnOp(p, op): {
					var v = stack.pop();
					switch (op) {
						case TxrUnOp.Not: v = v != 0 ? 0 : 1;
						case TxrUnOp.Negate: v = -v;
					}
				};
			}
		}
		return stack.pop();
	}
}