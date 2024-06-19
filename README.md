# PEMA ![](https://img.shields.io/badge/version-v0.1.0-blue)
A computational framework to characterize metabolic states of human and mouse pre-implantation embryos using RNA-seq and Ribo-seq data.
![image](https://github.com/summus-kong/PEMA/blob/main/PEMA.png)

## Help massage
```
code: python PEMA -h

usage: PEMA -r file -R file -s <str> -o file [-p <int>] [-h] [-v]

Pre-implantation Embryos Metabolic Analysis

Required Arguments:
  Parameters must be supplied, otherwise throw an exception.

  -r file, --input_rna file
                        Gene expression matrix. Should be a tsv file with one row per gene and one column per sample or
                        embryo. (default: None)
  -s <str>, --species <str>
                        Species to use to match genes to model. ['homo_sapiens', 'mus_musculus'] (default: homo_sapiens)
  -o file, --output file
                        weighted reaction score matrix (default: None)

Optional Arguments:
  Specify additional non-essential parameters.

  -R file, --input_ribo file
                        Rib-seq signal. Should be a tsv file with one row per gene and one column per sample or embryo.
                        (default: None)
  -c <str>, --choose <str>
                        choosing calculate script, a is Ribo-seq, b is weighted value.
                        (default: None)
  -p <int>, --threads <int>
                        # of threads (default: 1)
  -h, --help            show this help message and exit.
  -v, --version         Print version information and exit.
```

If there is no Ribo-seq data, you can use weighted value calculated in data fold during pre-implanation embryos, and arrange your table according your number of samples, then assign -R <file> and -c b.
