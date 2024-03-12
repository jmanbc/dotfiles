;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region'
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tokyo-night)
(setq fancy-splash-image "/var/home/jmboles/Pictures/21031209.jpeg")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.



;;;;;;;Turn on Beacon;;;;;;;


(beacon-mode 1)


;;;;;;;Company-Tabnine Configs;;;;;;;


(after! company
  (setq +lsp-company-backends '(company-tabnine :separate company-capf company-yasnippet))
  (setq company-show-quick-access 1)
  (setq company-idle-delay 0.5))

;; workaround for company-transformers
(setq company-tabnine--disable-next-transform nil)
(defun my-company--transform-candidates (func &rest args)
  (if (not company-tabnine--disable-next-transform)
      (apply func args)
    (setq company-tabnine--disable-next-transform nil)
    (car args)))

(defun my-company-tabnine (func &rest args)
  (when (eq (car args) 'candidates)
    (setq company-tabnine--disable-next-transform t))
  (apply func args))

(advice-add #'company--transform-candidates :around #'my-company--transform-candidates)
(advice-add #'company-tabnine :around #'my-company-tabnine)

;;;;;;;Tabnine Configs;;;;;;;
                                        ;(use-package! tabnine
                                        ;  :hook ((prog-mode . tabnine-mode)
                                        ;	 (kill-emacs . tabnine-kill-process))
                                        ;  :config
                                        ;  (add-to-list 'completion-at-point-functions #'tabnine-completion-at-point)
                                        ;  (tabnine-start-process)
                                        ;  :bind
                                        ;  (:map  tabnine-completion-map
                                        ;	("<tab>" . tabnine-accept-completion)
                                        ;	("TAB" . tabnine-accept-completion)
                                        ;	("M-f" . tabnine-accept-completion-by-word)
                                        ;	("M-<return>" . tabnine-accept-completion-by-line)
                                        ;	("C-g" . tabnine-clear-overlay)
                                        ;	("M-[" . tabnine-previous-completion)
                                        ;	("M-]" . tabnine-next-completion)))
                                        ;
                                        ;(setq +lsp-company-backend '(company-lsp :with tabnine :separate))
                                        ;(after! company
                                        ;  (setq company-idle-delay 0
                                        ;        company-show-quick-access t))
                                        ;(setq +lsp-company-backends '(tabnine :separate company-capf company-yasnippet))


;;;;;;;Hydra for resizing windows;;;;;;;


(defhydra doom-window-resize-hydra (:hint nil)
  "
             _k_ increase height
_h_ decrease width    _l_ increase width
             _j_ decrease height
"
  ("h" evil-window-decrease-width)
  ("j" evil-window-increase-height)
  ("k" evil-window-decrease-height)
  ("l" evil-window-increase-width)

  ("q" nil))

(map!
 (:prefix "w"
  :desc "Hydra resize" :n "SPC" #'doom-window-resize-hydra/body
  :desc "Clippy describes function under point" :n "f" #'clippy-describe-function
  :desc "Clippy describes variable under point" :n "v" #'clippy-describe-variable))


;;;;;;;Always open at main workspace;;;;;;;


(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))


;;;;;;;Fix which-key;;;;;;;


(setq which-key-popup-type 'side-window)
(setq which-key-side-window-location 'bottom)
(setq which-key-side-window-max-width 0.75)
(setq which-key-side-window-max-height 0.75)
(defadvice! fix-which-key--show-popup (fn act-popup-dim)
  :around #'which-key--show-popup
  (let ((height (car act-popup-dim))
        (width  (cdr act-popup-dim)))
    (funcall fn (cons (+ height 2) width))))


;;;;;;;Treemacs;;;;;;;


(after! treemacs
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-git-mode 'deferred))
(setq treemacs-is-never-other-window t)
(setq treemacs-show-hidden-files nil)
(setq treemacs-width 35)
(setq treemacs-indentation 1)
(setq treemacs-width-is-initially-locked nil)
(setq doom-themes-treemacs-theme "doom-colors")
(setq doom-themes-treemacs-enable-variable-pitch nil)


;;;;;;;Relative Numbers;;;;;;;


;;(setq display-line-numbers-type 'relative)
;;(remove-hook! '(text-mode-hook) #'display-line-numbers-mode)


;;;;;;;Transparent Background;;;;;;;


                                        ;(add-to-list 'default-frame-alist '(alpha-background . 96))


;;;;;;;Indentation Lines;;;;;;;


(add-hook 'prog-mode-hook 'highlight-indentation-mode)
                                        ;(add-hook 'prog-mode-hook 'highlight-indentation-current-column-mode)
(setq highlight-indentation-blank-lines 't)
(add-hook 'prog-mode-hook 'set-face-background 'highlight-indentation-face "#AAB5D7")
                                        ;(add-hook 'prog-mode-hook '(set-face-background 'highlight-indentation-current-column-face "#AAB5D7"));;;;;;;;;;
(add-hook 'prog-mode-hook 'display-line-numbers-mode )


;;;;;;;GitHub Copilot configs;;;;;;;


(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("M-f" . 'copilot-accept-completion-by-word)
              ("M-<return>" . 'copilot-accept-completion-by-line)
              ("M-[" . 'copilot-previous-completion)
              ("M-]" . 'copilot-next-completion)
              ("C-g" . 'copilot-clear-overlay)))

(after! (evil copilot)
  ;; Define the custom function that either accepts the completion or does the default behavior
  (defun my/copilot-tab-or-default ()
    (interactive)
    (if (and (bound-and-true-p copilot-mode)
             ;; Add any other conditions to check for active copilot suggestions if necessary
             )
        (copilot-accept-completion)
      (evil-insert 1))) ; Default action to insert a tab. Adjust as needed.

  ;; Bind the custom function to <tab> in Evil's insert state
  (evil-define-key 'insert 'global (kbd "<tab>") 'my/copilot-tab-or-default))
(setq! copilot-indent-offset-warning-disable 1)


;;;;;;;Minimap;;;;;;;


(setq minimap-window-location 'right)
(setq minimap-update-delay 0.1)
(setq minimap-width-fraction 0.1)
(setq minimap-minimum-width 15)
(setq minimap-hide-fringes t)
(setq minimap-hide-scroll-bar t)
(setq minimap-hide-mode-line t)
(setq minimap-automatically-delete-window t)


;;;;;;;Line-Reminder;;;;;;;


(add-hook 'prog-mode-hook 'line-reminder-mode)
(add-hook 'org-mode-hook 'line-reminder-mode)
(after! line-reminder
  (setq line-reminder-fringe-placed 'left-fringe)
  (setq line-reminder-show-option 'indicators))
                                        ;(fringe-helper-define 'my-bitmap nil
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.." "..xxx.."
                                        ;  "..xxx.." "..xxx..")
                                        ;(setq line-reminder-bitmap 'my-bitmap)


;;;;;;;apheleia;;;;;;;


(apheleia-global-mode +1)


;;;;;;;Flycheck;;;;;;;


(after! flycheck
  (setq-default flycheck-disabled-checkers '(c/c++-clang))
  (setq-hook! 'c++-mode-hook
    flycheck-checker 'c/c++-gcc
    flycheck-gcc-language-standard "c++23"
    flycheck-gcc-include-path '("/usr/include/c++/13.2.1")))

(custom-set-faces!
  '(flycheck-info :underline (:style line :color "#171717")))
