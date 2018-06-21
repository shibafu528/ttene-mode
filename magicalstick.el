;;; magicalstick.el --- さなボタンをアレするツール

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

;; Inspired by https://github.com/himanoa/magicalstick

;;; Code:

(require 'dom)

(defvar magicalstick:host "sanabutton.ojaru.jp")
(defvar magicalstick:protocol "http")
(defvar magicalstick:ext "mp3")

(defun magicalstick-get-dom ()
  "Get sana button DOM."
  (let ((url-request-method "GET"))
    (with-current-buffer (url-retrieve-synchronously (format "%s://%s" magicalstick:protocol magicalstick:host))
      (goto-char (point-min))
      (re-search-forward "^$")
      (delete-region (point) (point-min))
      (libxml-parse-html-region (point-min) (point-max)))))

(defun magicalstick ()
  "Get sana button resource list."
  (mapcar (lambda (node)
            (format "%s://%s%s.%s"
                    magicalstick:protocol
                    magicalstick:host
                    (expand-file-name (dom-attr node 'data-file) "/")
                    magicalstick:ext))
          (dom-by-class (magicalstick-get-dom) "sounds")))

(provide 'magicalstick)
;;; magicalstick.el ends here
