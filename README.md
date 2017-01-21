Greplace.vim (alt)
==================

This plugin is heavily inspired by the functionality and interface of the
greplace.vim plugin, but offers and alternative approach in hopes of providing
more consitent and reliable changes.


Usage
-----

To start the worklow, run `Gsearch <search-args>` to populate the search results
temp buffer. The `<search-args>` will be passed to ag, so we support anything
they do.

The results will be displayed in a new buffer. Make the edits as needed, using
all the power of Vim.

Once complete, run `Greplace` to have the changes persisted.
