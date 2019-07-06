HOOKS = pre-commit pre-push
HOOK_INSTALL_DIR = .git/hooks

.PHONY: check_ruby check_bundler scale_photos

build: _build scale_photos

_build: check_ruby check_bundler dependencies install_hooks
	bundle exec jekyll build
	bundle exec htmlproofer _site --allow-hash-href --empty-alt-ignore --only-4xx _site

serve: build
	bundle exec jekyll serve

check_ruby:
	@ruby --version > /dev/null || echo "Could not find 'ruby'"
	@echo "'ruby' installation found"

check_bundler:
	@bundle --version > /dev/null || echo "Could not find 'bundle'"
	@echo "'bundle' installation found"

dependencies: Gemfile.lock

Gemfile.lock: Gemfile
	bundle install

install_hooks: $(foreach hook,$(HOOKS),$(HOOK_INSTALL_DIR)/$(hook))

.git/hooks/%: _hooks/%
	cp $< $@
	chmod +x $@

publish: build
	rsync -r _site/ alexanderweinert.net:/www/
