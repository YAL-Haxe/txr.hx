package;
import TxrToken.*;

/**
 * ...
 * @author YellowAfterlife
 */
class TxrParser {
	public static function parse(s:String):Array<TxrToken> {
		var out = [];
		var pos = 0;
		var len = s.length;
		while (pos < len) {
			var start = pos;
			var c = s.charCodeAt(pos++);
			switch (c) {
				case " ".code, "\t".code, "\r".code, "\n".code: continue;
				default:
			}
			var d:TxrPos = start;
			switch (c) {
				case "(".code: out.push(ParOpen(d));
				case ")".code: out.push(ParClose(d));
				case "+".code: out.push(Op(d, Add));
				case "-".code: out.push(Op(d, Sub));
				case "*".code: out.push(Op(d, Mul));
				case "/".code: out.push(Op(d, FDiv));
				case "%".code: out.push(Op(d, FMod));
				case "!".code: out.push(UnOp(d, Not));
				default: {
					if (c >= "0".code && c <= "9".code || c == ".".code) {
						var dot = c == ".".code;
						while (pos < len) {
							c = s.charCodeAt(pos);
							if (c >= "0".code && c <= "9".code) {
								pos++;
							} else if (c == ".".code && !dot) {
								pos++; dot = true;
							} else break;
						}
						out.push(Number(d, Std.parseFloat(s.substring(start, pos))));
					} else if (c == "_".code
						|| c >= "a".code && c <= "z".code
						|| c >= "A".code && c <= "Z".code
					) {
						while (pos < len) {
							c = s.charCodeAt(pos);
							if (c == "_".code
								|| c >= "a".code && c <= "z".code
								|| c >= "A".code && c <= "Z".code
								|| c >= "0".code && c <= "9".code
							) {
								pos++;
							} else break;
						}
						var name = s.substring(start, pos);
						switch (name) {
							case "mod": out.push(Op(d, FMod));
							case "div": out.push(Op(d, IDiv));
							default: out.push(Ident(d, s.substring(start, pos)));
						}
					} else {
						throw "Unexpected character `" + s.charAt(pos) + "` at position " + start;
					}
				}
			}
		}
		out.push(Eof(pos));
		return out;
	}
}