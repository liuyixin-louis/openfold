# Install DeepMind's OpenMM patch
ENV_NAME=openf
OPENFOLD_DIR=$PWD
pushd lib/conda/envs/$ENV_NAME/lib/python3.7/site-packages/ \
    && patch -p0 < $OPENFOLD_DIR/lib/openmm.patch \
    && popd

# Download folding resources
wget -q -P openfold/resources \
    https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt

# Certain tests need access to this file
mkdir -p tests/test_data/alphafold/common
ln -rs openfold/resources/stereo_chemical_props.txt tests/test_data/alphafold/common

echo "Downloading OpenFold parameters..."
bash scripts/download_openfold_params_huggingface.sh openfold/resources

echo "Downloading AlphaFold parameters..."
bash scripts/download_alphafold_params.sh openfold/resources

# Decompress test data
gunzip tests/test_data/sample_feats.pickle.gz