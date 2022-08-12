<!-- markdownlint-disable -->

# Markojudas' Bash Bookmark Tool

This is very simple bookmark tool for the easy navigation through the terminal of the most used directories.

## Install

Download the script into your $HOME directory and run.

```bash
wget https://github.com/Markojudas/bookmarktool/blob/main/.bookmarktool.sh
```

```bash
./.bookmarktool.sh
```

This will create a file `.bookmark.list` that will keep track of the created bookmarks and keep a count of time you have visited each bookmark.

This will also modify your `.bashrc` file appending the block below so the tool is available after booting up.

```bash
if [ -f ~/.bookmarktool.sh ]; then
	. ~/.bookmarktool.sh
fi
```

Once the above is done, for the first time usage you could either restart your machine or just source your `.bashrc` to make the above take effect:

```bash
source .bashrc
```

## Usage

<pre>
bm [OPTION] [name-of-bookmark] [path-to-directory]

OPTIONS
-c [create]	[name-of-bookmark] [path-to-directory]
-r [remove]	[name-of-bookmark]
-l [list]
-s [show]	[name-of-bookmark]
-v [visit]	[name-of-bookmark]
</pre>
