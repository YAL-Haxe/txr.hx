package;

import js.Lib;

/**
 * ...
 * @author YellowAfterlife
 */
@:keep class Main {
	@:expose("txr1_run")
	public static function run(code:String):String {
		try {
			var pg = new TxrProgram();
			pg.compile(code);
			var v = pg.exec({
				
			});
			return Std.string(v);
		} catch (x:Dynamic) {
			return Std.string(x);
		}
	}
	static function main() {
		trace(run("1 + 4 * (2 + 3) / 5"));
	}
	
}