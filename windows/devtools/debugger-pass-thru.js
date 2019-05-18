// Input: [script.js]: mode passthru_target [ignoredArg] [args]
//
// mode: 0 => input args: "surrounded" "each arguments" "with quotes" 
// mode: 1 => input args: "Surrounded whole argument set with quotes"
//
// Example: wscript [script.js] 0 "notepad.exe" "arg1" "arg2"
//

var Parser = function () {

  var parseMode = function (val) {
    if (!(val === 0 || val === 1))
      throw "Invalid mode";
    return val;
  };

  var getPassThroughTarget = function (args) {
    var res = args.Item(1);
    return "\"" + res + "\"";
  };

  var getMultiQuotedString = function (args) {
    if (!(args.length > 3)) return "";

    var res = "";
    for (var i = 3; i < args.length; i++) {
      var arg = args.Item(i);
      res += "\"" + arg + "\"";
      if (i < args.length - 1) res += " ";
    }
    return res;
  };

  var getSingleArgumentString = function (args) {
    if (!(args.length > 3)) return "";

    var res = "";
    for (var i = 3; i < args.length; i++) {
      var arg = args.Item(i);
      res += arg;
      if (i < args.length - 1) res += " ";
    }
    return res;
  };

  var getCommandLine = function (args) {
    var newArgs = "";
    if (args.length < 2)
      throw "Invalid input";

    var mode = parseMode(parseInt(args.Item(0)));
    newArgs = getPassThroughTarget(args);

    if (mode === 0)
      newArgs += " " + getMultiQuotedString(args);
    else
      newArgs += " \"" + getSingleArgumentString(args) + "\"";

    return newArgs;
  };

  Parser.prototype.getCommandLine = getCommandLine;
};

var run = function () {
  var ws = WScript;
  var parser = new Parser();
  var args = parser.getCommandLine(ws.Arguments);
  var shell = ws.CreateObject("WScript.Shell");
  // Set windowStyle as 0 (Hidden), and don't wait for process to complete.
  shell.Run(args, 0, false);
};

run();