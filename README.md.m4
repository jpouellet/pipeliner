changequote('{{{', '}}}'
)# Automatically turns this:

```
esyscmd(grep -v ^inc ln_core.txt ln_fast_core.txt)
```

## into this:

![design heirarchy](ln_fast_core.png)

## and this:

```
include(ln_fast_core.v)
```
