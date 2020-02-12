package ;

/**
 * ...
 * @author YellowAfterlife
 */
enum abstract TxrOp(Int) {
	var Mul = 0x01;
	var FDiv;
	var FMod;
	var IDiv;
	var Add = 0x10;
	var Sub;
	var Maxp = 0x20;
	public inline function getPriority():Int {
		return this >> 4;
	}
	public function toString():String {
		return "operator 0x" + StringTools.hex(this, 2);
	}
}