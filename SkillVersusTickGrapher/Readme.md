# Graphing skill progression vs number of ticks

## Dependencies:

- [Ripgrep](https://github.com/BurntSushi/ripgrep)
- [Gnuplot](http://www.gnuplot.info/)

## How to run:
1. Put all skil tick files in this directory (e.g. _Skills.20*...)

2. Make it executable
```bash
$ chmod u+x graphAll.sh
```

3. Run it:

```bash
$ ./graphAll.sh
```

The output graphs (png format) will output in the output directory

### Known bugs:

when you have 0/1 skill and have recieved 0 ticks, Gnuplot will throw an error and generate an invalid png file.
