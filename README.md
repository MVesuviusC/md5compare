# md5Compare

Compare md5sums for files in two locations.

## Usage
```
md5compare.pl --verbose -1 "dir1/*.txt" -2 "dir2/*.txt"
```

The -1 and -2 arguments need to be in quotes 

## Output

It will output warnings if any md5sums do not match between the two directories. It will also warn if any files are not found in both directories. 