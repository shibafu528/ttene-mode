ttene-mode
====

https://github.com/himanoa/ttene.nvim の移植。

## Dependencies
* mp3とか再生できるコマンド  
  (とりあえずWindows以外ならafplayがデフォルト、Windowsではmpg123にしたけど何でもいいので導入する)
* Optional
    * magicalstick (https://github.com/himanoa/magicalstick)  
      用意できなければ付属のmagicalstick.elで代用可能です。

## Install
事前に音声ファイルの調達が必要です。  
変数 `ttene:voice-dir` を適切に設定した後、`ttene-install-voices` を実行してください。

```lisp
(require 'ttene)
(global-ttene-mode)
```
