;;; ttene.el --- さなちゃんttene.nvim移植するところ見てて…

;; Copyright (C) 2018 shibafu528

;; Author: shibafu <shibafu528@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Inspired by https://github.com/himanoa/ttene.nvim

;;; Code:

(require 'magicalstick)

(defvar ttene:voice-dir
  (expand-file-name "ttene-voices" user-emacs-directory)
  "音声ファイルの格納ディレクトリ")

(defvar ttene:play-command
  (cond ((eq system-type 'windows-nt) "mpg123")
        (t "afplay"))
  "音声ファイルの再生コマンド")

(defun ttene-install-voices ()
  "音声ファイルをダウンロード"
  (interactive)
  (unless (file-directory-p ttene:voice-dir)
    (make-directory ttene:voice-dir))
  (dolist (voice (magicalstick))
    (when (string-match "てねっ[0-9]" voice)
      (with-current-buffer (url-retrieve-synchronously voice)
        (goto-char (point-min))
        (re-search-forward "^$" nil 'move)
        (forward-char)
        (delete-region (point-min) (point))
        (set-buffer-file-coding-system 'binary)
        (write-file (format "%s/%s_%s"
                            ttene:voice-dir
                            (file-name-nondirectory (directory-file-name (file-name-directory voice)))
                            (file-name-nondirectory voice)))
        (kill-buffer)))))

(defun ttene-pick-voice ()
  "音声ファイルをランダムにひとつ取得"
  (cond ((file-directory-p ttene:voice-dir)
         (let ((voices (directory-files ttene:voice-dir)))
           (if (not voices)
               nil
             (concat (file-name-as-directory ttene:voice-dir) (nth (random (length voices)) voices)))))
        (t nil)))

(defun ttene-play-command-line (voice)
  "再生コマンドラインの生成"
  (concat ttene:play-command
          " "
          (shell-quote-argument (if (eq system-type 'windows-nt)
                                    ;; NTEmacsだとエンコードしないと不幸になりそう?
                                    (encode-coding-string voice 'sjis)
                                  voice))))

(defun ttene-play-voice ()
  "音声ファイルを再生"
  (interactive)
  (let ((voice (ttene-pick-voice)))
    (unless voice
      (error ("no voices installed. try M-x ttene-install-voices")))
    (start-process-shell-command "ttene" "*async-process-ttene*" (ttene-play-command-line voice))
    (newline)))

(defun ttene-mode-global-turn-on ()
  (when (not (minibufferp))
    (ttene-mode t)))

(easy-mmode-define-minor-mode ttene-mode
                              "ってね"
                              nil
                              " ttene"
                              '(("\C-m" . ttene-play-voice)))

(easy-mmode-define-global-mode global-ttene-mode
                               ttene-mode
                               ttene-mode-global-turn-on)

(provide 'ttene)
;;; ttene.el ends here
