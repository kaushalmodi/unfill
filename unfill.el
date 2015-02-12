;;; unfill.el --- The inverse of fill-paragraph and fill-region

;; Copyright (C) 2012 Steve Purcell.

;; Author: Steve Purcell <steve@sanityinc.com>
;; Version: DEV
;; Keywords: utilities

;; Based on Xah Lee's examples: http://xahlee.org/emacs/emacs_unfill-paragraph.html

;; This file is NOT part of GNU Emacs.

(defun modi/fill-paragraph (&optional beg end)
  "Make `fill-paragraph' fill the selected region instead of `fill-region'.
Reason: `fill-paragraph' fills the comment regions correctly, `fill-region'
does not."
  (interactive "r")
  (save-excursion
    (if (use-region-p)
        (progn
          (narrow-to-region beg end)
          (goto-char (point-min))
          (fill-paragraph)
          (widen))
      (fill-paragraph))))

;;;###autoload
(defun unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column most-positive-fixnum))
    (fill-paragraph nil)))

;;;###autoload
(defun unfill-region (start end)
  "Replace newline chars in region from START to END by single spaces.
This command does the inverse of `fill-region'."
  (interactive "r")
  (let ((fill-column most-positive-fixnum))
    (modi/fill-paragraph start end)))

;;;###autoload
(defun toggle-fill-unfill ()
  "Remove or add line ending chars on current paragraph.  This command is similar to a toggle of `fill-paragraph'.  When there is a text selection, act on the region."
  (interactive)
  ;; This command symbol has a property “'stateIsCompact-p”.
  (let (currentStateIsCompact
        (bigFillColumnVal most-positive-fixnum)
        (deactivate-mark nil))
    (save-excursion
      ;; Determine whether the text is currently compact.
      (setq currentStateIsCompact
            (if (eq last-command (or 'hydra-toggle/body
                                     this-command))
                (get this-command 'stateIsCompact-p)
              (if (> (- (line-end-position) (line-beginning-position)) fill-column) t nil) ) )

      (if (use-region-p)
          (if currentStateIsCompact
              (modi/fill-paragraph (region-beginning) (region-end))
            (let ((fill-column bigFillColumnVal))
              (modi/fill-paragraph (region-beginning) (region-end))) )
        (if currentStateIsCompact
            (fill-paragraph nil)
          (let ((fill-column bigFillColumnVal))
            (fill-paragraph nil)) ) )

      (put this-command 'stateIsCompact-p (if currentStateIsCompact nil t)) ) ) )

(provide 'unfill)
;;; unfill.el ends here
