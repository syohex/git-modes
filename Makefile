VERSION ?= 1.0.0

PREFIX  ?= /usr/local
LISPDIR ?= $(PREFIX)/share/emacs/site-lisp/git-modes

ELS  = gitattributes-mode.el
ELS += gitconfig-mode.el
ELS += gitignore-mode.el
ELCS = $(ELS:.el=.elc)
ELCS_OLD = git-commit-mode.elc git-rebase-mode.elc with-editor.elc
ELMS = $(ELS:%.el=marmalade/%-$(VERSION).el)

EMACS_BIN ?= emacs

CP    ?= install -p -m 644
MKDIR ?= install -p -m 755 -d
RMDIR ?= rm -rf

lisp: $(ELCS)

.PHONY: install
install: lisp
	@echo "Installing..."
	@$(MKDIR) $(DESTDIR)$(LISPDIR)
	@$(CP) $(ELS) $(ELCS) $(DESTDIR)$(LISPDIR)

.PHONY: clean
clean:
	@echo "Cleaning..."
	@$(RM) -f $(ELCS) $(ELCS_OLD)
	@$(RMDIR) marmalade

%.elc: %.el
	@$(EMACS_BIN) -batch -Q -f batch-byte-compile $<

.PHONY: marmalade-upload
marmalade-upload: marmalade
	@marmalade-upload $(ELMS)
	@rm -rf marmalade
marmalade: $(ELMS)
$(ELMS): marmalade/%-$(VERSION).el: %.el
	@echo $< $@
	@$(MKDIR) -p marmalade
	@$(CP) $< $@
	@sed -e "/^;; Keywords:/a;; Package-Version: $(VERSION)" -i $@
