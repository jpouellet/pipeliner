changequote('{{{', '}}}'
)# Automatically turns this:

```
esyscmd(grep -hv ^inc examples/ln_fast_core.txt examples/ln_core.txt)```

## into this:

![design heirarchy](examples/ln_fast_core.png)

## and this:

```
include(examples/ln_fast_core.v)```
