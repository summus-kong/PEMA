#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
@Date: 2024.03
@Author: Weibo Hou
@Description: Parse Argument
"""

import argparse
import utils as ut


def parseArguments():
    """
    Parse command-line arguments passed to the pipeline.
    :return:
    """
    parser = argparse.ArgumentParser(prog='PEMA',
                                     add_help=False,
                                     description='Peri-implantation Embryos Metabolic Analysis',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    required = parser.add_argument_group('Required Arguments',
                                         'Parameters must be supplied, otherwise throw an exception.')
    required.add_argument('-r', '--input_rna',
                          type=str,
                          metavar='file',
                          required=True,
                          help='Gene expression matrix. Should be a tsv file with one row per gene and one column per sample or embryo.')
    required.add_argument('-s', '--species',
                          type=str,
                          metavar='<str>',
                          required=True,
                          default='homo_sapiens',
                          choices=['homo_sapiens', 'mus_musculus'],
                          help="Species to use to match genes to model. ['homo_sapiens', 'mus_musculus']")
    required.add_argument('-o', '--output',
                          type=str,
                          metavar='file',
                          required=True,
                          help='weighted reaction score matrix')
    optional = parser.add_argument_group('Optional Arguments',
                                         'Specify additional non-essential parameters.')
    optional.add_argument('-R', '--input_ribo',
                          type=str,
                          metavar='file',
                          required=False,
                          help='Rib-seq signal. Should be a tsv file with one row per gene and one column per sample or embryo.')
    optional.add_argument('-c', '--choose',
                          type='str',
                          metavar='<str>',
                          choices=['a', 'b'],
                          required=False,
                          help='choosing calculate script, a is Ribo-seq, b is weighted value.')
    optional.add_argument('-p', '--threads',
                          type=int,
                          metavar='<int>',
                          required=False,
                          default=1,
                          help='# of threads')
    optional.add_argument("-h", "--help",
                          action="help",
                          help="show this help message and exit.")
    optional.add_argument('-v', '--version',
                          action='version',
                          version=ut.get_version(),
                          help='Print version information and exit.')

    args = parser.parse_args()

    return args
