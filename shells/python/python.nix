{ pkgs ? import <nixpkgs> {} }:
let
  my-python-packages = p: with p; [
    # autogluon
    # polars
    # streamlit
    # shiny
    # htmltools
    altair
    django
    pip
    elasticsearch
    mlflow
    pypdf2
    langchain
    sentence-transformers
    transformers
    fastapi
    flask
    sentencepiece
    jupyter
    xgboost
    mlflow
    matplotlib
    nltk
    numpy
    pandas
    plotly
    pytest
    pytorch
    scikit-learn
    scipy
    sqlalchemy
    tensorflow
    uvicorn
    virtualenv
    #(
    	#buildPythonPackage rec {
		#pname = "shiny";
		#version = 
	#};
    #)
  ];
  my-python = pkgs.python310.withPackages my-python-packages;
in my-python.env
