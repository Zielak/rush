package tasks;

class TestPage {
  static function main() {
    var cmdArgs = Sys.args();
    var debug:Bool = (cmdArgs[0] == '--debug');
    // on windows it still tries to connect to 9001
    var port:String = Sys.systemName() == 'Windows' ? '9001' : '8099';

    var args:Array<String> = [
      '--interval', '50',
      '-s', 'bin/web/',
      '-sp', '8090',
      '-p', port,
      'src/', '-e', 'flow build web${debug ? ' --debug' : ''}',
      'assets/', '-e', 'flow build web${debug ? ' --debug' : ''}'
    ];

    Sys.command('fast-live-reload', args);
  }
}
