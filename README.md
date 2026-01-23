# `coi` - A library to extract tree-tree interaction metrics from TLS point clouds within R.

`coi` is a small library can extract three metrics relevant for physical tree-tree interactions
from point clouds representing trees. Namely the crown overlap index (COI), which gives the package its Name
and is described in Täuber et al. (2026) in prep. The crown complementarity index (CCI) as described in
[Williams et al. (2017)](https://doi.org/10.1038/s41559-016-0063). And the box dimension structural complexity
as described in [Seidel (2018)](https://doi.org/10.1002/ece3.3661).

## Installation

You can install `coi` by running:

```
# install.packages("devtools")
devtools::install_github("ataeub/coi")
```

## Usage

For an intro to the usage of the library please refer to this [vignette](vignettes/coi_demonstration.html).
For a more thorough explanation of the underlying algorithms you can refer to the paper Täuber et al. (2026) in prep. 
