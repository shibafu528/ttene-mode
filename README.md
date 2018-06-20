ttene-mode
====

https://github.com/himanoa/ttene.nvim の移植。

## Dependencies
* mp3とか再生できるコマンド (とりあえずWindows以外ならafplayがデフォルト、Windowsではmpg123にしたけど何でもいいので導入する)
* magicalstick (https://github.com/himanoa/magicalstick)

## Install
事前に音声ファイルの調達が必要です。https://github.com/himanoa/ttene.nvim を参考にして、`~/.emacs.d/ttene-voices` (デフォルト) に置くといいんじゃないか？

```lisp
(require 'ttene)
(ttene-mode)
```
